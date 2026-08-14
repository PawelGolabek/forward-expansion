event_inherited()
damageBoost = 2;
aura = true;
allegience = "player";

drag_draw_offset = 0;
range = infinity;
name = "Ballistic Tip";
description = "All units get 1 damage bonus";

function onUnitCreation(unit){
	if(not unit.isAirStrike){
		unit.damage += 1;
	}
}

// this will probably need to be rewritten or doubled for spawners sake unless 
// unit becomes its own spawner or sth :(