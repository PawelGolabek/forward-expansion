global.deployHighlight = noone

if(not checkedFoW){
	fogOfWarCheck()
	checkedFoW = true;
}


trees = [];
unitsToDraw = [];
uletsToDraw = [];

with (o_trees) {
    if (other.rect_in_draw_area(bbox_left, bbox_top, bbox_right, bbox_bottom)) {
        array_push(other.trees, self);
    }
}


with (o_unit) {
    if (other.rect_in_draw_area(bbox_left, bbox_top, bbox_right, bbox_bottom)) {
        array_push(other.unitsToDraw, self);
		uletsNum = array_length(unitlets)
		for(i = 0; i < uletsNum; i += 1){
			array_push(other.uletsToDraw,unitlets[i]);
		}
    }
}


with(o_unit){
	drawCircle = false;
	minDistToPlayer = 9999999;
}

with(o_unit){
	if(allegience == "player"){
		visible = true;
		uletsLen = array_length(unitlets);
		for(i=0; i < uletsLen; i += 1){
			unitlets[i].visible = true;
		}
	}
	executeStep();
	if(inCombat){
		alpha = 0.7
	}
}

array_sort(trees, function(a, b) {
    return a.depth - b.depth;
});
array_sort(ulets, function(a, b) {
    return a.depth - b.depth;
});
array_sort(units, function(a, b) {
    return a.depth - b.depth;
});

	
scr_draw_units_batch_trees(trees, 1);
scr_draw_units_batch(uletsToDraw, 1, 2); // 2px glow ring, 3px black ring behind it
scr_draw_units_batch(unitsToDraw, 1, 2); // 2px glow ring, 3px black ring behind it
