x = owner.x
y = owner.y - 30

if(global.draggingUnit != noone){
	other1 = global.draggingUnit
	var dx = other1.x - owner.x;
	var dy = other1.y - owner.y;
	var dist = dx * dx + dy * dy;
	if(dist <= owner.range){
		visible = true;
	}else{
		visible = false;
	}
}else{
	visible = false;
}

if (instance_exists(owner.target))
{
    image_angle = point_direction(x, y, owner.target.x, owner.target.y);
}



//debug

visible = true