if(target != noone && instance_exists(target)){

	var baseDir = point_direction(x, y, target.x, target.y);
	var moveDist = speed1 * delta_time / 1000000;
	x = x + lengthdir_x(moveDist, baseDir);
	y = y + lengthdir_y(moveDist, baseDir);

	if(point_distance_ellipse_sq(x,y,target.x,target.y,0.6) < 25){
		target.dealDamage(damage,deadly);
		instance_destroy();
	}

}else{

	ttl -= delta_time;
	targetX = initialTargetX
	targetY = initialTargetY
	var baseDir = point_direction(x, y, targetX, targetY);
	var moveDist = speed1 * delta_time / 1000000;
	initialTargetY = initialTargetY + speed1 * delta_time;
	y -= speed1 * delta_time;
	if(ttl <= 0){
		instance_destroy()
	}
}