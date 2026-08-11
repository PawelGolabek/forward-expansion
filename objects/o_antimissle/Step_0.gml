y -= speed1
speed1 += 0.00005 * delta_time


timeToSmoke -= delta_time;
if(timeToSmoke <= 0){
	instance_create_depth(x,y,depth,o_antimissle_smoke);
	timeToSmoke = maxTimeToSmoke;
}
if(y < 0){
	instance_destroy()
}