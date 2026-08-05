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

///////////////////////////////
/// TERRAIN
/////////////////////////////
with (o_cliff) {
    draw_sprite_ext(
        sprite_index, 
        image_index, 
        x, 
        y, 
        image_xscale, 
        image_yscale, 
        image_angle, 
        image_blend, 
        image_alpha
    );
}

var surfaces = [];
var i = 0;
with(o_surface){
	array_push(surfaces, self);
}

// 1. Ensure mask surface exists before drawing
if (!surface_exists(mask_surface)) {
    mask_surface = surface_create(room_width, room_height);
}

with (o_placable_terrain) {
    draw_sprite_ext(
        sprite_index, 
        image_index, 
        x, 
        y, 
        image_xscale, 
        image_yscale, 
        image_angle, 
        image_blend, 
        image_alpha
    );
}

surface_set_target(mask_surface);

gpu_set_blendmode(bm_normal);

with (o_placable_terrain) {
    draw_sprite_ext(
        sprite_index, 
        image_index, 
        x, 
        y, 
        image_xscale, 
        image_yscale, 
        image_angle, 
        image_blend, 
        image_alpha
    );
}

with (o_top_surface) {
    draw_sprite_ext(
        sprite_index, 
        image_index, 
        x, 
        y, 
        image_xscale, 
        image_yscale, 
        image_angle, 
        image_blend, 
        image_alpha
    );
}

// 3. Limit draw area to the base surfaces' alpha channel
gpu_set_blendmode_ext(bm_dest_alpha, bm_zero);
with(o_expand_circle){
    draw_sprite_ext(
        sprite_index, 
        image_index, 
        x, 
        y, 
        image_xscale, 
        image_yscale, 
        image_angle, 
        image_blend, 
        image_alpha
    );

}

// 4. Always reset GPU state immediately after drawing
gpu_set_blendmode(bm_normal);
surface_reset_target();

// 5. Render the result at origin (since room dimensions were used)
gpu_set_blendmode(bm_normal); // straight alpha blend: src_alpha, inv_src_alpha
draw_surface(mask_surface, 0, 0);

with (o_top_surface) {
    draw_sprite_ext(
        sprite_index, 
        image_index, 
        x, 
        y, 
        image_xscale, 
        image_yscale, 
        image_angle, 
        image_blend, 
        image_alpha
    );
}

///////////////////////////////
/////// UNITS
///////////////////////////////
// 2. POPULATE DRAW ARRAYS
trees = [];
unitsToDraw = [];
uletsToDraw = [];

gpu_set_blendmode(bm_normal);

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

// --- THREAT CIRCLE SURFACE ---
// Ensure threatSurf exists before targeting it (this was missing, causing
// the surface_set_target call to silently fail / draw nothing)
if (!surface_exists(global.threatSurf)) {
    global.threatSurf = surface_create(room_width, room_height);
}

surface_set_target(global.threatSurf);
draw_clear_alpha(c_black, 0);

// Use normal blend mode, and make sure the circles themselves draw at alpha = 1
gpu_set_blendmode(bm_normal);
draw_set_alpha(1);
with (o_unit) {
    // Inside draw_threat_circle(), ensure draw_set_alpha(1) or c_white with 1.0 alpha is used
    draw_threat_circle(); 
}

// Reset target BEFORE drawing the surface back to screen
surface_reset_target();

// Apply the translucency here ONCE for the entire combined surface
draw_set_alpha(0.7);
draw_surface(global.threatSurf, 0, 0);
draw_set_alpha(1); // Reset alpha

// 4. DRAW BATCHES
scr_draw_units_batch_trees(trees, 1);
scr_draw_units_batch(uletsToDraw, 1, 2);
scr_draw_units_batch(unitsToDraw, 1, 2);