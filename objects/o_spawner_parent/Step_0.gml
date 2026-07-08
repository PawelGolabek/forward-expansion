if(o_clock.blocked){
	active = false;
}else{
	if(global.crystals >= crystalCost){
		active = true;
	}
}
if(mousePressed){
	mousePressed = false;
	if (active and not selected){
		with(o_spawner_parent){
			selected = false;
		}
		with(o_unit){
			if(dragging){
				instance_destroy()
			}
		}
		selected = true;
		var units = layer_get_id("units");
	    var inst = instance_create_layer(mouse_x, mouse_y, units, spawn_object);
	    inst.dragging = true;
		global.draggingUnit = inst;
		global.crystals -= crystalCost
		inst.x = -9999;
		inst.y = -9999;
		inst.dragging = true;
	}
}
