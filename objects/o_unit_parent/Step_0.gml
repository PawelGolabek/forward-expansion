if (mouse_check_button_pressed(mb_left))
{
    if (position_meeting(mouse_x, mouse_y, id))
    {
        dragging = true;
    }
}

if (dragging)
{
    x = mouse_x;
    y = mouse_y;

    if (!mouse_check_button(mb_left))
    {
        dragging = false;
    }
}