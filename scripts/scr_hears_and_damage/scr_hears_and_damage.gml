function handleHeartsCreation(unit) {
    unit.hearts = [];
    var heartsPerRow = 5;
    var spacing = 48;
    for (i = 0; i < unit.maxhp; i++) {
        var col = i mod heartsPerRow;
        var row = i div heartsPerRow;
        var heart = instance_create_depth(
            x + col * spacing,
            y - 128 + row * spacing,
            depth,
            o_heart
        );
        heart.owner = unit;
        heart.i = i;
        array_push(unit.hearts, heart);
    }
}

function getDamaged(damageTaken, unit){
	if(shieldActive){
		shieldActive = false;
	}else{
	    unit.hp -= damageTaken;
	    if(damageTaken){
	        hit_timer = 8; // flash for 8 frames
	    }
	    damageTaken = 0
	

		// Loop through array indices (0 to unit.maxhp - 1)
		unit.hp = max(0, unit.hp);
		for (i = unit.maxhp - 1; i >= 0; i -= 1) {
			if (i >= unit.hp) {
				unit.hearts[i].visible = false; // Empty / damaged heart frame
				unit.hearts[i].container.visible = true; // Empty / damaged heart frame
			} else {
				unit.hearts[i].visible = true; // Full heart frame
				unit.hearts[i].container.visible = true; // Empty / damaged heart frame
			}
		}
	    if(unit.hp <= 0){
	        with(o_unit){
	            if(unit.target == other.id) unit.target = noone;
	        }
	        instance_destroy();
	    }
	    unit.hp -= damageTaken;
	}
    damageTaken = 0
}