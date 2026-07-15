// Create event
outline_surf = -1;

// Draw event
outline_surf = scr_draw_sprite_outline(
    sprite_index, image_index,
    x, y,
    image_xscale, image_yscale,
    c_white, image_alpha,   // sprite blend/alpha
    2, c_black,              // outline thickness (px), outline colour
    outline_surf
);

