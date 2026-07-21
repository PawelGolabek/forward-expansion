

// obj_palette_enforcer :: Step event

global.palette_enforcer.update(); // advances any in-progress transition_to()

// --- example hotkeys demonstrating runtime modification, delete/replace freely ---

if (keyboard_check_pressed(ord("1")))
{
    // Instant swap to grayscale
    global.palette_enforcer.set_palette([
        make_color_rgb(0, 0, 0), make_color_rgb(85, 85, 85),
        make_color_rgb(170, 170, 170), make_color_rgb(255, 255, 255)
    ]);
}

if (keyboard_check_pressed(ord("2")))
{
    // Smooth 60-frame transition to a warm palette, loaded from hex codes
    var _warm = palette_from_hex_array(["#2b0f0f", "#7a2c2c", "#c76b3d", "#f2c14e", "#fff6e0"]);
    global.palette_enforcer.transition_to(_warm, 60);
}

if (keyboard_check_pressed(ord("3")))
{
    global.palette_enforcer.set_dither(global.palette_enforcer.dither_strength > 0 ? 0 : 0.05);
}
