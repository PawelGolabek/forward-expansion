if(initiated){

	if(not instance_exists(owner) or owner == noone){
		instance_destroy();
		exit;
	}

	x = owner.x - sprite_width/2;
	y = owner.y - sprite_height;
	depth = owner.depth - 10;
	
}