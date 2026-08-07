

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



if (keyboard_check_pressed(ord("4")))
{
	global.palette_enforcer.set_palette(palette_from_hex_array([
	    "#662052", "#9e2468", "#d12c6c", "#f5456c", "#ff6e74", "#ffac99",
	    "#0c1538", "#1e316a", "#2d4f8a", "#4675a8", "#6ea8c9", "#a3d1e6",
	    "#d4e9f5", "#fafdfc", "#18331a", "#274a2b", "#3e6644", "#5e8766",
	    "#82a884", "#b5d4ba", "#1c1c38", "#343457", "#50507a", "#6f6f9c",
	    "#241d24", "#382938", "#524152", "#705f70", "#6e5714", "#997a1d",
	    "#c9a528", "#f5d440", "#fcf1c5", "#402213", "#5e371f", "#82512f",
	    "#a86f44", "#d49561", "#e6e6f0", "#b8b8cf", "#8a8aab", "#5d5d8c",
	    "#15152b"
	]));
}

if (keyboard_check_pressed(ord("5")))
{
	//default
	global.palette_enforcer.set_palette(palette_from_hex_array([
	    "#3d3957", "#242b4a", "#52216e", "#911d55", "#bf2651", "#f54f4f",
	    "#ff8766", "#ffac7f", "#ffd3a3", "#e6a3a3", "#995c95", "#524a63",
	    "#728794", "#a7b8c2", "#c6dbde", "#dfeded", "#99c2db", "#5d8bb3",
	    "#4d6a94", "#405578", "#357985", "#4c8f82", "#78b392", "#b5e0ba",
	    "#f0ece2", "#dfd3c3", "#c7b198", "#997d76", "#57404e", "#372840",
	    "#66333d", "#9c4f41", "#b3785d", "#d6a57a", "#e6cc8a", "#fafac3"
	]));

}