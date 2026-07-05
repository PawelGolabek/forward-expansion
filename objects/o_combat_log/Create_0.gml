visible = true;
image_alpha = 1;

logList = ds_list_create();
turn = 1;
show_debug_message("visible = " + string(visible));
// scrolling
scroll_y = 0;
scroll_speed = 40;
max_visible_height = 500;
wrap_width = 400;

// panel position (GUI space)
panel_x = 0;
panel_y = 100;

function log(message1){
    ds_list_add(logList, string(message1));
    scroll_y = 0; // auto-scroll to newest
}

function scrollEvent(_scroll){
    scroll_y -= _scroll * scroll_speed;
}

show_debug_message("LOG OBJECT CREATED");