// Inherit the parent event
event_inherited();

if(instance_exists(myShield)){
	instance_destroy(myShield);
}

with(o_unit){
	if(point_distance_ellipse_sq(x,y,other.x,other.y,0.6) <= other.range * other.range and allegience == other.allegience){
		shieldActive = false;
	}
}