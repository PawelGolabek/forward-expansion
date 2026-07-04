allegience = "enemy"

name = "NO NAME ASSIGNED";
range = 1000;
target = noone;
tmpTarget = noone;
damage = 100
hp = 10
maxhp = hp
firstStrike = true;
reactionStrike = true;
//tmp variables for combat
damageTaken = 0
drawCircle = false; 
fragility = 10;
aiType = "melee";
animationOn = true;

// ui
arrow = instance_create_depth(x,y,depth-10,o_arrow)
arrow.owner = self
standard_collisions = mask_index
dragging_mask = s_unit_mask
lastFriendly = noone;
//cosmetics
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
blink = 2000000+random(20000);
maxBlink = blink
noEyes = false
//animations
breathe_timer = 0;
breathe_speed = 0.05;   // how fast it breathes
breathe_amount = 0.05;  // how much it scales (0.05 = 5%)
base_scale = 1;         // your sprite's normal scale
hit_timer = 0;
drawCircle = false;
//drag
drag_draw_offset = 0;
justFinishedDragging = false;
placed = false;
//log
logDeath = true;
logHit = true;

//shaders
u_shadow_color = shader_get_uniform(shd_shadow, "u_shadow_color");

// Shadow settings: Adjust these to change how the shadow looks
shadow_offset_y = 60;     // How far "down" the shadow sits from the sprite's feet
shadow_alpha = 0.7;      // Transparency of the shadow (0 = invisible, 1 = solid)
shadow_yscale = 0.7;     // Squishes the shadow vertically to give it a flat, top-down floor look


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

