/// @description How to use the mouse

// Try to cache the return of .get_mouse() as much as you can
	/*
	var mouse = my_crt.get_mouse();
	if mouse.valid {
		draw_circle_color(mouse.x, mouse.y, 16, c_blue, c_lime, false);
		draw_text(mouse.x, mouse.y, string(mouse.view_index));
	}
	*/