allegience = "enemy"
name = "NO NAME ASSIGNED";
range = 1000;
damage = 100
hp = 10
maxhp = hp
firstStrike = true;
reactionStrike = true;
crystalCost = 10
// ulet spawning
mySprite = sprite_index;
og_image_xscale = image_xscale;
og_image_yscale = image_yscale;
uletSize = Sprite1;
ulet_xScale = 0.3;
ulet_yScale = ulet_xScale;
//tmp variables for combat
damageTaken = 0
drawCircle = false; 
fragility = 10;
aiType = "melee";
animationOn = false;
//targetting
target = noone;
tmpTarget = noone;
targetted = false;
inCombat = false;
// ui
arrow = instance_create_depth(x,y,depth-10,o_arrow);
arrow.owner = self;
skull = instance_create_depth(x,y,depth - 30,o_skull);
skull.unit = self;
lastFriendly = noone;
signalFromUnitlet = false;
mous = false
mousCooldown = 1500000;
mousMaxCooldown = mousCooldown
immortalExists = false;
TheOne = noone;
// ui for skull
cam = view_camera[0];
viewX = camera_get_view_x(cam);
viewY = camera_get_view_y(cam);
viewW = camera_get_view_width(cam);
viewH = camera_get_view_height(cam);
guiX = (x - viewX) * display_get_gui_width() / viewW;
guiY = (y - viewY) * display_get_gui_height() / viewH;
xx = guiX;
yy = guiY + 35;
//// this makes no sense but might keep it for later.
noEyes = true
noUnitlets = false;
//cosmetics
bornOfSpawner = false;
// shaders
glow = false;
redGlow = false;
outline_surf = -2
breatheDrawXOffset = 0
global.deployHighlight = noone


if(!noEyes){
	eyeX = 20
	eyeDist = 30;
	lEye = instance_create_depth(x-sprite_width+eyeDist + eyeX,y,depth-10,o_eye);
	rEye = instance_create_depth(x-sprite_width+sprite_width-eyeDist + eyeX,y,depth-10,o_eye);
	lEye.originX = lEye.x - x;
	lEye.originY = lEye.y - y;
	rEye.originX = rEye.x - x;
	rEye.originY = rEye.y - y;
	lEyeLid = instance_create_depth(x-sprite_width+eyeDist + eyeX,y,depth-10,o_eye_lid);
	rEyeLid = instance_create_depth(x-sprite_width+sprite_width-eyeDist + eyeX,y,depth-10,o_eye_lid);
	lEyeLid.owner = self;
	rEyeLid.owner = self;
	rEyeLid.originX = rEye.x - x;
	rEyeLid.originY = rEye.y - y;
	lEyeLid.originX = rEye.x - x;
	lEyeLid.originY = rEye.y - y;
	lPupil = instance_create_depth(lEye.x + lEye.sprite_width/2,lEye.y + lEye.sprite_height/2,depth-10,o_pupil);
	lPupil.x -= lPupil.sprite_width/2
	lPupil.y -= lPupil.sprite_height/2
	lPupil.owner = self;
	lPupil.originX = lPupil.x - x;
	lPupil.originY = lPupil.y - y;
	rPupil = instance_create_depth(rEye.x + rEye.sprite_width/2,rEye.y + rEye.sprite_height/2,depth-10,o_pupil);
	rPupil.x -= rPupil.sprite_width/2
	rPupil.y -= rPupil.sprite_height/2
	rPupil.owner = self;
	rPupil.originX = rPupil.x - x;
	rPupil.originY = rPupil.y - y;
	lEye.owner = self;
	rEye.owner = self;
	blink = 20000000+random(200000);
	maxBlink = blink
}
//animations
breathe_timer = 0;
breathe_speed = 0.05;   // how fast it breathes
breathe_amount = 0.05;  // how much it scales (0.05 = 5%)
base_scale = 1;         // your sprite's normal scale
hit_timer = 0;
//idk alpha
alpha = 1.0
//drag
dragging = false;
drag_draw_offset = 0;
justFinishedDragging = false;
last_valid_x = -9999;
last_valid_y = -9999;
placed = false;
valid = false;
// input
mouseClicked = false;
//log
logDeath = true;
logHit = true;
//special abilities
parry = false;
// unitlets
myUnitlet = o_unitlet;
unitlets = []
expectedDamage = 0;
//shaders
u_shadow_color = shader_get_uniform(shd_shadow, "u_shadow_color");

