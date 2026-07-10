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


shader_set(shd_outline);

// draw stuff with the shader
draw_sprite_ext(sprite_index, image_index, x, y + owner.drag_draw_offset, image_xscale*1.1, image_yscale*1.1, image_angle, image_blend, image_alpha);


shader_reset();

draw_sprite_ext(sprite_index, image_index, x, y + owner.drag_draw_offset, image_xscale, image_yscale, image_angle, image_blend, image_alpha);




