if (active)
{
    draw_self();
}
else
{
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_gray, image_alpha);
}

draw_text(0,270,active)
draw_set_colour(c_yellow)
if(selected){
	draw_circle(x + sprite_width/2,y+sprite_height/2,sprite_width/2+40,true)
}