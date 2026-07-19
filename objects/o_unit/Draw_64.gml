cam = view_camera[0];
viewX = camera_get_view_x(cam);
viewY = camera_get_view_y(cam);
viewW = camera_get_view_width(cam);
viewH = camera_get_view_height(cam);
guiX = (x - viewX) * display_get_gui_width() / viewW;
guiY = (y - viewY) * display_get_gui_height() / viewH;
		
xx = guiX;
yy = guiY;
// Draw event
if (expectedDamage > 0)
{
    draw_set_font(Font3);

    var txt = string(expectedDamage);

    // Thick black outline
    draw_set_alpha(0.9);
    draw_set_colour(c_black);

    for (var ox = -2; ox <= 2; ox++)
    {
        for (var oy = -2; oy <= 2; oy++)
        {
            if (ox != 0 || oy != 0)
                draw_text(xx + ox, yy + oy, txt);
        }
    }

    // Main text
    draw_set_colour(c_red);
    draw_text(xx, yy, txt);

    // Small highlight
    draw_set_alpha(0.35);
    draw_set_colour(c_white);
    draw_text(xx - 1, yy - 1, txt);

    draw_set_alpha(1);
    draw_set_colour(c_white);
}

expectedDamage = 0;


_expected = calculateDamageExpectedDelayed()


if (_expected > 0)
{
    draw_set_font(Font3);

    xx = guiX;
    yy = guiY + 35 * o_camera_controller.zoom;
    var txt = string(_expected) + string(drag_draw_offset);
	shader_set(shd_outline)
    // Main text
    draw_set_colour(c_orange);
    draw_text(xx, yy, txt);

    // Small highlight
    draw_set_alpha(0.35);
    draw_set_colour(c_white);
    draw_text(xx - 1, yy - 1, txt);

    draw_set_alpha(1);
    draw_set_colour(c_white);
	shader_reset()
}
