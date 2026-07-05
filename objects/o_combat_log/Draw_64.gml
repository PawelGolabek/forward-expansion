draw_set_font(fnt_log);
draw_set_valign(fa_top);
draw_set_halign(fa_left);

var _panel_x = 900;
var _panel_y = 100;

// optional: clip drawing to the panel area so text doesn't spill outside it
var _view_x1 = _panel_x;
var _view_y1 = _panel_y;
var _view_x2 = _panel_x + wrap_width;
var _view_y2 = _panel_y + max_visible_height;

gpu_set_scissor(_view_x1, _view_y1, _view_x2 - _view_x1, _view_y2 - _view_y1);

var _y = _panel_y - scroll_y;
for (var i = 0; i < ds_list_size(logList); i++)
{
    var _msg = logList[| i];
    var _h = string_height_ext(_msg, -1, wrap_width);
    
    // only draw if visible (basic culling)
    if (_y + _h >= _panel_y && _y <= _view_y2)
    {
        draw_text_ext(_panel_x, _y, _msg, -1, wrap_width);
    }
    
    _y += _h + 4;
}

gpu_set_scissor(-1, -1, -1, -1); // reset scissor