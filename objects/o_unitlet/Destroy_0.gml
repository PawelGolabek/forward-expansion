if(not owner.recalled and bloodOnDeath){
	instance_create_depth(x,y,depth-20,o_blood_droplet)
}

if(explosionOnDeath){
	instance_create_depth(x,y,depth-20,o_explosion)
}

	
if(not noEyes){
	instance_destroy(lPupil)
	instance_destroy(rPupil)
	instance_destroy(lEye)
	instance_destroy(rEye)
	instance_destroy(lEyeLid)
	instance_destroy(rEyeLid)
}



// in the unitlet's Destroy event (or death code)
if(instance_exists(shield)){
	instance_destroy(shield);
}

