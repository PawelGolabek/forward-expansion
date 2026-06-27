var mx = mouse_x;
var my = mouse_y;

// start drag
if (mouse_check_button_pressed(mb_middle))
{
    dragging = true;
}

// stop drag
if (!mouse_check_button(mb_middle))
{
    dragging = false;
}

// pan
if (dragging)
{
    cam_x -= (mx - prev_mouse_x);
    cam_y -= (my - prev_mouse_y);
}

// zoom
var scroll = mouse_wheel_up() - mouse_wheel_down();

if (scroll != 0)
{
    var old_zoom = zoom;

    var mx = mouse_x;
    var my = mouse_y;

    // screen → world before zoom
    var world_x = cam_x + mx / old_zoom;
    var world_y = cam_y + my / old_zoom;

    zoom = clamp(zoom + scroll * zoom_speed, zoom_min, zoom_max);

    // keep mouse point fixed after zoom
    cam_x = world_x - mx / zoom;
    cam_y = world_y - my / zoom;
}

// apply
camera_set_view_pos(cam, cam_x, cam_y);
camera_set_view_size(cam, 1920 / zoom, 1080 / zoom);

// update previous mouse
prev_mouse_x = mx;
prev_mouse_y = my;

if (keyboard_check_pressed(vk_f11))
{
    window_set_fullscreen(!window_get_fullscreen());
}