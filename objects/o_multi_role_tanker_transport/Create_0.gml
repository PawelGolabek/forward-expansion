event_inherited()
damageBoost = 2;
aura = true;
allegience = "player";
drag_draw_offset = 0;
range = infinity;
countdown = 2;
maxCountdown = countdown;

name = "Multi-role Tanker Support";
description = "Get 1 energy for each non-intercepted airstrike";
function onUnitPlace(unit){
	if(unit.isAirStrike){
		countdown -= 1;
	}
	if(countdown == 0){
		global.crystals += 1;
		countdown = maxCountdown
	}
}