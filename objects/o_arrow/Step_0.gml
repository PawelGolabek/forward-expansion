x = owner.x
y = owner.y - 30
depth = owner.depth - 200


if (instance_exists(owner.tmpTarget) and owner.tmpTarget != noone){
    image_angle = point_direction(x, y, owner.tmpTarget.x, owner.tmpTarget.y);	
	visible = true
}else if (instance_exists(owner.target) and owner.target != noone)
{
    image_angle = point_direction(x, y, owner.target.x, owner.target.y);
	visible = true
}else{
	visible = false
}

