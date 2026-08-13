event_inherited()
damageBoost = 2;
aura = true;
allegience = "player";
drag_draw_offset = 0;
range = infinity;
name = "Standardized Replicator";
description = "Get 1 energy every time you play a 0 cost card";

function onUnitPlace(unit){
	if(unit.crystalCost == 0){
		global.crystals += 1;		// this will need an animation later on
	}
}