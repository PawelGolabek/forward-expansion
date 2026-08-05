// Create
ulets = [];
units = [];
trees = [];
checkedFoW = false;

circle_surface = surface_create(room_width, room_height);


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