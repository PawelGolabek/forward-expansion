


if(o_clock.blocked or (o_clock.multipleDeploymentInProgress and not selected)){
	active = false;
}else{
	if(global.crystals >= crystalCost){
		active = true;
	}
}

if(o_clock.multipleDeploymentInProgress and deploymentsLeft and hardSelected){
	active = true;
}

if(mousePressed){
card.x = self.x;
card.y = self.y;
	mousePressed = false;
	if (active and not selected){
		hardSelected = true;
		with(o_spawner_parent){
			if(other.id != id){
				selected = false;
			}
		}
		with(o_unit){
			if(dragging){
				global.crystals += crystalCost;
				recalled = true;
				maxUnitlets = array_length(unitlets);
				for(i = 0; i < maxUnitlets; i+= 1){
					unitlets[i].recalled = true;
				}
				instance_destroy();
			}
		}
		selected = true;
		var units = layer_get_id("units");
	    var inst = instance_create_layer(mouse_x, mouse_y, units, spawn_object);
		inst.parentSpawner = self;
		inst.bornOfSpawner = true;
	    inst.dragging = true;
		inst.initiate();
		if(not deploymentsLeft){
			deploymentsLeft = inst.deploymentsLeft;
		}
		with(o_relic){
			self.onUnitCreation(inst);	// for relics
		}
		handleHeartsCreation(inst);
		inst.initiated = true
		global.draggingUnit = inst;
		global.crystals -= crystalCost
		inst.x = -9999;
		inst.y = -9999;
		inst.dragging = true;
	}
}else if (mouse_check_button(mb_right) and not o_clock.multipleDeploymentInProgress){
	deselect()
}


function deselect(){
	selected = false;
	global.dropped = noone;
	global.draggingUnit = noone;
	instance_destroy(global.draggingUnit);
}