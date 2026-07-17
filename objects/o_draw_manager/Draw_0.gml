
with(o_unit){
	expectedDmg = 0;
}

with(o_unit){
	executeStep();
}

	// Active / Combat checks
	with(o_unit){
	inCombat = false;
	}
	with(o_unit){
		with(o_unit){
			if (point_distance(x, y, other.x, other.y) <= range and allegience != other.allegience){
			    other.inCombat = true;
				draw_text(x,y,inCombat)
			}
		}
	}

array_sort(ulets, function(a, b) {
    return a.depth - b.depth;
});
array_sort(units, function(a, b) {
    return a.depth - b.depth;
});

scr_draw_units_batch(ulets, 1, 2); // 2px glow ring, 3px black ring behind it
show_debug_message(units[1].visible)


scr_draw_units_batch(units, 1, 2); // 2px glow ring, 3px black ring behind it
