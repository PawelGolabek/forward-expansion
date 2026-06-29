friction1 = 0.99999999


ySpeed += 0.1 * delta_time;
xSpeed *= power(friction1, delta_time * 0.0000001);
y += ySpeed * delta_time * 0.00000002;
ttl -= delta_time
if(ttl <= 0){
	instance_create_depth(x,y,200,o_bloodstain)
	show_debug_message("AAAA")
	instance_destroy()
}