// Shadow settings: Adjust these to change how the shadow looks
shadow_offset_y = 60;     // How far "down" the shadow sits from the sprite's feet
shadow_alpha = 0.7;      // Transparency of the shadow (0 = invisible, 1 = solid)
shadow_yscale = 0.7;     // Squishes the shadow vertically to give it a flat, top-down floor look


function calculateDamageExpectedDelayed() {
	// cache self's data since 'self' changes inside the with block
	var myId = id;
	var myAllegience = allegience;
	var myX = x;
	var myY = y;
	var total = 0;
	
	with (o_unit) {
		if (id == myId) continue;              // skip self
		if (allegience == myAllegience) continue; // skip allies
		var dist = point_distance(x, y - drag_draw_offset, myX, myY - drag_draw_offset);
		if (dist <= range) {
			total += damage;
		}
	}
	return total;
}


function mouseEvent(){
	mouseClicked = true;
}

function line_blocked(_x1, _y1, _x2, _y2)
{
    var dist = point_distance(_x1, _y1, _x2, _y2);
    var dir  = point_direction(_x1, _y1, _x2, _y2);
	var xx1;
	var yy1;
    for (var d = 0; d < dist; d += 4) // sample every 4 pixels
    {
        xx1 = _x1 + lengthdir_x(d, dir);
        yy1 = _y1 + lengthdir_y(d, dir);
        if (position_meeting(xx1, yy1, o_impassable))
            return true;
		u = collision_point(xx1, yy1, o_unitlet, false, true);
		if(u != noone){
			if(u.unit.allegience != allegience){
				return true;
			}
		}
    }
	u = instance_place(xx1, yy1, o_unitlet);
	if (u != noone)
	{
		if (u.unit.allegience != allegience)
		{
			return true;
		}
	}
    return false;
}

