x = owner.x
y = owner.y - 30
depth = owner.depth - 200

// calculate damage for units
if (instance_exists(owner.tmpTarget) and owner.tmpTarget != noone){
    image_angle = point_direction(x, y, owner.tmpTarget.x, owner.tmpTarget.y);	
	visible = true
	owner.tmpTarget.expectedDamage += owner.damage
	if(owner.reactionStrike and owner.tmpTarget.dragging){
		owner.tmpTarget.expectedDamage += owner.damage	
	}
	if(owner.firstStrike and owner.dragging){
		owner.tmpTarget.expectedDamage += owner.damage	
	}
	
}else if (instance_exists(owner.target) and owner.target != noone)
{
	owner.target.expectedDamage += owner.damage
	if(owner.reactionStrike and owner.target.dragging){
		owner.target.expectedDamage += owner.damage	
	}
	if(owner.firstStrike and owner.dragging){
		owner.target.expectedDamage += owner.damage	
	}
    image_angle = point_direction(x, y, owner.target.x, owner.target.y);
	visible = true
}else{
	visible = false
}



/*
if(owner.hp <= owner.expectedDamage){
	owner.skull.visible = true;
}else{
	owner.skull.visible = false;
}

