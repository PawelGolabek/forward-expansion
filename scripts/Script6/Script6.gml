// scr_draw_threat_circle (called with `with(o_unit)` scope)
function draw_threat_circle() {
    if (wantCircle or keyboard_check(vk_tab)) {
        draw_set_color(c_blue);
        draw_set_alpha(1);
        draw_half_circle(x, y - drag_draw_offset, range, 0, 180);
        draw_half_circle_scale(x, y, range, 180, 360, 1.0, 0.6);
        draw_set_alpha(1);
    }
}