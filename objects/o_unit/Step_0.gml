// =====================================================================
// ADD TO CREATE EVENT (if not already present):
//
//   dragging      = false;
//   mask_index    = standard_collisions;
//   last_valid_x  = x;
//   last_valid_y  = y;
//
// =====================================================================

depth = -y;
tmpTarget = noone;

if(position_meeting(mouse_x, mouse_y, id)){
	drawCircle = true
	if (mouse_check_button_pressed(mb_left))
	{
	    if ( global.draggingUnit == noone and not placed)
	    {
	        dragging = true;
	        last_valid_x = x;
	        last_valid_y = y;
	    }
	}
}

if (dragging)
{
	drag_draw_offset = -30;
    mask_index = dragging_mask;
    global.draggingUnit = self;
    x = mouse_x;
    y = mouse_y;
    // --- COLLISION RESOLUTION ---
    var _iterations = 300;
    repeat (_iterations)
    {
        var _list = ds_list_create();
        var _num = instance_place_list(x, y, o_unit, _list, false);
        var _moved = false;
        for (var i = 0; i < _num; i++)
        {
            var _other = _list[| i];
            if (_other == id) continue;
            var _dir = point_direction(_other.x, _other.y, x, y);
            if (x == _other.x && y == _other.y) _dir = random(360);
            x += lengthdir_x(1, _dir);
            y += lengthdir_y(1, _dir);
            _moved = true;
        }
        ds_list_destroy(_list);
        if (!_moved) break;
    }
    // -----------------------------

    // --- KEEP INSIDE ROOM BOUNDS ---
    // Use the sprite's bounding box (relative to origin) so the unit's
    // visible edges stay inside the room, not just its origin point.
    var _halfLeft   = sprite_index != -1 ? sprite_get_xoffset(sprite_index) : 0;
    var _halfRight  = sprite_index != -1 ? (sprite_get_width(sprite_index) - sprite_get_xoffset(sprite_index)) : 0;
    var _halfTop    = sprite_index != -1 ? sprite_get_yoffset(sprite_index) : 0;
    var _halfBottom = sprite_index != -1 ? (sprite_get_height(sprite_index) - sprite_get_yoffset(sprite_index)) : 0;

    x = clamp(x, _halfLeft, room_width - _halfRight);
    y = clamp(y, _halfTop, room_height - _halfBottom);
    // --------------------------------

    var _check = instance_place(x, y, o_unit);
	var _checkTerrain = instance_place(x, y, o_impassable);
	
    if (_check == noone || _check == id || _checkTerrain == noone || _checkTerrain == id)
    {
        last_valid_x = x;
        last_valid_y = y;
    }
    else
    {
        x = last_valid_x;
        y = last_valid_y;
    }
    findNewTargetForSelf();
    if (!mouse_check_button(mb_left))
    {
        resetTargets();
		global.dropped = self;
		o_combat_resolver.resolve_first_strike()
		global.dropped = noone;
		global.draggingUnit =noone;
        dragging = false;
		placed = true;
		o_combat_resolver.resolve_combat()
    }
}
else
{
	drag_draw_offset = 0;
    mask_index = standard_collisions;
}
breathe_timer += breathe_speed * (delta_time / 1000000) * 60;
image_xscale = base_scale + sin(breathe_timer) * breathe_amount;
image_yscale = base_scale - sin(breathe_timer) * breathe_amount;


if(not noEyes){
	blink-=delta_time;
	if(blink <= 0){
		lEye.blink()
		rEye.blink()
		blink = maxBlink
	}
}

if (hit_timer > 0)
    hit_timer--;

if (global.draggingUnit == self)
{
	global.expectedDmg = 0;
	with(o_unit){
	    // 4. Check if that dragged enemy is within THIS unit's range
	    var dist = point_distance(x, y, global.draggingUnit.x, global.draggingUnit.y);
	    if(global.draggingUnit == self){
			drawCircle = true
		}else if (dist <= range and global.draggingUnit.allegience != allegience and reactionStrike
		){
			drawCircle = true
			tmpTarget = global.draggingUnit;
			global.expectedDmg += damage
		}
	}
}
// will run for every unit which is bad but eh
// 4. Check if that dragged enemy is within THIS unit's range
if (global.draggingUnit != noone and global.draggingUnit != self) {
    var dist = point_distance(x, y, global.draggingUnit.x, global.draggingUnit.y);

    if (dist <= range and global.draggingUnit.allegience != allegience and reactionStrike) {
        drawCircle = true;
        tmpTarget = global.draggingUnit;
        global.expectedDmg += damage;
    } else {
        drawCircle = false;
    }
} else if (global.draggingUnit == self) {
    drawCircle = true; // always show circle on the unit being dragged
} else if (position_meeting(mouse_x, mouse_y, id)) {
    drawCircle = true;
} else {
    drawCircle = false;
}