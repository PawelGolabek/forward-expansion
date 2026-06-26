allegiance = "enemy"

range = 1000
target = noone
hp = 10
maxHp = hp

arrow = instance_create_depth(x,y,depth-10,o_arrow)
arrow.owner = self
function resetTargets() 
{
    // Store references to the dropped unit's properties before looping
    var droppedUnit = self;
    var droppedAllegience = allegience;
    var droppedX = x;
    var droppedY = y;
    
    // 1. OTHER UNITS: Check if they should target the dropped unit
    with (o_unit) 
    {
        // Don't check yourself
        if (id == droppedUnit) continue; 
        
        // If this unit is an enemy to the dropped unit
        if (allegience != droppedAllegience) 
        {
            // Check if the dropped unit is within this unit's specific range
            if (point_distance(x, y, droppedX, droppedY) <= range) 
            {
                target = droppedUnit; // Mark it as their target
            }
        }
    }
    
    // 2. DROPPED UNIT: Find the closest enemy unit for itself
    var closestEnemy = noone;
    var minDistance = infinity; // Start with the highest possible number
    
    with (o_unit) 
    {
        // Skip yourself and skip teammates
        if (id == droppedUnit || allegience == droppedAllegience) continue;
        
        // Calculate distance to this potential enemy
        var dist = point_distance(droppedX, droppedY, x, y);
        
        // If this one is closer than the previous closest, update it
        if (dist < minDistance) 
        {
            minDistance = dist;
            closestEnemy = id;
        }
    }
    
    // Set the dropped unit's target to the closest enemy found (will be 'noone' if none exist)
    target = closestEnemy; 
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
    
    // Loop through all units to find the closest enemy
    with (o_unit) 
    {
        // Skip yourself and skip teammates
        if (id == myId || allegience == myAllegience) continue;
        
        // Calculate distance from the calling unit to this potential enemy
        var dist = point_distance(myX, myY, x, y);
        
        // If this enemy is closer than the previous closest, update it
        if (dist < minDistance) 
        {
            minDistance = dist;
            closestEnemy = id;
        }
    }
    
    // Set ONLY this unit's target to the closest enemy found
    target = closestEnemy; 
}


function onRoundEnd(){
	if(not instance_exists(target)){
		findNewTargetForSelf() 
	}
}

