event_inherited()
damageBoost = 2;
aura = true;
allegience = "player";

drag_draw_offset = 0;
range = infinity;
name = "Light Armor";
description = "All units get 1 hp";

function onUnitCreation(unit){
	if(not unit.isAirStrike and unit.allegience == "player"){
		unit.hp += 1;
		unit.maxhp += 1;
	}
}