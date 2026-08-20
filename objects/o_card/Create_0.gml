
y = 500

function draw(){
	
	zoom = o_camera_controller.zoom;
	draw_self();

	draw_set_colour(c_black);
	draw_text(x, y + sprite_height/2 - 120 * zoom,"Unit info")
}