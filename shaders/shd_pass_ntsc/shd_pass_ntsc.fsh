/*

Adapted from the following:

https://github.com/GlaireDaggers/Godot-RetroTV

MIT License

Copyright (c) 2024 Hazel Stagner

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


This single-pass NTSC composite signal simulation is strictly more expensive than a 2+ pass approach,
but worth it for simplicity and less pipeline state management.

*/

varying vec2 v_vTexcoord;

uniform vec2  u_resolution;
uniform float u_time;
uniform float u_carrier_sub;
uniform vec4  u_ntsc_config; // x: pps, y: ppf, z: noise, w: temporal
uniform vec2  u_sync_loss;
uniform int u_chroma_taps;
uniform float u_chroma_delay;
uniform float u_chroma_smear;
uniform float u_chroma_sat;
uniform float u_notch_scale;
uniform float u_temperature;

#define PI 3.14159265359

// Color space converters
vec3 rgb2yiq(vec3 rgb) {
    float y = dot(rgb, vec3(0.30, 0.59, 0.11));
    return vec3(
        y,
        0.74 * (rgb.r - y) - 0.27 * (rgb.b - y),
        0.48 * (rgb.r - y) + 0.41 * (rgb.b - y)
    );
}

vec3 yiq2rgb(vec3 y) {
    return vec3(
        y.x + 0.9469*y.y + 0.6236*y.z,
        y.x - 0.2748*y.y - 0.6357*y.z,
        y.x - 1.1000*y.y + 1.7000*y.z
    );
}

// Cheap RNG
float rand(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

// Function to fetch one tap of the source image in YIQ, honoring the blanking interval
vec3 get_tap_yiq(float uv_x, float line_jitter, float src_y, float mask_y) {

    float src_x = (uv_x + line_jitter) * u_notch_scale;

	// Simulate the blanking interval (the black borders signal outside the visible screen)
    // 1.17 = horizontal blanking
    src_x = fract(src_x * (1.0 / 1.17)) * 1.17;

	// Crop any pixels that fall into the blanking area
    float mask = step(-0.01, src_x) * step(src_x, 1.01) * mask_y;

    return rgb2yiq(texture2D(gm_BaseTexture, vec2(src_x, src_y)).rgb * mask);
}

// Function to build the composite signal for a single tap, given its carrier
float get_raw_signal(float uv_x, float s1, float c1, float noise, float line_jitter, float src_y, float mask_y) {

    vec3 yiq = get_tap_yiq(uv_x, line_jitter, src_y, mask_y);

    float chr1 = s1 * yiq.y + c1 * yiq.z;

    return yiq.x + chr1 + noise;
}

// Function to extract luma from the composite signal
float get_luma(vec2 uv, float phase_now, float noise, float line_jitter, float src_y, float mask_y) {
    float sum = 0.0;
    float inv_x = 1.0 / u_resolution.x;

    for (int i = 0; i < 8; i++) {
        if (float(i) >= u_carrier_sub) {
			break;
		}

        float uv_x = uv.x + float(i)*inv_x;

        float x = uv_x * u_resolution.x;
        float w = 2.0 * PI * x / u_carrier_sub;

        float s1 = sin(phase_now + w);
        float c1 = -cos(phase_now + w);

        sum += get_raw_signal(uv_x, s1, c1, noise, line_jitter, src_y, mask_y);
    }
    return sum / u_carrier_sub;
}

void main() {

	vec2 scaled_uv = v_vTexcoord / vec2(u_notch_scale, 1.0);

    float yline = scaled_uv.y * u_resolution.y;
    float fr = u_time;

    float phase_now  = 2.0 * PI * (u_ntsc_config.y * fr + u_ntsc_config.x * yline);

	// The previous frame's carrier lags the current one by a constant angle, so per tap
	// it can be derived from the current carrier by angle addition
	float phase_delta = 2.0 * PI * u_ntsc_config.y;
	float sin_d = sin(phase_delta);
	float cos_d = cos(phase_delta);

	float stepped_x = floor(gl_FragCoord.x / u_carrier_sub);

	// Add some line noise on the simulated composite cable
	float noise = (rand(vec2(stepped_x, scaled_uv.y) + vec2(mod(u_time * 64.0, 1000.0), 0.0)) * 2.0 - 1.0) * u_ntsc_config.z;

	// Row-constant signal terms, hoisted out of the per-tap sampling
	float line_jitter = (rand(vec2(0.0, scaled_uv.y + mod(u_time * 64.0, 1000.0))) - 0.5) * u_sync_loss.x;

	// Vertical blanking: 262.0 = standard NTSC scanlines per field
	float src_y = fract((scaled_uv.y + u_sync_loss.y) / (1.0 + 11.0/262.0)) * (1.0 + 11.0/262.0);
	float mask_y = step(0.0, src_y) * step(src_y, 1.0);

	// Get the luma information
    float y = get_luma(scaled_uv, phase_now, noise, line_jitter, src_y, mask_y);

	// Low pass filter to recover the chroma components
    float i_acc = 0.0;
    float q_acc = 0.0;

    float inv_x = 1.0 / u_resolution.x;
    float temporal = step(0.5, u_ntsc_config.w);

    float smear_width = u_chroma_smear * u_carrier_sub;

    float step_size = smear_width / max(1.0, float(u_chroma_taps));

    float half_taps = 0.5 * (float(u_chroma_taps) - 1.0);

	float base_x = scaled_uv.x * u_resolution.x;

    for (int j = 0; j < 32; j++) {
        if (j >= u_chroma_taps) break;

        float tap = float(j) - half_taps;

        float sample_offset = tap * step_size + u_chroma_delay * u_carrier_sub;

        // One carrier per tap shared between modulation and demodulation
        float x = base_x + sample_offset;
        float w = 2.0 * PI * x / u_carrier_sub;

        float s1 = sin(phase_now + w);
        float c1 = -cos(phase_now + w);
        float s2 = s1 * cos_d + c1 * sin_d;
        float c2 = c1 * cos_d - s1 * sin_d;

        vec3 yiq = get_tap_yiq(scaled_uv.x + sample_offset * inv_x, line_jitter, src_y, mask_y);

        float sig1 = yiq.x + (s1 * yiq.y + c1 * yiq.z) + noise;
        float sig2 = yiq.x + (s2 * yiq.y + c2 * yiq.z) + noise;

        float chr1 = sig1 - y;
        float chr2 = sig2 - y;

        float i_now = chr1 * s1;
        float q_now = chr1 * c1;
        float i_tmp = chr2 * s2;
        float q_tmp = chr2 * c2;

        i_acc += mix(i_now, 0.5 * (i_now + i_tmp), temporal);
        q_acc += mix(q_now, 0.5 * (q_now + q_tmp), temporal);
    }

    i_acc /= float(u_chroma_taps);
    q_acc /= float(u_chroma_taps);

	i_acc += 0.1 * u_temperature * y;

    vec3 rgb = yiq2rgb(vec3(y, i_acc * 2.0 * u_chroma_sat, q_acc * 2.0 * u_chroma_sat));

    gl_FragColor = vec4(rgb, 1.0);
}
