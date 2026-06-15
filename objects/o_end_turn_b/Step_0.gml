if (mouse_check_button_pressed(mb_left))
{
    if (position_meeting(mouse_x, mouse_y, id))
    {
        var r = instance_find(o_combat_resolver, 0);
        if (r != noone) r.resolve_combat();
    }
}