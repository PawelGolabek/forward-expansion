function handleHeartsCreation(unit){
	unit.hearts = []
	for(i=0;i < unit.maxhp; i+=1){
		heart = instance_create_depth(x + i * 48,y-128,depth,o_heart);
		heart.owner = unit;
		heart.i = i;
		array_push(unit.hearts,heart);
	}
}


function getDamaged(damageTaken, unit){
    unit.hp -= damageTaken;
    if(damageTaken){
        hit_timer = 8; // flash for 8 frames
    }
    damageTaken = 0
	

	// Loop through array indices (0 to unit.maxhp - 1)
	unit.hp = max(0, unit.hp);
	for (i = unit.maxhp - 1; i >= 0; i -= 1) {
		if (i >= unit.hp) {
			unit.hearts[i].image_index = 1; // Empty / damaged heart frame
		} else {
			unit.hearts[i].image_index = 0; // Full heart frame
		}
	}
    if(unit.hp <= 0){
        if(unit.logDeath){
            // FIXED: this unit itself died, so log ITS OWN unit.allegience/unit.name, not target's
            o_combat_log.log(string(unit.allegience) + "'s " + string(unit.name) + " died");					
        }
        with(o_unit){
            if(unit.target == other.id) unit.target = noone;
        }
        instance_destroy();
    }
            
    unit.hp -= damageTaken;
    damageTaken = 0

}