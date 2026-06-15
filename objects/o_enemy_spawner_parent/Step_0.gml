if (mouse_check_button_pressed(mb_left))
{
    if (position_meeting(mouse_x, mouse_y, id))
    {
        var inst = instance_create_layer(mouse_x, mouse_y, layer, spawn_object);
        inst.dragging = true;
    }
}