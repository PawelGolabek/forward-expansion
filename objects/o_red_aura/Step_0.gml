if(not instance_exists(owner) or owner == noone){
	instance_destroy();
	exit;
}

x = owner.x - owner.sprite_width/2 - sprite_width * 10.5;
y = owner.y;
depth = owner.depth - 10;