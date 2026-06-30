if (mouse_check_button_pressed(mb_left))
{
    if (position_meeting(mouse_x, mouse_y, id) and active)
    {
		var units = layer_get_id("units");
        var inst = instance_create_layer(mouse_x, mouse_y, units, spawn_object);
        inst.dragging = true;
		global.draggingUnit = inst;
		global.crystals -= crystalCost
    }
}

if(global.crystals >= crystalCost){
	active = true;

}