function line_blocked_terrain_only(_x1, _y1, _x2, _y2)
{
    var dist = point_distance(_x1, _y1, _x2, _y2);
    var dir  = point_direction(_x1, _y1, _x2, _y2);
	var xx1;
	var yy1;
    for (var d = 0; d < dist; d += 4) // sample every 4 pixels
    {
        xx1 = _x1 + lengthdir_x(d, dir);
        yy1 = _y1 + lengthdir_y(d, dir);
        if (position_meeting(xx1, yy1 + drag_draw_offset, o_impassable)) return true;
    }
    return false;
}
function place(){
if ((mouseClicked and valid) || (not bornOfSpawner && !placed)){
		with(o_spawner_parent){
			selected = false;
		}
		if(last_valid_x < 0 and last_valid_y < 0){
			global.dropped = noone;
			global.draggingUnit = noone;
			instance_destroy();
		}else{
			
		mask_index = s_flag_hitbox;
		// animation thingy
		
		instance_create_layer(x - sprite_width/4, y, "units", o_expand_circle);
		
		//// first strike, ommit if spawned on room creation
		if(bornOfSpawner){
			o_clock.toNextEvent = o_clock.maxToNextEvent;
			ds_queue_enqueue(o_clock.action_queue, {
				// FIXED: Use 'id' instead of 'self' to guarantee a solid instance reference
				my_spawned_unit: id,
				func: function() {
			
					o_combat_log.log("Player spawned " + my_spawned_unit.name);
				    var _unit = self.my_spawned_unit;
					my_spawned_unit.y -= my_spawned_unit.drag_draw_offset;
					my_spawned_unit.drag_draw_offset = 0;

				    if (instance_exists(_unit)) {
				        with (_unit) {
				            resetTargets();
                    
				            global.dropped = id; 
				            global.draggingUnit = id;
				            o_combat_resolver.resolve_first_strike();
                    
							global.dropped = noone;
							global.draggingUnit = noone;
							// 2. Clear state inside the unit context right as combat resolves
				            if (variable_instance_exists(id, "lastFriendly") && instance_exists(lastFriendly)) {
				                lastFriendly = noone;
				            }
				        }
				    }
					// 3. Resolve global combat after the unit handles its drop actions
					o_combat_resolver.resolve_combat();
					}
				}); 
				y -= drag_draw_offset;
				drag_draw_offset = 0;
				o_deck_holder.discard_card(parentSpawner);
			}
			dragging = false;
			placed = true;
			y -= drag_draw_offset;
			drag_draw_offset = 0;
			
			tmp = hp;
			if(not noUnitlets){
				repeat(tmp){
					var placed_ok = false;
					var tries = 0;
					var angle;
					var dist;
					var px;
					var py;
					var best_dist = 999999;
					var best_x = x;
					var best_y = y;
					ulet = instance_create_depth(-9999999, -999999, depth - 500, myUnitlet);		   
					ulet.owner = self;
					ulet.unit = self;
					ulet.image_xscale = 0.3;
					ulet.image_yscale = 0.3;
					ulet.initiate();
					ulet.initiate2();

				for (var i = 0; i < 200; i++) {
				    angle = random(360);
				    dist = random(300);
				    px = x + lengthdir_x(dist, angle);
				    py = y + lengthdir_y(dist, angle);
					
				    var blocked = false;
				    with (ulet) {
				        blocked = place_meeting(px, py + drag_draw_offset, o_unitlet) || place_meeting(px, py + drag_draw_offset, o_unit);
						var tilemap = layer_tilemap_get_id("Tiles_1");
						if(tilemap_get_at_pixel(tilemap,px,py) == 9 or tilemap_get_at_pixel(tilemap,px,py) == -1 ){
							blocked = true;
						}
				    }
				    if (!blocked) {
				        if (line_blocked_terrain_only(x, y, px, py + drag_draw_offset)) continue;
				        if (dist < best_dist) {
				            best_dist = dist;
				            best_x = px;
				            best_y = py + drag_draw_offset;
				        }
				    }
				}
					ulet.x = best_x;
					ulet.y = best_y;
					array_push(unitlets,ulet);		
				}
			}
		}
	}
	image_xscale = og_image_xscale;
	image_yscale = og_image_yscale;
}



function resetTargets() 
{
    // Store references to the dropped unit's properties before looping
    var droppedUnit = self;
    var droppedAllegience = allegience;
    var droppedX = x;
    var droppedY = y;
    
    // 1. OTHER UNITS: Update their targets based on the dropped unit's new position
    with (o_unit) 
    {
        // Don't check yourself
        if (id == droppedUnit) continue; 
        
        // If this unit is an enemy to the dropped unit
        if (allegience != droppedAllegience) 
        {
            var distanceToDropped = point_distance(x, y, droppedX, droppedY);
            
            if (distanceToDropped <= range) 
            {
                // The dropped unit is in range! Target it.
                target = droppedUnit; 
            }
            else if (target == droppedUnit) 
            {
                // NEW LOGIC: This unit WAS targeting the dropped unit, 
                // but now the dropped unit is OUT of range.
                target = noone; // Clear the old target first
                
                // Call the function to find a new target
                // (Executing inside the 'with' block means 'self' is this specific o_unit)
                findNewTargetForSelf(); 
            }
        }
    }
    
    // 2. DROPPED UNIT: Find the closest enemy unit for itself
    var closestEnemy = noone;
    var minDistance = infinity; 
    
    with (o_unit) 
    {
        // Skip yourself and skip teammates
        if (id == droppedUnit || allegience == droppedAllegience) continue;
        
        // Calculate distance to this potential enemy
        var dist = point_distance(droppedX, droppedY, x, y);
        
        // If this one is closer than the previous closest, update it
        // Note: I also checked if the dropped unit's OWN range allows it to hit them
        if (dist < minDistance and dist <= droppedUnit.range) 
        {
            minDistance = dist;
            closestEnemy = id;
        }
    }
    
    // Set the dropped unit's target to the closest enemy found
    droppedUnit.target = closestEnemy;
}

