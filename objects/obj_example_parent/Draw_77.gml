/// @description How to draw and use GUI

// If you want GUI elements to be a part of the CRT, do this in any object's Post-Draw event
	/*
	crt_gui_begin();
	draw_text(10, 10, "\n\nTest GUI");
	crt_gui_end();
	*/

// For most projects, you'll find it easiest to apply the effect to the application surface in the post-draw event
// Just be sure to do so after any GUI you want included in the screen

my_crt.draw_to_backbuffer();


// You can also draw manually wherever you'd like
	/*
	surface_set_target(wherever);
	my_crt.draw(application_surface, 200, 200, 1280, 720);
	surface_reset_target();
	*/
	