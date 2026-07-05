// raw window-space mouse — NOT affected by camera/view, so no feedback loop
var mx = window_mouse_get_x();
var my = window_mouse_get_y();

// start drag
if (mouse_check_button_pressed(mb_middle))
{
    dragging = true;
    mx = window_mouse_get_x();
    my = window_mouse_get_y();
    prev_mouse_x = mx;
    prev_mouse_y = my;
}

// stop drag
if (!mouse_check_button(mb_middle))
{
    dragging = false;
}

// pan — convert screen-pixel delta into world units via current zoom
if (dragging)
{
    var dx = (mx - prev_mouse_x) / zoom;
    var dy = (my - prev_mouse_y) / zoom;
    cam_x -= dx;
    cam_y -= dy;
}

// zoom
var scroll = mouse_wheel_up() - mouse_wheel_down();
if (scroll != 0)
{
    var _ui_hit = instance_position(window_mouse_get_x(), window_mouse_get_y(), o_ui_display);
    
    if (_ui_hit != noone)
    {
        with (_ui_hit)
        {
            scrollEvent(scroll);
        }
    }
    else
    {	
        var old_zoom = zoom;
        var world_x = cam_x + mx / old_zoom;
        var world_y = cam_y + my / old_zoom;
        zoom = clamp(zoom + scroll * zoom_speed, zoom_min, zoom_max);
        cam_x = world_x - mx / zoom;
        cam_y = world_y - my / zoom;
    }
}

// --- everything below now runs EVERY step, regardless of scroll/drag ---

// dynamic view size based on window's actual resolution, not hardcoded
var view_w = window_get_width()  / zoom;
var view_h = window_get_height() / zoom;

// cam_x/cam_y are currently top-left — convert to center, clamp CENTER only, convert back
var center_x = cam_x + view_w / 2;
var center_y = cam_y + view_h / 2;
center_x = clamp(center_x, 0, room_width);
center_y = clamp(center_y, 0, room_height);
cam_x = center_x - view_w / 2;
cam_y = center_y - view_h / 2;

// apply
camera_set_view_pos(cam, cam_x, cam_y);
camera_set_view_size(cam, view_w, view_h);

// update previous mouse
prev_mouse_x = mx;
prev_mouse_y = my;

if (keyboard_check_pressed(vk_f11))
{
    window_set_fullscreen(!window_get_fullscreen());
}