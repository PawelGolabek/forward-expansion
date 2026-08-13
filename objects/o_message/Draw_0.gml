
draw_set_font(Font3_1);

var t = clamp(life / life_time, 0, 1);
var fade_start = 0.3; // starts fading when 30% of life remains
var fade_alpha = (t > fade_start) ? 1 : (t / fade_start);
fade_alpha = fade_alpha * fade_alpha; // non-linear taper


var line_height = string_height("Ag") + line_spacing;
var text_width = 0;


for (var i = 0; i < text_line_count; i++)
{
    text_width = max(text_width, string_width(text_lines[i]));
}
var border_size = 2;
var inner_border = 2;
var text_padding = padding;

var outer_inset = border_size + inner_border;

var box_width = text_width + (text_padding + outer_inset) * 2;
var box_height = text_line_count * line_height
    + (text_padding + outer_inset) * 2;

var text_x = x + text_padding + outer_inset;
var text_y = y + text_padding + outer_inset;

// Background.
draw_set_alpha(fade_alpha);

// Outer black.
draw_set_color(c_black);
draw_rectangle(
    x,
    y,
    x + box_width,
    y + box_height,
    false
);

// White border.
draw_set_color(c_white);
draw_rectangle(
    x + border_size,
    y + border_size,
    x + box_width - border_size,
    y + box_height - border_size,
    false
);

// Inner black.
draw_set_color(c_black);
draw_rectangle(
    x + outer_inset,
    y + outer_inset,
    x + box_width - outer_inset,
    y + box_height - outer_inset,
    false
);

// Text.
draw_set_color(c_white);

for (var i = 0; i < text_line_count; i++)
{
    draw_text(
        text_x,
        text_y + i * line_height,
        text_lines[i]
    );
}

draw_set_alpha(1);
draw_set_color(c_white);