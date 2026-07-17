global.deployHighlight = noone


with(o_unit){
	expectedDmg = 0;
}

with(o_unit){
	executeStep();
	if(inCombat){
		alpha = 0.7
	}
}

array_sort(ulets, function(a, b) {
    return a.depth - b.depth;
});
array_sort(units, function(a, b) {
    return a.depth - b.depth;
});

scr_draw_units_batch(ulets, 1, 2); // 2px glow ring, 3px black ring behind it
scr_draw_units_batch(units, 1, 2); // 2px glow ring, 3px black ring behind it
