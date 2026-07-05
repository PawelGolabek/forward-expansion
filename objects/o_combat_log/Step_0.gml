// clamp scroll so we can't scroll past top or past bottom
draw_set_font(fnt_log);

var _total_h = 0;
for (var i = 0; i < ds_list_size(logList); i++)
{
    var _h = string_height_ext(logList[| i], -1, wrap_width);
    _total_h += _h + 4;
}

var _max_scroll = max(0, _total_h - max_visible_height);
scroll_y = clamp(scroll_y, 0, _max_scroll);