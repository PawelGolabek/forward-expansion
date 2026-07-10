global.deployHighlight = noone
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
                hp -= damageTaken;
                if(damageTaken){
                    hit_timer = 8; // flash for 8 frames
                }
                damageTaken = 0
                if(hp <= 0){
                    if(logDeath){
                        // FIXED: this unit itself died, so log ITS OWN allegience/name, not target's
                        o_combat_log.log(string(allegience) + "'s " + string(name) + " died");					
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
    
    with(o_unit){
        if(point_distance(x, y, global.dropped.x, global.dropped.y) <= range and global.dropped.allegience != allegience and reactionStrike){
            if(global.dropped.parry){			
                // FIXED: was using name/damage generically but attacker here is self, victim is global.dropped
                o_combat_log.log(string(global.dropped.allegience) + "'s " + string(global.dropped.name) + " parried " + string(allegience) + "'s " + string(name) + " and hit it back by " + string(damage));
                damageTaken += damage;
                global.dropped.parried = true;
            }else{		
                // FIXED: was target.allegience/target.name/target.allegience/name — target isn't the actor here.
                // The victim is global.dropped, the attacker is self (o_unit).
                o_combat_log.log(string(global.dropped.allegience) + "'s " + string(global.dropped.name) + " got hit with the first strike by " + string(allegience) + "'s "  + string(name) + " by " + string(damage));
                global.dropped.damageTaken += damage;
            }
        }
    }
    
    with(global.dropped){
        if(self.target != noone and firstStrike){
            target.damageTaken += damage;		
            // FIXED: attacker here is global.dropped (self), victim is target
            o_combat_log.log(string(target.allegience) + "'s " + string(target.name) + " got hit with the first strike by " + string(allegience) + "'s "  + string(name) + " by " + string(damage));
                
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
            // OPTIONAL: you have no death log here at all, unlike resolve_combat.
            // If you want consistent death logging on first-strike kills too, add:
            if(logDeath){ o_combat_log.log(string(allegience) + "'s " + string(name) + " died"); }
            with(o_unit){
                if(target == other.id) target = noone;
            }
            instance_destroy();
        }
    }
}