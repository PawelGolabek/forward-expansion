x = 0;
y = 0;


// Create
units = [];
trees = [];
checkedFoW = false;


	my_crt = new CRT();


circle_surface = surface_create(room_width, room_height);
app_surface = surface_create(room_width, room_height);


global.threatSurf = noone;
if (!surface_exists(global.threatSurf)) {
    global.threatSurf = surface_create(room_width, room_height);
}
mask_surface = surface_create(room_width, room_height);
// Initialize or recover surface
if (!surface_exists(mask_surface)) {
    mask_surface = surface_create(sprite_width, sprite_height);
}

function rect_in_draw_area(_left, _top, _right, _bottom) {
	// ---------------------------------------------------------
	// DRAW CULLING
	// ---------------------------------------------------------

	var cam = view_camera[0];

	var view_x = camera_get_view_x(cam);
	var view_y = camera_get_view_y(cam);
	var view_w = camera_get_view_width(cam);
	var view_h = camera_get_view_height(cam);

	// Extra area around the screen.
	// This prevents objects from popping in at the edge.
	var cull_margin = 128;

	var cull_left   = view_x - cull_margin;
	var cull_top    = view_y - cull_margin;
	var cull_right  = view_x + view_w + cull_margin;
	var cull_bottom = view_y + view_h + cull_margin;

	return _right >= cull_left
        && _left <= cull_right
        && _bottom >= cull_top
        && _top <= cull_bottom;
}
var overrides = {
	ntsc: {
		enabled: false,          // turns off the entire NTSC pre-pass -- no noise, no rainbow/dot-crawl, no chroma smear at all
		// values below only matter if you flip enabled back to true later
		quality: 8.0,             // max = cleanest sampling, least artifacting
		notch_filter_scale: 0.0001, // near-min = least rainbow/dot-crawl
		cable_noise: 0.0,         // no simulated signal noise
		hsync_failure: 0.0,       // already the "off" value
		vsync_failure: 0.0,       // already the "off" value
		chroma_smear: 0.0,        // no horizontal color bleed
		chroma_delay: 0.0,        // no luma/chroma offset
		color_saturation: 1.0,    // 1.0 = untouched color intensity
		color_temperature: 0.0    // 0 = untouched white balance
	},
	bloom: {
		enabled: false,           // turns off glow entirely -- no light bleed/blur added
		strength: 0.0,
		passes: 1
	},
	mask: {
		strength: 0.0,            // no phosphor/grille pattern drawn over the image
		slot_strength: 0.0,
		bright_fade: 1.0          // irrelevant with strength 0, left neutral
	},
	geometry: {
		// content_width / content_height still need to match your actual render
		// resolution -- there's no "neutral" value to guess here, tell me the
		// numbers if you want them filled in
		zoom: 1.0,                // 1.0 = no scaling
		curvature: 0.0,           // no barrel distortion
		offset_x: 0.0,
		offset_y: 0.0,
		border_width: 0.0,        // no reflection border eating into the frame
		border_brightness: 0.0
	},
	lines: {
		min_sigma: 1.0,           // max = beam nearly fills each line, scanline gaps barely visible
		max_sigma: 1.0,           // same, for bright pixels
		brightness: 1.0,          // no compensation boost needed since scanlines aren't darkening anything
		deconvergence: 0.0,       // no RGB channel separation
		gamma: -1                 // already the neutral sRGB passthrough
	}
}
my_crt = new CRT(overrides);