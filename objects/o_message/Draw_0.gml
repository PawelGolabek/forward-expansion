
draw_set_font(Font3_1);

var line_height = string_height("Ag") + line_spacing;
var text_width = 0;
for (var i = 0; i < text_line_count; i++)
{
    text_width = max(text_width, string_width(text_lines[i]));
}
var box_width = text_width + padding * 2;
var box_height = text_line_count * line_height + padding * 2;

var t = clamp(life / life_time, 0, 1);
var fade_start = 0.3; // starts fading when 30% of life remains
var fade_alpha = (t > fade_start) ? 1 : (t / fade_start);
fade_alpha = fade_alpha * fade_alpha; // non-linear taper

// Dark semi-transparent background.
draw_set_alpha(fade_alpha);
draw_set_color(c_black);
draw_rectangle(
    x,
    y,
    x + box_width,
    y + box_height,
    false
);

// Text.
draw_set_alpha(fade_alpha);
draw_set_color(c_white);
for (var i = 0; i < text_line_count; i++)
{
    draw_text(
        x + padding,
        y + padding + i * line_height,
        text_lines[i]
    );
}

draw_set_alpha(1);
draw_set_color(c_white);