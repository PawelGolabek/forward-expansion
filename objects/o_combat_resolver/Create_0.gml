global.draggingUnit = noone

function resolve_combat(){
    
    ds_queue_enqueue(o_clock.action_queue, {    
        func: function() {
            o_combat_log.log("Combat resolution initiated");
            with(o_unit){
                if(target != noone){
                    target.damageTaken += damage;
                    if(target.logHit){
                        // FIXED: second reference was target.allegience/target.name, should be attacker's own (self)
                        o_combat_log.log(string(target.allegience) + "'s " + string(target.name) + " got hit by " + string(allegience) + "'s "  + string(name) + " by " + string(damage));
                    }
                }
            }
        
            with(o_unit){
                findNewTargetForSelf(); 
				checkInCombat()
            }
    
        //    o_ai.ai_evaluate_and_place() 
        
            with (o_unit)
                targetted = false;
            with (o_unit)
            {
                if (instance_exists(target))
                    target.targetted = true;
            }
            o_combat_log.turn += 1;		
            o_combat_log.log("Turn " + string(o_combat_log.turn));
                
        }});
		
}

function resolve_first_strike(){
    
    with (o_unit)
        targetted = false;
    with (o_unit)
    {
        if (instance_exists(target))
            target.targetted = true;
    }
    
    // SAFEGUARD: collect only the units actually involved in a first-strike
    // exchange this call, so the final resolution block below doesn't
    // touch/damage/kill-check every o_unit in existence.
    var _involved = ds_list_create();
    
    var _add_involved = function(_id) {
        var _list = argument[1];
        if (ds_list_find_index(_list, _id) == -1) {
            ds_list_add(_list, _id);
        }
    }
    
    with(o_unit){
        if(point_distance_ellipse(x, y, global.dropped.x, global.dropped.y, 0.6) <= range and global.dropped.allegience != allegience and reactionStrike){
            if(global.dropped.parry){			
                o_combat_log.log(string(global.dropped.allegience) + "'s " + string(global.dropped.name) + " parried " + string(allegience) + "'s " + string(name) + " and hit it back by " + string(damage));
                damageTaken += damage;
                global.dropped.parried = true;
                
                // self (the striker) took the parry damage — mark involved
                if (ds_list_find_index(_involved, id) == -1) ds_list_add(_involved, id);
            }else{		
                o_combat_log.log(string(global.dropped.allegience) + "'s " + string(global.dropped.name) + " got hit with the first strike by " + string(allegience) + "'s "  + string(name) + " by " + string(damage));
                global.dropped.damageTaken += damage;
                
                // global.dropped took the damage — mark involved
                if (ds_list_find_index(_involved, global.dropped.id) == -1) ds_list_add(_involved, global.dropped.id);
            }
        }
    }
    
    with(global.dropped){
        if(self.target != noone and firstStrike){
            target.damageTaken += damage;		
            o_combat_log.log(string(target.allegience) + "'s " + string(target.name) + " got hit with the first strike by " + string(allegience) + "'s "  + string(name) + " by " + string(damage));
            
            // target of dropped took damage — mark involved
            if (ds_list_find_index(_involved, target.id) == -1) ds_list_add(_involved, target.id);
        }
    }
    
    // SAFEGUARD: resolve damage/death only for units in _involved,
    // instead of `with(o_unit)` over every unit that exists.
    var _i = 0;
    repeat(ds_list_size(_involved)){
        var _inst = ds_list_find_value(_involved, _i);
        
        if(instance_exists(_inst)){
            with(_inst){
                if(damageTaken){
                    hit_timer = 8;
                }
                getDamaged(damageTaken, self);
                if(hp <= 0){
                    if(logDeath){ o_combat_log.log(string(allegience) + "'s " + string(name) + " died"); }
                    with(o_unit){
                        if(target == other.id) target = noone;
                    }
                    instance_destroy();
                }
            }
        }
        _i++;
    }
    
    ds_list_destroy(_involved);
	checkInCombat()
}