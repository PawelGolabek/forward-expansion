//
// SittingDuck's Advanced CRT Shader for GameMaker - Version 3.1
//

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

// Cheap RNG function
float rand(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

// Functions to convert a color from linear to either sRGB or an arbitrary gamma
// https://gamedev.stackexchange.com/questions/92015/optimized-linear-to-srgb-glsl
vec4 fromLinear(vec4 linearRGB)
{
	if (u_gamma > 0.0) {
		return vec4(pow(linearRGB.rgb, vec3(1.0/u_gamma)), linearRGB.a);
	} else {
		bvec3 cutoff = lessThan(linearRGB.rgb, vec3(0.0031308));
		vec3 higher = vec3(1.055)*pow(linearRGB.rgb, vec3(1.0/2.4)) - vec3(0.055);
		vec3 lower = linearRGB.rgb * vec3(12.92);
	
		return vec4(mix(higher, lower, vec3(cutoff)), linearRGB.a);
	}
}

vec4 toLinear(vec4 sRGB)
{
	// CRTs had gamma in the 2.5 range, and old content was mastered with this baked in.
	// However, most game devs nowawadys author assets on sRGB displays,
	// so an sRGB decode best matches the art that will likely be fed to the shader.
	// If you opt to replace it with pow(sRGB, vec4(2.5)), be prepared for crushed shadows on modern content.
	//return pow(sRGB, vec4(1.0));
    bvec3 cutoff = lessThan(sRGB.rgb, vec3(0.04045));
    vec3 higher = pow((sRGB.rgb + vec3(0.055))/vec3(1.055), vec3(2.4));
    vec3 lower = sRGB.rgb/vec3(12.92);

    return vec4(mix(higher, lower, vec3(cutoff)), sRGB.a);
}

// Function to sample the content with variable sharpness and with simulated beam deconvergence
vec4 sample_image(vec2 uv) {
    // Convert normalized UV to pixel coordinates
    vec2 pixels = uv * u_content_size;
    
    // Calculate the center of the texel containing the current UV
    vec2 nearest_center = floor(pixels) + 0.5;
    
    // Convert back to normalized UV space
    vec2 nearest_uv = nearest_center / u_content_size;
    
    // Lerp  between the snapped center and the original UV
    // 0.0 = Nearest neighbor (sharp)
    // 1.0 = Bilinear (soft)
	uv = mix(nearest_uv, uv, u_image_softness);
	
	// Calculate deconvergence in content pixel units
	vec2 deconvergence = u_deconvergence / u_content_size;
	vec4 final = vec4(texture2D(gm_BaseTexture, uv+deconvergence).r, texture2D(gm_BaseTexture, uv).g, texture2D(gm_BaseTexture, uv-deconvergence).b, 1.0);
	
	// If after a dedither / Sonic waterfall blurring behavior, use this instead
	//vec2 hblur = vec2(0.5/u_content_size.x, 0.0);
	//vec4 final = mix(texture2D(gm_BaseTexture, uv+hblur), texture2D(gm_BaseTexture, uv-hblur), 0.5);
    return toLinear(final);
}

// Function to handle scaling, aspect ratio, curvature, and masking out the border region
vec4 geometry() {
	// Find the largest integer multiple of the game height that fits in the output height
	float nearest_int = (u_content_size.y * floor(u_output_size.y / u_content_size.y));
	
	// Calculate a scaling factor between the output vertical texcoord and the game's, using int scale if desired
    float vertical_scale = 1.0 + (u_do_int_scale * (-1.0 + u_output_size.y / nearest_int));
    
	// Calculate how much to stretch the game horizontally given the aspect ratios of the game and output
    float aspect = u_output_size.x / (u_output_size.y * u_aspect_ratio);
    
	// Integrate everything into the correct (albeit flat) uv coordinates
    vec2 uv = ((v_vTexcoord - 0.5) * vertical_scale * u_zoom) + 0.5;
    uv.x = ((uv.x - 0.5) * aspect) + 0.5;
    
	// Now, apply curvature via barrel distortion
	// First, the UVs are shifted such that they range from -0.5 to 0.5
    vec2 centered = uv - 0.5;
	
	// Calculate quadratic distance from {0.0, 0.0}
	float r2 = dot(centered, centered);
    
	// Distort the UVs by multiplying them by the quadratic distance
    float distortion_factor = 1.0 + u_curvature * r2;
    uv = centered * distortion_factor;
    
	// The previous operation shrunk the whole screen nonlinearly,
	// but now they can be scaled back up linearly so the net result is curved corners
    float scale_factor = 1.0 / (1.0 + u_curvature * 0.25);
    uv *= scale_factor;
	
	// Shift the UVs back to the range 0.0 to 1.0
	uv += 0.5;
	
	// Shift the viewport to the user's preference
	uv += u_output_offset;
	
	// Get a mask to indicate whether the current fragment falls outside the crt
	// Calculate the width of the transition
	float width = max(1.0 / u_output_size.x, 1.0 / u_output_size.y) * 4.0;
    
	// Get the distance to the nearest edge of the crt
    float dist = min(
        min(uv.x + width, width + 1.0 - uv.x),
        min(uv.y + width, width + 1.0 - uv.y)
    );
	vec2 border = vec2(1.0 - smoothstep(0.0, width, dist), -dist);
	border.x = min(border.x, smoothstep(0.0, width, dist+u_border_width));
	
	// Wrap the UVs around the screen border, but flipped to simulate a reflection
	uv = -abs(1.0 - abs(uv)) + 1.0;
	
	// Skew the reflection for added realism
	uv = (uv - 0.5) / (1.0 + (border.x * border.y) * 1.0) + 0.5;
    
    // Finally, return the UVs and border flag
    return vec4(uv, border);
}

// Function to find the total brightness from all scanlines near a given fragment
float get_scanline_brightness(vec2 uv) {

	// Determine which field to draw when interlacing
	float field = mod(floor(u_time), 2.0);

    // Determine scan axis and extents
    float axis_pos = mix(uv.y * u_content_size.y, uv.x * u_content_size.x, u_do_tate);
    float axis_max = mix(u_content_size.y, u_content_size.x, u_do_tate);

    // Identify nearest line center
    float c_geo = floor(axis_pos) + 0.5;
    float dist_geo = axis_pos - c_geo;
    float dir = sign(dist_geo); // Direction to the next closest neighbor (+1.0 or -1.0)
    
    // Check if the line belongs to the current field
    float is_valid = 1.0 - abs(mod(floor(c_geo), 2.0) - field);

    // Interlacing is on, but we are on a skipped line (need both valid neighbors +/- 1)
    float S_inv = u_do_interlace * (1.0 - is_valid);
    // Interlacing is on, and we are on a live line (need current + next valid neighbor +/- 2)
    float S_val = u_do_interlace * is_valid;

    // Nearest live line center
    float off1 = -S_inv;
    
    // Second nearest live line center
    float off2 = mix(mix(dir, dir * 2.0, S_val), 1.0, S_inv);

    vec2 centers = vec2(c_geo + off1, c_geo + off2);

    // Evaluate a Gaussian for each line
    float total_weight = 0.0;
    
    for (int i = 0; i < 2; i++) {
        float center = centers[i];

        // Construct UV to sample source image at the center of this specific scanline
        float center_norm = center / axis_max;
        vec2 sample_uv = mix(vec2(uv.x, center_norm), vec2(center_norm, uv.y), u_do_tate);

        // Clamp to prevent bleeding from the opposite side of the texture when calculating wide beams
        sample_uv = clamp(sample_uv, 0.0, 1.0);

        // Sample brightness at the line center
        vec3 col = texture2D(gm_BaseTexture, sample_uv).rgb;
        float brightness = dot(col, vec3(0.299, 0.587, 0.114));

        // Interpolate between min and max beam width based on brightness
        float sigma = mix(u_min_sigma, u_max_sigma, brightness);

        // Calculate 1D Gaussian
        float dist = axis_pos - center;
        total_weight += exp(-(dist * dist) / (2.0 * sigma * sigma));
    }

    return clamp(total_weight, 0.0, 1.0) * u_line_brightness;
}

// Function to find the color of the phosphor mask at the given fragment
vec3 get_mask_color(float fadeout) {
	// Mirror the phosphor mask if required by the user
	float mirror = 1.0 - 2.0 * u_do_mask_mirror;
	
	// For the rgbx mask, the user can choose whether they want to drop the black column of pixels
	float repeat = 1.0 - (u_mask_repeat_on_three * 0.25);
	
	// Rotate the mask if in TATE mode, before any per-axis scaling
	vec2 frag_px = v_vTexcoord * u_output_size;
	frag_px = (u_do_tate > 0.5) ? frag_px.yx : frag_px;

	// Get from screen space to mask space
	float triad_size = u_mask_tex_width * u_mask_scale * repeat * mirror;
	vec2 mask_uv = mod(frag_px / triad_size, 1.0) * repeat;
	vec2 slot_uv = frag_px / vec2(u_mask_tex_width * 2.0 * repeat, 8.0) / u_mask_scale;

	// Convert to shadow mask (stagger) if desired
	float band = floor(frag_px.y * 2.0 / abs(triad_size));
	mask_uv.x = mod(mask_uv.x + (band / (2.0 * (1.0 + u_mask_repeat_on_three))) * u_mask_do_shadow, repeat);

	
	// Sample the mask for a color
	vec3 mask_color = texture2D(u_mask_sampler, mask_uv).xyz;
	
	// Subtract the slot mask from the color if desired
	mask_color *= 1.0 - (texture2D(u_slot_sampler, slot_uv).xyz * u_slot_strength);
	
	// Mix between the reduced brightness mask and white, and return
	return mix(vec3(1.0), mask_color, u_mask_strength / max(1e-4, mix(1.0, fadeout, u_mask_fade))) * u_line_brightness;
}

// Function to apply a basic blur to the screen borders
vec3 reflection(vec2 uv, float dist) {
	vec4 color = vec4(0.0);

	// Simple one-pass stochastic blur using 8 samples
	// (It's really just the Kawase upscale kernel, but stretched with distance)
	vec2 texel = 8.0 / u_content_size;
	texel *= dist / u_border_width;
	texel *= rand(uv + vec2(mod(u_time*64.0, 1000.0)));
	vec2 h = texel * 1.0;
	vec2 c = texel * 1.5;
			
	// Diagonals
	color += texture2D( gm_BaseTexture, uv + vec2( -h.x, -h.y)) * 2.0;
	color += texture2D( gm_BaseTexture, uv + vec2( -h.x,  h.y)) * 2.0;
	color += texture2D( gm_BaseTexture, uv + vec2(  h.x, -h.y)) * 2.0;
	color += texture2D( gm_BaseTexture, uv + vec2(  h.x,  h.y)) * 2.0;
	// Cardinals
	color += texture2D( gm_BaseTexture, uv + vec2( 0.0, -c.y));
	color += texture2D( gm_BaseTexture, uv + vec2( 0.0,  c.y));
	color += texture2D( gm_BaseTexture, uv + vec2(  -c.x, 0.0));
	color += texture2D( gm_BaseTexture, uv + vec2(  c.x,  0.0));
	// Reduce the values back down to 0-1
	color /= 12.0;
	
	// Add the result to the output
	return color.xyz * u_border_brightness * 0.1;
}

// Function to sample from the bloom texture
// This is the same dual kawase upscale filter as used in the bloom pre-pass
// We just have to do it one more time here because the final bloom texture is half res
vec4 get_bloom(sampler2D sampler, vec2 texCoords) {
	vec2 halfpixel = vec2(1.0/u_content_size) * 0.5;
    vec2 o = halfpixel;

    vec4 color = vec4(0.0);

    // Sample 4 edge centers with 1x weight each
    color += texture2D(sampler, texCoords + vec2(-o.x * 2.0, 0.0));
    color += texture2D(sampler, texCoords + vec2( o.x * 2.0, 0.0));
    color += texture2D(sampler, texCoords + vec2(0.0, -o.y * 2.0));
    color += texture2D(sampler, texCoords + vec2(0.0,  o.y * 2.0));

    // Sample 4 diagonal corners with 2x weight each
    color += texture2D(sampler, texCoords + vec2(-o.x,  o.y)) * 2.0;
    color += texture2D(sampler, texCoords + vec2( o.x,  o.y)) * 2.0;
    color += texture2D(sampler, texCoords + vec2(-o.x, -o.y)) * 2.0;
    color += texture2D(sampler, texCoords + vec2( o.x, -o.y)) * 2.0;

    // Apply bloom strength and normalize by total weight
    return toLinear(color / 12.0);
}

// Function like sqrt() over [0..1], but symmetrical along the y=1-x diagonal
float rational_curve(float x, float c) {
    return (x * (c + 1.0)) / (x * c + 1.0);
}

// Hue and Saturation-preserving tonemap operator
vec3 tonemap(vec3 c, float white) {
    float peak = max(max(c.r, c.g), max(c.b, 1e-5));
    if (peak <= 1e-5) return c;
    vec3 ratio = c / peak;

    // Extended Reinhard
    float w2 = max(white * white, 1e-5);
    float mapped = peak * (1.0 + peak / w2) / (1.0 + peak);

    // Pull ratio slightly toward white at high peak to mimic
    // real phosphor/CRT bloom desaturation
    //ratio = mix(ratio, vec3(1.0), pow(mapped, 4.0) * u_highlight_desat);
	float lo = min(min(c.r, c.g), c.b);
    float sat_gate = lo / peak;
    ratio = mix(ratio, vec3(1.0), pow(mapped, 4.0) * 0.5 * sat_gate);

    return ratio * mapped;
}


void main()
{
	// Get the warped UVs and border info
	vec4 bits = geometry();
	vec2 uv = bits.xy;
	float border_mask = bits.z;
	float border_dist = bits.w;
	
	// Sample the content
	vec4 color = sample_image(uv);
	
	if (border_dist < u_border_width*0.9) {
		// If within the screen+border region, calculate scanlines and mask
		float scan_lum = mix(get_scanline_brightness(uv), 1.0, 0.0);
		
		color.a *= mix(1.0, scan_lum, u_do_interlace); // Only alter alpha when interlacing (blending with previous frame)
		scan_lum = mix(scan_lum, u_line_brightness, u_do_interlace); // After attenuating alpha, keep lines at full brightness
		
		color.rgb *= scan_lum;
		color.rgb *= mix(get_mask_color(scan_lum), vec3(1.0), 0.0);
		
	} else {
		// If outside the border region, black
		color.rgb = vec3(0.0);
	}
	
	if (border_mask > 0.0) {
		// If within the border region, calculate the reflection
		float diffusion = clamp(((border_dist+1.0) * 1.0) / u_border_width, 0.0, 1.0);
		
		//vec3 reflection_color = mix(color.rgb, reflection(uv, border_dist), diffusion * diffusion);
		//reflection_color = vec3(diffusion * diffusion);
		vec3 reflection_color = reflection(uv, border_dist);
		reflection_color /= diffusion;
		
		color.rgb = mix(color.rgb, reflection_color, border_mask);
		
		// Could blend border with prior frames to smooth the stochastic blur
		// Breaks if "Clear Display Buffer" is checked... just like interlacing
		//color.a = mix(color.a, 0.2, border_mask);
	}
	
	// Add bloom if enabled and inside the screen+border region
	if ((u_bloom_strength > 0.0) && (border_dist < u_border_width)) {
		color.rgb = mix(color.rgb, get_bloom(u_bloom_sampler, uv).rgb * u_line_brightness, 0.05 * u_bloom_strength);
		
	}
	
	if (border_dist > u_border_width * 0.5) {
		color.rgb *= border_mask;
	}
	
	/*
	if (border_dist < 0.1) {
		float vignette_size = 0.25;
		float vignette_darkness = 0.25;
		float vignette_factor = smoothstep(0.0, vignette_size, max(0.0, -border_dist));
		color.rgb *= mix(vignette_darkness, 1.0, max(vignette_factor, border_mask));
	}
	*/
	
	//gl_FragColor = fromLinear(color);
	
	// Dithering to reduce banding
	color.rgb = tonemap(color.rgb, max(u_line_brightness, 1.0));
    vec4 final_output = fromLinear(color);
    
    float n1 = rand(v_vTexcoord + mod(u_time, 100.0));
    float n2 = rand(v_vTexcoord + mod(u_time + 0.5678, 100.0));
    
    float tri_noise = n1 - n2; 

    final_output.rgb += tri_noise / 255.0;
    
    gl_FragColor = final_output;
}
