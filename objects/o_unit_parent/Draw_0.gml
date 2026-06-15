draw_self();
var w = 40;
var h = 6;

var x1 = x - w * 0.5;
var y1 = y - 30;

var hp_ratio = hp / maxhp;

// background
draw_set_color(c_red);
draw_rectangle(x1, y1, x1 + w, y1 + h, false);

// fill
draw_set_color(c_lime);
draw_rectangle(x1, y1, x1 + (w * hp_ratio), y1 + h, false);

draw_set_color(c_white);