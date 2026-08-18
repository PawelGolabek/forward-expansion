
if(owner.shieldActive){
	if(not  instance_exists(shield)){
		shield = instance_create_depth(x, y, depth, o_shield_status);
		shield.owner = self;
	}
}
