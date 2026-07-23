surface_set_target(fog_surface);
// Fill everything with black (unexplored/hidden)
draw_clear_alpha(c_black, 1);

// Switch blend mode so anything drawn now "erases" the black instead of drawing on top
gpu_set_blendmode(bm_subtract); 
// Or use bm_dest_alpha tricks — see note below on which method suits you

// Draw a white circle (or sprite) at each entity that grants vision

with(o_unit){
	if(allegience == "player"){
		draw_set_color(c_white);
		if(not dragging){
			draw_ellipse(x - revealRange, y - revealRange*0.6, x + revealRange, y + revealRange*0.6, false);
		}
	}
}
gpu_set_blendmode(bm_normal);
surface_reset_target();

// Now draw the surface over the whole screen
draw_surface(fog_surface, 0, 0);