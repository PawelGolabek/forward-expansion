
draw_self()
draw_set_font(fnt_log);

var _line_sep = 14;

var _total_h = 0;

for (var i = 0; i < ds_list_size(logList); i++)
{
    var _msg = logList[| i];

    var _h = string_height_ext(_msg, _line_sep, wrap_width);
    _total_h += _h + 4;
}

var _max_scroll = max(0, _total_h - max_visible_height);
scroll_y = clamp(scroll_y, 0, _max_scroll);

var _panel_x = 900;
var _panel_y = 100;

var _y = _panel_y;

for (var i = 0; i < ds_list_size(logList); i++)
{
    var _msg = logList[| i];

    var _h = string_height_ext(_msg, _line_sep, wrap_width);

    var _draw_y = _y - scroll_y;

    if (_draw_y + _h > _panel_y && _draw_y < _panel_y + max_visible_height)
    {
        draw_text_ext(_panel_x, _draw_y, _msg, _line_sep, wrap_width);
    }

    _y += _h + 4;
}