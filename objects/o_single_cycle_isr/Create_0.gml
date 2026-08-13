event_inherited()
damageBoost = 2;
aura = true;
allegience = "player";

drag_draw_offset = 0;
range = infinity;
name = "Single Cycle ISR";
description = "1 and less cost units get ISR aura (+ 3 damage)";

function onUnitCreation(unit){
	if(unit.crystalCost <= 1 and unit.allegience == "player"){
		applyAura(unit,o_single_cycle_isr,damageBoost,o_isr_aura)
	}
}