event_inherited()
damageBoost = 2;
aura = true;
allegience = "player";

drag_draw_offset = 0;
range = infinity;


function onUnitCreation(unit){
	if(unit.hp == 1){
		applyAura(unit,o_single_cycle_isr,damageBoost,o_isr_aura)
	}
}