function findNewTargetForSelf() 
{
    // Store references to this unit's properties before entering the loop
    var myId = id; 
    var myAllegience = allegience;
    var myX = x;
    var myY = y;
    
    var closestEnemy = noone;
    var minDistance = infinity; 
    var myRange = range;
    // Loop through all units to find the closest enemy
    with (o_unit) 
    {
        // Skip yourself and skip teammates
        if (id == myId || allegience == myAllegience) continue;
        
        // Calculate distance from the calling unit to this potential enemy
        var dist = point_distance(myX, myY - other.drag_draw_offset, x, y - drag_draw_offset);
        
        // If this enemy is closer than the previous closest, update it
        if (dist < minDistance && myRange > dist)
        {
            minDistance = dist;
            closestEnemy = id;
        }
    }
    
    // Set ONLY this unit's target to the closest enemy found
    target = closestEnemy;
	with(closestEnemy){
		if(not closestEnemy.noUnitlets){
			redGlow = true;
			ulets = array_length(unitlets) - 1
			while(ulets >= 0){
				unitlets[ulets].redGlow = true;
				ulets-=1;
			}
		}
	}
}


function onRoundEnd(){
	if(not instance_exists(target) or target == noone){
		findNewTargetForSelf() 
	}
}

function executeStep(){
	drawCircle = false;
mous = (x - sprite_width/2 < mouse_x and x + sprite_width/2 > mouse_x and y - sprite_height < mouse_y and y > mouse_y)
// i hate that it does not match the flag but will fix later brb
if(mous){drawCircle = true;}
	alpha = 1.0;
	depth = -y;
	tmpTarget = noone;
	if(not bornOfSpawner){
		last_valid_x = x;
		last_valid_y = y;
		place();
	}
	if (dragging)
	{
		mask_index = s_minimal_hitbox
		drag_draw_offset = -30;
		for (var i = 0; i < array_length(unitlets); i++)
		{
		    unitlets[i].drag_draw_offset = drag_draw_offset;
		}
	    global.draggingUnit = self;
	    x = mouse_x;
	    y = mouse_y + drag_draw_offset;
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
		var _halfLeft   = sprite_index != -1 ? sprite_get_xoffset(sprite_index) * image_xscale : 0;
		var _halfRight  = sprite_index != -1 ? (sprite_get_width(sprite_index) - sprite_get_xoffset(sprite_index)) * image_xscale : 0;
		var _halfTop    = sprite_index != -1 ? sprite_get_yoffset(sprite_index) * image_yscale : 0;
		var _halfBottom = sprite_index != -1 ? (sprite_get_height(sprite_index) - sprite_get_yoffset(sprite_index)) * image_yscale : 0;	    x = clamp(x, _halfLeft, room_width - _halfRight);
	    y = clamp(y, _halfTop, room_height - _halfBottom);
	    // --------------------------------
		var _checkTerrain = instance_place(x, y + sprite_height - drag_draw_offset, o_impassable);
		var _deployable = false
		var _cx = x;
		var _cy = y;
		var myId = self
		var u;
		var _lineClear = false;

		for (var i = 0; i < instance_number(o_unit); i++)
		{
		    u = instance_find(o_unit, i);
		    if (u == id) continue;
		    if (u.allegience != "player") continue;
		    if (point_distance(x, y - drag_draw_offset, u.x, u.y) <= u.range and not u.inCombat)
		    {
				 u.drawCircle = true;
				 lastFriendly = u;
		        _deployable = true;
				if(_deployable){
					_lineClear = not line_blocked(x, y - drag_draw_offset, lastFriendly.x, lastFriendly.y)
				}
				if(_lineClear){
					break;
				}else{
					continue;
				}
		    }
		}
		valid = (_checkTerrain == noone) && _deployable && _lineClear;

		if (!valid)
		{
		    x = last_valid_x;
		    y = last_valid_y;
			global.deployHighlight = lastFriendly;	
		}
		else
		{
		    last_valid_x = x;
		    last_valid_y = y;
			if(lastFriendly != noone){
				global.deployHighlight = u;
			}
		}
	    findNewTargetForSelf();
		place()
	}
	breathe_timer += breathe_speed * (delta_time / 1000000) * 60;
	image_xscaleToSend = og_image_xscale * (base_scale + sin(breathe_timer) * breathe_amount);

	// "true" position is whatever x was before we started nudging it

	breatheDrawXOffset = ((image_xscaleToSend - og_image_xscale) * sprite_center_offset);

	if (global.draggingUnit == self){
		global.expectedDmg = 0;
		with(o_unit){
		    // 4. Check if that dragged enemy is within THIS unit's range
		    var dist = point_distance(x, y - drag_draw_offset, global.draggingUnit.x, global.draggingUnit.y - global.draggingUnit.drag_draw_offset);
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
	global.expectedDmg = 0;

	
	// will run for every unit which is bad but eh
	// 4. Check if that dragged enemy is within THIS unit's range
	if (global.draggingUnit != noone and global.draggingUnit != self) {
	    var dist = point_distance(x, y, global.draggingUnit.x, global.draggingUnit.y - global.draggingUnit.drag_draw_offset);

	    if (dist <= range and global.draggingUnit.allegience != allegience and reactionStrike) {
	        drawCircle = true;
	        tmpTarget = global.draggingUnit;
	        global.expectedDmg += damage;
	    }
	} else if (global.draggingUnit == self) {
		drawCircle = true; // always sho circle on the unit being dragged
	}
	///////////////////////////////////////// on taking damage kill unitlets /////////////////////
	if(array_length(unitlets) > hp){
		ulet = array_pop(unitlets);
		instance_destroy(ulet);
	}
	/////////////////////////////////////// drop animation
	
	
	////////////////////////////////////// exoected dmg calculation ///////////////
	if(not noEyes){
		blink -= delta_time;
		if(blink <= 0){
			lEye.blink()
			rEye.blink()
			blink = maxBlink
		}
	}

	if (hit_timer > 0){
	    hit_timer--;
	}
	mouseClicked = false;
	//draw
	if (drawCircle or global.deployHighlight == id or signalFromUnitlet){
		mous = true;
	    if (not noUnitlets){
	        glow = true;
			alpha = 0.5;
	        ulets = array_length(unitlets) - 1;
	        while(ulets >= 0){
	            unitlets[ulets].glow = true;
	            ulets -= 1;
	        }
	        signalFromUnitlet = false;
	    }
	}
	cam = view_camera[0];
	viewX = camera_get_view_x(cam);
	viewY = camera_get_view_y(cam);
	viewW = camera_get_view_width(cam);
	viewH = camera_get_view_height(cam);
	guiX = (x - viewX) * display_get_gui_width() / viewW;
	guiY = (y - viewY) * display_get_gui_height() / viewH;
		
	xx = guiX;
	yy = guiY;
		
	image_xscale = og_image_xscale * (base_scale + sin(breathe_timer) * breathe_amount);
	image_yscale = og_image_yscale * base_scale;
	
	if (inCombat){
		color = c_gray;
		alpha = 0.7;
	}else{
		color = c_white
	    alpha = 1.0;
	}
	array_push(o_draw_manager.units,id)
}