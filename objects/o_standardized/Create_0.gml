event_inherited()
damageBoost = 2;
aura = true;
allegience = "player";

drag_draw_offset = 0;
range = infinity;


function onUnitPlace(unit){
	if(unit.crystalCost == 0){
		global.crystals += 1;		// this will need an animation later on
	}
}