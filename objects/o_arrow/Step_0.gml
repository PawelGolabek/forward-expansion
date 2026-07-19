x = owner.x
y = owner.y - 30
depth = owner.depth - 200

// calculate damage for units
if (instance_exists(owner.tmpTarget) and owner.tmpTarget != noone){
    image_angle = point_direction(x, y - owner.drag_draw_offset, owner.tmpTarget.x, owner.tmpTarget.y - owner.drag_draw_offset);	
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
    image_angle = point_direction(x, y - owner.drag_draw_offset, owner.target.x, owner.target.y - owner.target.drag_draw_offset);
	visible = true
}else{
	visible = false
}