friction1 = 0.99999999
ySpeed += 0.1 * delta_time;
xSpeed *= power(friction1, delta_time * 0.0000001);
x += xSpeed * delta_time * 0.00000002;
y += ySpeed * delta_time * 0.00000001;
ttl -= delta_time
if(ttl <= 0){
	x = targetX + 25 - random(50)
	y = targetY + 25 - random(50)
	instance_create_depth(x,y,200,o_bloodstain)
	instance_destroy()
}