var tilemap = layer_tilemap_get_id("Tiles_1");
tilemap_get_at_pixel(tilemap,x,y)


outline_surf = scr_draw_sprite_outline(
    sprite_index, image_index,
    x, y,
    image_xscale, image_yscale,
    c_white, image_alpha,   // sprite blend/alpha
    4, c_black,              // outline thickness (px), outline colour
    outline_surf
);



if (redGlow){
outline_surf = scr_draw_sprite_outline(
    sprite_index, image_index,
    x, y,
    image_xscale, image_yscale,
    c_white, image_alpha,   // sprite blend/alpha
    2, c_red,              // outline thickness (px), outline colour
    outline_surf
);
	redGlow = false;
} else if (glow) {
outline_surf = scr_draw_sprite_outline(
    sprite_index, image_index,
    x, y,
    image_xscale, image_yscale,
    c_white, image_alpha,   // sprite blend/alpha
    2, c_yellow,              // outline thickness (px), outline colour
    outline_surf
);
	glow = false;
}



if(not noEyes){
	lPupil.movePupil();
	rPupil.movePupil();
	lEye.moveEye();
	rEye.moveEye();
	lEyeLid.moveEye();
	rEyeLid.moveEye();
}

shader_reset();
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, image_alpha);