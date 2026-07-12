var cam = view_camera[0];

var viewX = camera_get_view_x(cam);
var viewY = camera_get_view_y(cam);
var viewW = camera_get_view_width(cam);
var viewH = camera_get_view_height(cam);

var guiX = (x - viewX) * display_get_gui_width() / viewW;
var guiY = (y - viewY) * display_get_gui_height() / viewH;
		
	// Draw event
shader_set(shd_outline);


shader_set_uniform_f(u_outlineColor, 0.0, 0.0, 0.0, 1.0); // black
	
if (expectedDamage > 0) {
    draw_set_font(Font3_shadow);
	draw_text(guiX - 5, guiY - 94,string(expectedDamage));
}


shader_reset();

		
if (expectedDamage > 0) {
    draw_set_font(Font3);
	draw_text_ext_colour(guiX, guiY - 89,string(expectedDamage),0, 200, c_grey,c_dkgrey,c_dkgray,c_black,0.9 );
}
expectedDamage = 0;



