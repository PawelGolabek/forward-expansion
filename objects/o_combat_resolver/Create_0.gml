global.deployHighlight = noone
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
		    with(o_unit){
		        if(target == other.id) target = noone;
		    }
		    instance_destroy();
		}
	}
	
	with(o_unit){
		findNewTargetForSelf(); 
	}
	
	o_ai.ai_evaluate_and_place() 
	
}


function resolve_first_strike(){
	
	with(o_unit){
		if(point_distance(x, y, global.dropped.x, global.dropped.y) <= range and global.dropped.allegience != allegience and reactionStrike){
			global.dropped.damageTaken += self.damage;
		}
	}
	
	with(global.dropped){
		if(self.target != noone and firstStrike){
			target.damageTaken += self.damage;
		}
	}
	
	with(o_unit){
		if(damageTaken){
			hit_timer = 8;
			instance_create_depth(x,y,depth,o_blood_droplet)
		}
		hp -= damageTaken;
		damageTaken = 0
		if(hp <= 0){
			with(o_unit){
				if(target == other.id) target = noone;
			}
			instance_destroy();
		}
	}
}