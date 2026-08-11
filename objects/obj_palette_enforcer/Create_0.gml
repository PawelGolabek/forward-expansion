

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
    "#4d004c", "#8f0076", "#c70083", "#f50078", "#ff4764", "#ff9393",
    "#ffd5cc", "#fff3f0", "#000221", "#000769", "#00228f", "#0050c7",
    "#008bf5", "#00bbff", "#47edff", "#93fff8"
]));

global.palette_enforcer.set_palette(palette_from_hex_array([
    "#6816bf", "#692fe5", "#a134e0", "#bc43e8", "#ef64ff", "#f882ff",
    "#ff81ee", "#fdaeff", "#ffcbf7", "#ffe0f6", "#ffb9d1", "#ff90cb",
    "#ff40c5", "#b4007b", "#d90387", "#f20095", "#f73080", "#d5606d",
    "#ea857c", "#ff9d89", "#ffd192", "#f0d28e", "#ccc45d", "#adbe64",
    "#70ae41", "#b4d581", "#def5a9", "#fdfff7", "#fcffd5", "#fff994",
    "#91ffaa", "#0ef4a3", "#00cfc1", "#42fff8", "#1adcff", "#0bbbf5",
    "#00a3de", "#00a5d3", "#008cde", "#5a5af8"
]));


global.palette_enforcer.set_palette(palette_from_hex_array([
    "#020918", "#424e66", "#93a5be", "#f2f2f2", "#ffff99", "#f4d01a",
    "#a65805", "#3c1701", "#4d0a00", "#9d2c07", "#ea7d10", "#f8be49",
    "#c3f787", "#47d163", "#107a68", "#01253c", "#082525", "#03683e",
    "#21b039", "#8df34f", "#99e7f4", "#12c2f8", "#0341b5", "#020a55",
    "#030d30", "#0b6f9d", "#25e4c4", "#e5fbf3", "#bd7cee", "#9232ec",
    "#30008f", "#110132", "#4f024a", "#830165", "#b9138d", "#e057c9",
    "#faa3ab", "#ee113d", "#980b1c", "#3f0409", "#190400", "#ba5017",
    "#f4964e", "#fecc81"
]));


global.palette_enforcer.set_palette(palette_from_hex_array([
    "#120e24", "#1d1936", "#29244d", "#3b3469", "#534b8c", "#7067b3",
    "#00d5ff", "#009bbd", "#0d6a8a", "#0e3f5c", "#082138", "#030f1c",
    "#f0388d", "#c41a6e", "#940e50", "#630533", "#38001b", "#1a000a",
    "#2ee6a5", "#1bb37e", "#0f8059", "#064d35", "#02261a", "#00120d",
    "#ffaa33", "#d97a1e", "#a6510d", "#733100", "#401800", "#1f0900",
    "#c273e6", "#9947bd", "#6e238f", "#470d61", "#280238", "#12001c",
    "#e8ebf5", "#b4b9d1", "#7f86a8", "#505678", "#2c314a", "#151829"
]));

//default
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
