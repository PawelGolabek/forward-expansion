
shader_set(shd_outline);

// draw stuff with the shader
draw_sprite_ext(sprite_index, image_index, x, y + owner.drag_draw_offset, image_xscale*1.1, image_yscale*1.1, image_angle, image_blend, image_alpha);


shader_reset();

draw_sprite_ext(sprite_index, image_index, x, y + owner.drag_draw_offset, image_xscale, image_yscale, image_angle, image_blend, image_alpha);




