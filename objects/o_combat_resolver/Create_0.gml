global.draggingUnit = noone



function resolve_combat(){
	with(o_unit){
		if(target != noone){
			target.damageTaken += self.damage;	
		}
	}
	
	with(o_unit){
		hp -= damageTaken;
		if(damageTaken){
			hit_timer = 8; // flash for 8 frames
		}
		damageTaken = 0
		if(hp <= 0){
			instance_destroy(arrow);			
			instance_destroy();
		}
	}
}



function resolve_first_strike(){
	with(o_unit){
		if(distance_to_object(global.dropped) <= range and global.dropped.allegience != allegience){
			global.dropped.damageTaken += self.damage;
		}
	}
	with(global.dropped){
		if(self.target != noone){
			target.damageTaken += self.damage;
		}
	}
	
	with(o_unit){
		if(damageTaken){
			hit_timer = 8; // flash for 8 frames
			instance_create_depth(x,y,depth,o_blood_droplet)
		}
		hp -= damageTaken;
		damageTaken = 0
		if(hp <= 0){
			instance_destroy(arrow);
			instance_destroy();
		}
	}
}