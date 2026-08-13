// Begin Step  (reset before anyone registers this frame)
unitsToDraw = [];
trees = [];


with(o_unit){
	if(initiated){
		// lethal - every current heart beats
		heartIdx = array_length(hearts) - 1
		while(heartIdx >= 0){
			hearts[heartIdx].beating = false;
			heartIdx -= 1;
		}
	}
}

if(not checkedFoW){
    fogOfWarCheck();
    checkedFoW = true;
}
with(o_unitlet){
	targettedBySpell = false;
}

// 1. EXECUTE LOGIC FIRST
// Run unit logic before gathering draw arrays so destroyed units are removed before drawing.
draw_set_alpha(1.0);
with(o_unit){
	if(initiated){
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
}
with(o_unitlet){
	executeStep();
}


with(o_expand_circle){
	executeStep();
}

///////////////////////////////
/// TERRAIN
/////////////////////////////

global.deployHighlight = noone;

// --- FIX: ensure app_surface exists and is the active target BEFORE anything
// that's meant to end up on screen (cliffs, base terrain) is drawn. Previously
// o_cliff and the first o_placable_terrain pass were drawn before app_surface
// was targeted, so they landed on the default application_surface instead of
// app_surface -- meaning they'd be missing from (or inconsistent with) the
// surface that actually goes through the CRT shader.


/*
if (!surface_exists(app_surface)) {
	
    app_surface = surface_create(room_width, room_height);
}

//crt_gui_begin();
//surface_set_target(app_surface);


*/
draw_clear_alpha(c_black, 0);

var dynamicBG = []
with(o_dynamicbg){
	array_push(dynamicBG,self);
}
array_sort(dynamicBG, function(a, b) {
    if (!instance_exists(a) || !instance_exists(b)) return 0;
    return b.depth - a.depth;
});

maxBG = array_length(dynamicBG);
for(i = 0; i < maxBG; i+= 1){
	with(dynamicBG[i]){
		draw_self();
	}
}

draw_set_alpha(1.0);
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
i = 0;
with (o_surface) {
    array_push(surfaces, self);
}

// 1. Ensure required surfaces exist
if (!surface_exists(mask_surface)) {
    mask_surface = surface_create(room_width, room_height);
}
if (!surface_exists(circle_surface)) {
    circle_surface = surface_create(room_width, room_height);
}

// Draw base terrain directly onto app_surface (full-opacity base layer)
draw_set_alpha(1.0);
with (o_placable_terrain) {
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
}

// 2. Render all circles onto intermediate surface first
draw_set_alpha(1.0);
surface_set_target(circle_surface);
draw_clear_alpha(c_lime, 0);
gpu_set_blendmode(bm_normal);

draw_set_alpha(1.0);
with (o_expand_circle) {
	draw();
}

if(not keyboard_check(vk_tab)){
	var bloodstains = [];
	with(o_bloodstain){
		array_push(bloodstains,self)
	}
	draw_set_alpha(0.3);
	scr_draw_units_batch_trees(bloodstains, 1);
}




surface_reset_target();

// 3. Prepare main mask surface
surface_set_target(mask_surface);
draw_clear_alpha(c_black, 0);
gpu_set_blendmode(bm_normal);

draw_set_alpha(1.0);
with (o_placable_terrain) {
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
}

// 4. Apply circles using separate alpha logic
// Parameters: (src_color, dest_color, src_alpha, dest_alpha)
gpu_set_blendmode_ext_sepalpha(bm_dest_alpha, bm_zero, bm_zero, bm_one);



draw_surface(circle_surface, 0, 0);

// Reset GPU blend mode and target
gpu_set_blendmode(bm_normal);
surface_reset_target();

// 5. Composite the terrain+circle mask onto app_surface (still the active target)
draw_surface(mask_surface, 0, 0);



///////////////////////////////
/////// UNITS
///////////////////////////////
// 2. POPULATE DRAW ARRAYS
trees = [];
unitsToDraw = [];
uletsToDraw = [];

gpu_set_blendmode(bm_normal);

/*
with (o_top_surface) {
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
}
*/
draw_set_alpha(1.0);
with (o_trees) {
    if (other.rect_in_draw_area(bbox_left, bbox_top, bbox_right, bbox_bottom)) {
        array_push(other.trees, self);
    }
}


draw_set_alpha(1.0);
with (o_unit) {
	if(not initiated){
	
		initiate();
		handleHeartsCreation(self);
		initiated = true
		executeStep()
	
	}
	if(initiated){
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
}
with (o_status) {
	//	 if statuses get outlines

}
	
	
draw_set_alpha(1.0);
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
draw_set_alpha(1.0);
if (!surface_exists(global.threatSurf)) {
    global.threatSurf = surface_create(room_width, room_height);
}
surface_set_target(global.threatSurf);
draw_clear_alpha(c_black, 0);

///////////////////////////
////////////// UNITS
/////////////////////////
// Use normal blend mode, and make sure the circles themselves draw at alpha = 1
draw_set_alpha(1.0)
gpu_set_blendmode(bm_normal);
with (o_unit) {
    // Inside draw_threat_circle(), ensure draw_set_alpha(1) or c_white with 1.0 alpha is used
    draw_threat_circle(); 
}

// Reset target BEFORE drawing the surface back to screen
// (pops back to app_surface, which is still the active target underneath)
surface_reset_target();
draw_set_alpha(0.1);


with (o_unit) {
	if(wantCircle or keyboard_check(vk_tab)){
		draw_half_circle_scale(x, y, range, 0, 180, 1.0, 0.6);
		draw_half_circle_scale(x, y, range, 180, 360, 1.0, 0.6);
	}
}
// Apply the translucency here ONCE for the entire combined surface
draw_set_alpha(0.2);
draw_surface(global.threatSurf, 0, 0);

// 4. DRAW BATCHESl
draw_set_alpha(1); // Reset alpha
scr_draw_units_batch_trees(trees, 1);
scr_draw_units_batch(uletsToDraw, 1, 2);
scr_draw_units_batch(unitsToDraw, 1, 2);

////////////// 
/// POST DRAW CLEANUP
//////////////
with(o_unitlet){
	targettedBySpell = false;
}


//draw_text(mouse_x, mouse_y, "\n\nTest GUI");

// --- FIX: release app_surface as the render target BEFORE feeding it into
// the shader as a source texture. Previously app_surface was still the
// active target when my_crt.draw(app_surface, ...) ran, meaning the surface
// was being read from and written to at the same time (undefined / blank /
// corrupted result depending on platform).
//surface_reset_target();
//my_crt.draw(app_surface, 0, 0, room_width, room_height);

//crt_gui_end();
