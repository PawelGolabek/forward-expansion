global.deployHighlight = noone;

with(o_unit){
	// lethal - every current heart beats
	heartIdx = array_length(hearts) - 1
	while(heartIdx >= 0){
		hearts[heartIdx].beating = false;
		heartIdx -= 1;
	}
}
if(not checkedFoW){
    fogOfWarCheck();
    checkedFoW = true;
}

// 1. EXECUTE LOGIC FIRST
// Run unit logic before gathering draw arrays so destroyed units are removed before drawing.
with(o_unit){
    drawCircle = false;
    minDistToPlayer = 9999999;
    
    if(allegience == "player"){
        visible = true;
        var _uletsLen = array_length(unitlets);
        for(var _i = 0; _i < _uletsLen; _i += 1){
            if (instance_exists(unitlets[_i])) {
                unitlets[_i].visible = true;
            }
        }
    }
    executeStep();
    if(inCombat){
        alpha = 0.7;
    }
}

// 2. POPULATE DRAW ARRAYS
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
        var _uletsNum = array_length(unitlets);
        for(var _i = 0; _i < _uletsNum; _i += 1){
            var _ulet = unitlets[_i];
            if (instance_exists(_ulet)) {
                array_push(other.uletsToDraw, _ulet);
            }
        }
    }
}

// 3. SAFE SORTING WITH INSTANCE_EXISTS CHECKS
array_sort(trees, function(a, b) {
    if (!instance_exists(a) || !instance_exists(b)) return 0;
    return a.depth - b.depth;
});

array_sort(uletsToDraw, function(a, b) {
    if (!instance_exists(a) || !instance_exists(b)) return 0;
    return a.depth - b.depth;
});

array_sort(unitsToDraw, function(a, b) {
    if (!instance_exists(a) || !instance_exists(b)) return 0;
    return a.depth - b.depth;
});

surface_set_target(global.threatSurf);
draw_clear_alpha(c_black, 0);

// Use normal blend mode, but make sure the circles themselves draw at alpha = 1
gpu_set_blendmode(bm_normal);
with (o_unit) {
    // Inside draw_threat_circle(), ensure draw_set_alpha(1) or c_white with 1.0 alpha is used
    draw_threat_circle(); 
}
surface_reset_target();

// Apply the translucency here ONCE for the entire combined surface
draw_set_alpha(0.15);
draw_surface(global.threatSurf, 0, 0);
draw_set_alpha(1); // Reset alpha
// 4. DRAW BATCHES
scr_draw_units_batch_trees(trees, 1);
scr_draw_units_batch(uletsToDraw, 1, 2);
scr_draw_units_batch(unitsToDraw, 1, 2);

