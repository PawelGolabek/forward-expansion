ttl -= delta_time;

//depth = y + 40000000;
if(ttl < 0){
	instance_destroy();
}