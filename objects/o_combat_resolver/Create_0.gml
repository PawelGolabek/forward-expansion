global.deployHighlight = noone
global.draggingUnit = noone

function resolve_combat(){
	
    ds_queue_enqueue(o_clock.action_queue, {
        // FIXED: Use 'id' instead of 'self' to guarantee a solid instance reference
    
        func: function() {
            show_debug_message("resolving!");
				o_combat_log.log("Combat resolution initiated");

		with(o_unit){
			if(target != noone){
				target.damageTaken += damage;
				if(target.logHit){
					o_combat_log.log(string(target.allegience) + "'s " + string(target.name) + " got hit by " + string(target.allegience) + "'s "  + string(name) + " by " + string(damage));
				}
			}
		}
	
		with(o_unit){
			hp -= damageTaken;
			if(damageTaken){
				hit_timer = 8; // flash for 8 frames
			}
			damageTaken = 0
			if(hp <= 0){
				if(logDeath){
					o_combat_log.log(string(target.allegience) + "'s " + name + " died");					
				}
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
	});
}

function resolve_first_strike(){
	
	with(o_unit){
		show_debug_message(global.dropped.x)
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