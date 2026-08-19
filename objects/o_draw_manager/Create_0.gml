x = 0;
y = 0;


// Create
units = [];
trees = [];
checkedFoW = false;

// bg thingys
fade_active = false;

fade_radius = 1.5;
fade_speed = 0.025;

fade_target_x = 0;
fade_target_y = 0;



fade_edge = 0.03;
// end bg thingys



my_surface_bg = surface_create(room_width, room_height);
circle_surface = surface_create(room_width, room_height);
app_surface = surface_create(room_width, room_height);
bones_surface = surface_create(room_width, room_height);


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