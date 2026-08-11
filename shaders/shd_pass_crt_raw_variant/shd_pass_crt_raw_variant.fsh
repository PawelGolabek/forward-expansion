
varying vec2 v_vTexcoord;

uniform vec2 u_content_size;
uniform vec2 u_output_size;
uniform vec2 u_output_offset;

uniform float u_aspect_ratio;
uniform float u_zoom;
uniform float u_curvature;
uniform float u_do_int_scale;
uniform float u_image_softness;
uniform float u_do_tate;
uniform float u_min_sigma;
uniform float u_max_sigma;
uniform float u_line_brightness;
uniform float u_mask_strength;
uniform float u_slot_strength;
uniform float u_mask_do_shadow;
uniform float u_mask_tex_width;
uniform float u_mask_scale;
uniform float u_mask_repeat_on_three;
uniform float u_do_mask_mirror;
uniform float u_mask_fade;
uniform float u_border_width;
uniform float u_border_brightness;
uniform float u_time;
uniform float u_bloom_strength;
uniform float u_deconvergence;
uniform float u_gamma;
uniform float u_do_interlace;

uniform sampler2D u_mask_sampler;
uniform sampler2D u_slot_sampler;
uniform sampler2D u_bloom_sampler;

// See shd_pass_crt for the fully commented function
vec4 geometry() {
	float nearest_int = (u_content_size.y * floor(u_output_size.y / u_content_size.y));
    float vertical_scale = 1.0 + (u_do_int_scale * (-1.0 + u_output_size.y / nearest_int));
    float aspect = u_output_size.x / (u_output_size.y * u_aspect_ratio);
    vec2 uv = ((v_vTexcoord - 0.5) * vertical_scale * u_zoom) + 0.5;
    uv.x = ((uv.x - 0.5) * aspect) + 0.5;
    vec2 centered = uv - 0.5;
    float r = length(centered);
    float r2 = r * r;
    float distortion_factor = 1.0 + u_curvature * r2;
    uv = centered * distortion_factor;
    float scale_factor = 1.0 / (1.0 + u_curvature * 0.25);
    uv *= scale_factor;
	uv += 0.5;
	uv += u_output_offset;
	float width = max(1.0 / u_output_size.x, 1.0 / u_output_size.y) * 4.0;
    float dist = min(min(uv.x + width, width + 1.0 - uv.x), min(uv.y + width, width + 1.0 - uv.y));
	vec2 border = vec2(1.0 - smoothstep(0.0, width, dist), -dist);
	border.x = min(border.x, smoothstep(0.0, width, dist+u_border_width));
	uv = -abs(1.0 - abs(uv)) + 1.0;
	uv = (uv - 0.5) / (1.0 + (border.x * border.y) * 1.0) + 0.5;
    return vec4(uv, border);
}


void main()
{
	vec4 bits = geometry();
	vec2 uv = bits.xy;
	float border_mask = bits.z;
	float border_dist = bits.w;
	
	vec4 color = texture2D(gm_BaseTexture, uv);
	
	if (border_dist > 0.0) {
		color.rgb = vec3(0.0);
	}
	
	gl_FragColor = color;
}
