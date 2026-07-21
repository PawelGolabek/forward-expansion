

// obj_palette_enforcer :: Create event
//
// Put this object in your very first room, make it persistent (or otherwise
// guaranteed to exist for the whole game). Turn OFF automatic drawing of the
// application surface — this object takes over drawing it, through the shader.

application_surface_draw_enable(false);

global.palette_enforcer = new PaletteEnforcer();

// Example starter palette — classic 8-colour retro set. Replace / extend anytime.
global.palette_enforcer.set_palette([
    make_color_rgb(  0,   0,   0),
  //  make_color_rgb(  255,   255,   0),
    make_color_rgb( 29,  43,  83),
    make_color_rgb(126,  37,  83),
    make_color_rgb(  0, 135,  81),
    make_color_rgb(171,  82,  54),
    make_color_rgb( 95,  87,  79),
    make_color_rgb(194, 195, 199),
    make_color_rgb(255, 241, 232)
]);
global.palette_enforcer.set_palette(palette_from_hex_array([
    "#172038", "#253a5e", "#3c5e8b", "#4f8fba", "#73bed3", "#a4dddb",
    "#19332d", "#25562e", "#468232", "#75a743", "#a8ca58", "#d0da91",
    "#4d2b32", "#7a4841", "#ad7757", "#c09473", "#d7b594", "#e7d5b3",
    "#341c27", "#602c2c", "#884b2b", "#be772b", "#de9e41", "#e8c170",
    "#241527", "#411d31", "#752438", "#a53030", "#cf573c", "#da863e",
    "#1e1d39", "#402751", "#7a367b", "#a23e8c", "#c65197", "#df84a5",
    "#090a14", "#10141f", "#151d28", "#202e37", "#394a50", "#577277",
    "#819796", "#a8b5b2", "#c7cfcc", "#ebede9"
]));

global.palette_enforcer.set_palette(palette_from_hex_array([
    "#3d3957", "#242b4a", "#52216e", "#911d55", "#bf2651", "#f54f4f",
    "#ff8766", "#ffac7f", "#ffd3a3", "#e6a3a3", "#995c95", "#524a63",
    "#728794", "#a7b8c2", "#c6dbde", "#dfeded", "#99c2db", "#5d8bb3",
    "#4d6a94", "#405578", "#357985", "#4c8f82", "#78b392", "#b5e0ba",
    "#f0ece2", "#dfd3c3", "#c7b198", "#997d76", "#57404e", "#372840",
    "#66333d", "#9c4f41", "#b3785d", "#d6a57a", "#e6cc8a", "#fafac3"
]));




global.palette_enforcer.set_dither(0.03);
global.palette_enforcer.set_perceptual(true);




