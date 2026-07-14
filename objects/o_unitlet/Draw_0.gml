var tilemap = layer_tilemap_get_id("Tiles_1");
tilemap_get_at_pixel(tilemap,x,y)

var cam = view_camera[0];
var vx = camera_get_view_x(cam) - 50;
var vy = camera_get_view_y(cam) - 50;
var vw = camera_get_view_width(cam) + 100;
var vh = camera_get_view_height(cam) + 100;

if (bbox_right < vx ||
    bbox_left > vx + vw ||
    bbox_bottom < vy ||
    bbox_top > vy + vh)
{
    exit; // Don't draw
}
// Draw event
shader_set(shd_outline);


shader_set_uniform_f(u_outlineColor, 0.0, 0.0, 0.0, 1.0); // black

draw_sprite_ext(sprite_index, image_index, x, y, image_xscale*1.2, image_yscale*1.2, image_angle, c_white, image_alpha);


if (redGlow){
	shader_set_uniform_f(u_outlineColor, 1.0, 0.0, 0.0, 1.0); // red	
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale*1.1, image_yscale*1.1, image_angle, c_white, image_alpha);

	redGlow = false;
} else if (glow) {
    shader_set_uniform_f(u_outlineColor, 1.0, 1.0, 0.0, 1.0); // yellow
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale*1.1, image_yscale*1.1, image_angle, c_white, image_alpha);
	glow = false;
}

shader_reset();


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