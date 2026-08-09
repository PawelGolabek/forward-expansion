draw_self();

draw_set_font(Font3);

var _text = string(global.crystals);
var _ox = x;
var _oy = y;
var _outline_color = c_black;
var _text_color = c_yellow;

// 1) Draw 8-direction outline
draw_set_colour(_outline_color);
draw_text(_ox - 1, _oy - 1, _text);
draw_text(_ox,     _oy - 1, _text);
draw_text(_ox + 1, _oy - 1, _text);
draw_text(_ox - 1, _oy,     _text);
draw_text(_ox + 1, _oy,     _text);
draw_text(_ox - 1, _oy + 1, _text);
draw_text(_ox,     _oy + 1, _text);
draw_text(_ox + 1, _oy + 1, _text);

// 2) Draw main text on top
draw_set_colour(_text_color);
draw_text(_ox, _oy, _text);