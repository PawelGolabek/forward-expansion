/// @description Demonstration


// Try to cache the return of .get_mouse() as much as you can

draw_text(48, 10, "\"Clear Display Buffer\" must be UNCHECKED for interlacing.");
draw_text(32, 256, "The double images below should change smoothly with interlacing.\n      Violent flicker or flashing means something is wrong.");

draw_circle_color(cos(current_time / 1000) * 256 + 320, 64, 16, c_white, c_red, false);
draw_circle_color(cos(current_time / 500) * 256 + 320, 128, 16, c_white, c_lime, false);
draw_circle_color(cos(current_time / 250) * 256 + 320, 192, 16, c_white, c_blue, false);

draw_sprite_part_ext(spr_example_320w, 0, cos(my_crt._frame_counter*pi) * (sin(current_time / 1000) * 8) + 48, 64, 128, 64, 128, 320, 1, 1, c_white, 1);
draw_sprite_part_ext(spr_example_320w, 0, 48, cos(my_crt._frame_counter*pi) * (sin(current_time / 1000) * 8) + 64, 128, 64, 384, 320, 1, 1, c_white, 1);

var mouse = my_crt.get_mouse();
if mouse.valid {
	draw_circle_color(mouse.x, mouse.y, 16, c_red, c_red, false);
	//draw_text(mouse.x, mouse.y, string(mouse.view_index));
}
	