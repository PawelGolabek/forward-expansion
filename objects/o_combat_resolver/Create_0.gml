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
                        o_combat_log.log(string(target.allegience) + "'s " + string(target.name) + 
						" got hit by " + string(allegience) + "'s "  + string(name) + " by " + string(damage));
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

// legacy, should not be used bc of multiple attacks shinagenans
function resolve_first_strike(firstStrikeUnit){    
    with (o_unit)
        targetted = false;
    with (o_unit)
    {
        if (instance_exists(target)){
            target.targetted = true;
		}
    }

    var _involved = ds_list_create();
	ds_list_add(_involved, firstStrikeUnit);
    
    with(o_unit){
		if(reactionStrike 
		   and reactedTo != firstStrikeUnit.id
		   and point_distance_ellipse_sq(x, y, firstStrikeUnit.x, firstStrikeUnit.y, 0.6) <= range * range 
		   and firstStrikeUnit.allegience != allegience){
			
			reactedTo = firstStrikeUnit.id; // mark this attacker as already reacted-to
			
            if(firstStrikeUnit.parry){
                o_combat_log.log(string(firstStrikeUnit.allegience) + "'s " + string(firstStrikeUnit.name) + " parried " + string(allegience) + "'s " + string(name) + " and hit it back by " + string(damage));
                damageTaken += damage;
                firstStrikeUnit.parried = true;
                if (ds_list_find_index(_involved, id) == -1) ds_list_add(_involved, id);
            }else{
                o_combat_log.log(string(firstStrikeUnit.allegience) + "'s " + string(firstStrikeUnit.name) + " got hit with the first strike by " + string(allegience) + "'s "  + string(name) + " by " + string(damage));
                firstStrikeUnit.damageTaken += damage;
				if(destroyOnAttack){
					hp = 0;
				}
                
                if (ds_list_find_index(_involved, firstStrikeUnit.id) == -1) ds_list_add(_involved, firstStrikeUnit.id);
            }
        }
    }
    
	with(firstStrikeUnit){
	    if(instance_exists(target) and target != noone and firstStrike){
	        target.damageTaken += damage;        
	        o_combat_log.log(string(target.allegience) + "'s " + string(target.name) + " got hit by " + string(allegience) + "'s "  + string(name) + " by " + string(damage));
	        if (ds_list_find_index(_involved, target.id) == -1) ds_list_add(_involved, target.id);
	        if(destroyOnAttack){
	            hp = 0;
	            if(explosionOnDeath){
	                var _ex = x;
	                var _ey = y;
	                var _eRange = range; // <- use a dedicated explosion radius, not "range"
	                var _eDamage = damage;        // to be replaced with something like global.explosion or sth
	                var _eAllegience = allegience;
	                var _eName = name;
	                var _eId = id;

	                with(o_unit){
	                    if(id != _eId and point_distance_ellipse_sq(_ex, _ey, x, y, 0.6) <= _eRange * _eRange){
	                        damageTaken += _eDamage;
	                        o_combat_log.log(string(allegience) + "'s " + string(name) + " got hit by an explosion from " + string(_eAllegience) + "'s " + string(_eName) + " by " + string(_eDamage));
	                        if (ds_list_find_index(_involved, id) == -1) ds_list_add(_involved, id);
	                    }
	                }
	            }
	        }
	    }
	}
    
    var _i = 0;
    repeat(ds_list_size(_involved)){
        var _inst = ds_list_find_value(_involved, _i);
        
        if(instance_exists(_inst)){
            with(_inst){
                if(damageTaken > 0){
                    hit_timer = 8;
                }
                getDamaged(damageTaken, self);
                damageTaken = 0;
                
                if(hp <= 0){
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
    
    with(o_unit){
        findNewTargetForSelf();
        checkInCombat();
    }
}

function resolve_first_strike_without_retaliation(firstStrikeUnit){    
    var _involved = ds_list_create();

    with (o_unit)
        targetted = false;
    with (o_unit)
    {
        if (instance_exists(target))
            target.targetted = true;
    }


	with(firstStrikeUnit){
	    if(instance_exists(target) and target != noone and firstStrike){
	        target.damageTaken += damage;        
	        o_combat_log.log(string(target.allegience) + "'s " + string(target.name) + " got hit by " + string(allegience) + "'s "  + string(name) + " by " + string(damage));
	        if (ds_list_find_index(_involved, target.id) == -1) ds_list_add(_involved, target.id);
	        if(destroyOnAttack){
	            hp = 0;
	            if(explosionOnDeath){
	                var _ex = x;
	                var _ey = y;
	                var _eRange = range; // <- use a dedicated explosion radius, not range ?
	                var _eDamage = damage;        // to be replaced with something like global.explosion or sth
	                var _eAllegience = allegience;
	                var _eName = name;
	                var _eId = id;

	                with(o_unit){
	                    if(id != _eId and point_distance_ellipse_sq(_ex, _ey, x, y, 0.6) <= _eRange * _eRange){
	                        damageTaken += _eDamage;
	                        o_combat_log.log(string(allegience) + "'s " + string(name) + " got hit by an explosion from " + string(_eAllegience) + "'s " + string(_eName) + " by " + string(_eDamage));
	                        if (ds_list_find_index(_involved, id) == -1) ds_list_add(_involved, id);
	                    }
	                }
	            }
	        }
	    }
	}
    
	
	
    var _i = 0;
    repeat(ds_list_size(_involved)){
        var _inst = ds_list_find_value(_involved, _i);
        
        if(instance_exists(_inst)){
            with(_inst){
                if(damageTaken > 0){
                    hit_timer = 8;
                }
                getDamaged(damageTaken, self);
                damageTaken = 0;
                
                if(hp <= 0){
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
	
    with(o_unit){
        findNewTargetForSelf();
        checkInCombat();
    }
}


function retaliate(firstStrikeUnit){

 
    with (o_unit)
        targetted = false;
    with (o_unit)
    {
        if (instance_exists(target)){
            target.targetted = true;
		}
    }

    var _involved = ds_list_create();
	ds_list_add(_involved, firstStrikeUnit);
    
    with(o_unit){
		if(reactionStrike 
		   and point_distance_ellipse_sq(x, y, firstStrikeUnit.x, firstStrikeUnit.y, 0.6) <= range * range 
		   and firstStrikeUnit.allegience != allegience){
			
			reactedTo = firstStrikeUnit.id; // mark this attacker as already reacted-to
			
            if(firstStrikeUnit.parry){
                o_combat_log.log(string(firstStrikeUnit.allegience) + "'s " + string(firstStrikeUnit.name) + " parried " + string(allegience) + "'s " + string(name) + " and hit it back by " + string(damage));
                damageTaken += damage;
                firstStrikeUnit.parried = true;
                if (ds_list_find_index(_involved, id) == -1) ds_list_add(_involved, id);
            }else{
                o_combat_log.log(string(firstStrikeUnit.allegience) + "'s " + string(firstStrikeUnit.name) + " got hit with the first strike by " + string(allegience) + "'s "  + string(name) + " by " + string(damage));
                firstStrikeUnit.damageTaken += damage;
				if(destroyOnAttack){
					hp = 0;
				}
                
                if (ds_list_find_index(_involved, firstStrikeUnit.id) == -1) ds_list_add(_involved, firstStrikeUnit.id);
            }
        }
    }
    
    var _i = 0;
    repeat(ds_list_size(_involved)){
        var _inst = ds_list_find_value(_involved, _i);
        if(instance_exists(_inst)){
            with(_inst){
                if(damageTaken > 0){
                    hit_timer = 8;
                }
                getDamaged(damageTaken, self);
                damageTaken = 0;
                
                if(hp <= 0){
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
    
    with(o_unit){
        findNewTargetForSelf();
        checkInCombat();
    }
}