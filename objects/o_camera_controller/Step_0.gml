// ============================================================
// MOUSE POSITION
// ============================================================

var mx = window_mouse_get_x();
var my = window_mouse_get_y();

var _win_mx = mx;
var _win_my = my;


// ============================================================
// GUI MOUSE POSITION
// ============================================================

var _gui_mx = _win_mx *
    (display_get_gui_width() / window_get_width());

var _gui_my = _win_my *
    (display_get_gui_height() / window_get_height());

var _ui_hit = noone;


// ============================================================
// LEFT MOUSE BUTTON
// ============================================================

if (mouse_check_button_pressed(mb_left))
{
    with (o_ui_element)
    {
        var w = sprite_width;
        var h = sprite_height;

        var left   = x;
        var top    = y;
        var right  = x + w;
        var bottom = y + h;

        if (point_in_rectangle(
            _gui_mx,
            _gui_my,
            left,
            top,
            right,
            bottom
        ) && visible)
        {
            _ui_hit = id;
            break;
        }
    }

    if (_ui_hit != noone)
    {
        with (_ui_hit)
        {
            mouseEvent();
        }
    }
    else
    {
        with (o_unit)
        {
            if (dragging)
            {
                mouseEvent();
                break;
            }
        }
    }
}


// ============================================================
// MIDDLE MOUSE CAMERA DRAG
// ============================================================

if (mouse_check_button_pressed(mb_middle))
{
    dragging = true;

    mx = window_mouse_get_x();
    my = window_mouse_get_y();

    prev_mouse_x = mx;
    prev_mouse_y = my;
}


// Stop drag
if (!mouse_check_button(mb_middle))
{
    dragging = false;
}


// ============================================================
// CAMERA DRAG
// ============================================================

if (dragging)
{
    var dx = (mx - prev_mouse_x) / zoom;
    var dy = (my - prev_mouse_y) / zoom;

    cam_x -= dx;
    cam_y -= dy;
}


// ============================================================
// MOUSE WHEEL ZOOM
// ============================================================

var scroll = mouse_wheel_up() - mouse_wheel_down();

if (scroll != 0)
{
    _ui_hit = noone;

    with (o_ui_element)
    {
        if (point_in_rectangle(
            _gui_mx,
            _gui_my,
            x,
            y,
            x + sprite_width,
            y + sprite_height
        ) && visible)
        {
            _ui_hit = id;
            break;
        }
    }

    if (_ui_hit != noone)
    {
        with (_ui_hit)
        {
            scrollEvent(scroll);
        }
    }
    else
    {
        // Keep the world position under the mouse fixed.
        var old_zoom = zoom;

        var world_x = cam_x + mx / old_zoom;
        var world_y = cam_y + my / old_zoom;

        zoom = clamp(
            zoom + scroll * zoom_speed,
            zoom_min,
            zoom_max
        );

        cam_x = world_x - mx / zoom;
        cam_y = world_y - my / zoom;
    }
}


// ============================================================
// WASD CAMERA MOVEMENT
// ============================================================

var move_x = keyboard_check(ord("D"))
           - keyboard_check(ord("A"));

var move_y = keyboard_check(ord("S"))
           - keyboard_check(ord("W"));

if (move_x != 0 || move_y != 0)
{
    // Prevent diagonal movement from being faster.
    var move_length = point_distance(
        0,
        0,
        move_x,
        move_y
    );

    move_x /= move_length;
    move_y /= move_length;

    var camera_speed = 10 / zoom;

    cam_x += move_x * camera_speed;
    cam_y += move_y * camera_speed;
}


// ============================================================
// CAMERA VIEW SIZE
// ============================================================

var view_w = window_get_width() / zoom;
var view_h = window_get_height() / zoom;


// ============================================================
// CAMERA CLAMP
// ============================================================

if (view_w >= room_width)
{
    cam_x = (room_width - view_w) / 2;
}
else
{
    cam_x = clamp(
        cam_x,
        0,
        room_width - view_w
    );
}


if (view_h >= room_height)
{
    cam_y = (room_height - view_h) / 2;
}
else
{
    cam_y = clamp(
        cam_y,
        0,
        room_height - view_h
    );
}


// ============================================================
// APPLY CAMERA
// ============================================================

camera_set_view_pos(
    cam,
    cam_x,
    cam_y
);

camera_set_view_size(
    cam,
    view_w,
    view_h
);


// ============================================================
// UPDATE MOUSE POSITION
// ============================================================

prev_mouse_x = mx;
prev_mouse_y = my;


// ============================================================
// FULLSCREEN
// ============================================================

if (keyboard_check_pressed(vk_f11))
{
    window_set_fullscreen(
        !window_get_fullscreen()
    );
}