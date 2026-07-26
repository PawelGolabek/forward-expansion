/// @description Draw Event — o_terrain_generator
/// Draws a line connecting the guaranteed climbable o_flat_surface tiles
/// (apex to base), so you can visually confirm the path.
/// Delete/disable this event once you're happy — it's a debug aid.

draw_set_color(path_line_color);

for (var r = 0; r < rows - 1; r++) {
    var a = path_inst[r];
    var b = path_inst[r + 1];
    if (a != noone && b != noone && instance_exists(a) && instance_exists(b)) {
        draw_line_width(a.x, a.y, b.x, b.y, path_line_width);
    }
}

draw_set_color(c_white); // reset so it doesn't leak into other draw code
