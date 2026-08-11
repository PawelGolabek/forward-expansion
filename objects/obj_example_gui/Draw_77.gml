/// @description Demonstration

// If you want GUI elements to be a part of the CRT, do this in any object's Post-Draw event

crt_gui_begin();

var mouse = my_crt.get_mouse();
var pos = 0;
if mouse.valid {
	pos = round(mouse.x-160);
}
draw_rectangle_color(0, 224-32, 320, 224, c_dkgray, c_dkgray, c_black, c_black, false);
draw_sprite(spr_example_gui, 0, pos, 224-32);

crt_gui_end();


// Only do the CRT effect once the GUI has been drawn
my_crt.draw_to_backbuffer();
