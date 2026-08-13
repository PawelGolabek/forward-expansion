event_inherited()
damageBoost = 2;
aura = true;
allegience = "player";

drag_draw_offset = 0;
range = infinity;
name = "Single Cycle ISR";
description = "1 hp units get ISR aura (+ 3 damage)";

function onUnitCreation(unit){
	if(unit.hp == 1){
		applyAura(unit,o_single_cycle_isr,damageBoost,o_isr_aura)
	}
}