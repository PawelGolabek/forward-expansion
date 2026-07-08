event_inherited()

visible = true;
image_alpha = 1;

originX = x;
originY = y;

logList = ds_list_create();
turn = 1;
show_debug_message("visible = " + string(visible));
// scrolling
scroll_y = 0;
scroll_speed = 40;
max_visible_height = 430;
wrap_width = 360;

// panel position (GUI space)
panel_x = x + 30;
panel_y = y + 40;

function log(message1)
{
    ds_list_add(logList, string(message1));

    // Calculate total height
    var total_h = 0;
    for (var i = 0; i < ds_list_size(logList); i++)
    {
        total_h += string_height_ext(logList[| i], 14, wrap_width) + 4;
    }

    scroll_y = max(0, total_h - max_visible_height);
}

function scrollEvent(_scroll){
    scroll_y -= _scroll * scroll_speed;
}
