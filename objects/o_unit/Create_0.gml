allegience = "enemy"
name = "NO NAME ASSIGNED";
range = 1000;
damage = 100
hp = 10
maxhp = hp
firstStrike = true;
reactionStrike = true;
crystalCost = 10
//tmp variables for combat
damageTaken = 0
drawCircle = false; 
fragility = 10;
aiType = "melee";
animationOn = true;
//targetting
target = noone;
tmpTarget = noone;
targetted = false;
// ui
arrow = instance_create_depth(x,y,depth-10,o_arrow)
arrow.owner = self
standard_collisions = mask_index
dragging_mask = s_unit_mask
lastFriendly = noone;
//// this makes no sense but might keep it for later.
noEyes = true
//cosmetics
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
drawCircle = false;
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

//shaders
u_shadow_color = shader_get_uniform(shd_shadow, "u_shadow_color");

// Shadow settings: Adjust these to change how the shadow looks
shadow_offset_y = 60;     // How far "down" the shadow sits from the sprite's feet
shadow_alpha = 0.7;      // Transparency of the shadow (0 = invisible, 1 = solid)
shadow_yscale = 0.7;     // Squishes the shadow vertically to give it a flat, top-down floor look

function mouseEvent(){
	mouseClicked = true;
}

function line_blocked(_x1, _y1, _x2, _y2)
{
    var dist = point_distance(_x1, _y1, _x2, _y2);
    var dir  = point_direction(_x1, _y1, _x2, _y2);

    for (var d = 0; d < dist; d += 4) // sample every 4 pixels
    {
        var xx = _x1 + lengthdir_x(d, dir);
        var yy = _y1 + lengthdir_y(d, dir);

        if (position_meeting(xx, yy, o_impassable))
            return true;
			u = instance_place(xx, yy, o_unit);
			if (u != noone)
			{
			    if (u.allegience != allegience)
			    {
			        return true;
			    }
			}
    }

    return false;
}

function place(){
	if (mouseClicked and valid){
		with(o_spawner_parent){
			selected = false;
		}
		if(last_valid_x < 0 and last_valid_y < 0){
			global.dropped = noone;
			global.draggingUnit = noone;
			global.deployHighlight = noone;
			instance_destroy();
		}else{
			o_clock.toNextEvent = o_clock.maxToNextEvent;
		    ds_queue_enqueue(o_clock.action_queue, {
		        // FIXED: Use 'id' instead of 'self' to guarantee a solid instance reference
		        my_spawned_unit: id,
		        func: function() {
			
					o_combat_log.log("Player spawned " + my_spawned_unit.name );
		            var _unit = self.my_spawned_unit;
            
		            // Safety check: Make sure the unit wasn't somehow destroyed while waiting in the queue
		            if (instance_exists(_unit)) {
		                with (_unit) {
		                    // 1. These now run perfectly inside the unit's scope AFTER the delay
		                    resetTargets();
                    
		                    global.dropped = id; 
		                    global.draggingUnit = id;
		                    o_combat_resolver.resolve_first_strike();
                    
						    global.dropped = noone;
						    global.draggingUnit = noone;
						    global.deployHighlight = noone;
						    // 2. Clear state inside the unit context right as combat resolves
		                    if (variable_instance_exists(id, "lastFriendly") && instance_exists(lastFriendly)) {
		                        lastFriendly.drawCircle = false;
		                        lastFriendly = noone;
		                    }
		                }
		            }
		            // 3. Resolve global combat after the unit handles its drop actions
		            o_combat_resolver.resolve_combat();
		        }
		    }); 
				o_deck_holder.discard_card(parentSpawner);
				dragging = false;
				placed = true;
				drag_draw_offset = 0;
				drag_draw_offset = 0;
				mask_index = standard_collisions;       
				tmp = hp;
				repeat(tmp)
				{
				    var placed_ok = false;
				    var tries = 0;
				    var angle;
				    var dist;
				    var px;
				    var py;

				    while (!placed_ok && tries < 40)
				    {
				        angle = random(360);
				        dist = random(100);

				        px = x + lengthdir_x(dist, angle);
				        py = y + lengthdir_y(dist, angle);

				        placed_ok = !place_meeting(px, py, o_unitlet) && !place_meeting(px, py, o_unit);

				        tries++;
				    }

				    ulet = instance_create_depth(px, py, depth, myUnitlet);
					array_push(unitlets,ulet);

				    ulet.owner = self;
				    ulet.unit = self;
				    ulet.image_xscale = 0.3;
				    ulet.image_yscale = 0.3;
					ulet.initiate();
					ulet.initiate2();
				}
			}
		}
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
        var dist = point_distance(myX, myY, x, y);
        
        // If this enemy is closer than the previous closest, update it
        if (dist < minDistance && myRange > dist)
        {
            minDistance = dist;
            closestEnemy = id;
        }
    }
    
    // Set ONLY this unit's target to the closest enemy found
    target = closestEnemy; 
}


function onRoundEnd(){
	if(not instance_exists(target) or target == noone){
		findNewTargetForSelf() 
	}
	
}

