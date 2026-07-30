if(not noEyes){
	instance_destroy(lPupil)
	instance_destroy(rPupil)
	instance_destroy(lEye)
	instance_destroy(rEye)
	instance_destroy(lEyeLid)
	instance_destroy(rEyeLid)
}

instance_destroy(skull)
instance_destroy(arrow)

while(array_length(unitlets) > 0){
	ulet = array_pop(unitlets);
	instance_destroy(ulet);
}

with(o_expand_circle){
	if(owner == other){
		instance_destroy()
	}
}


while(array_length(hearts) > 0){
	heart = array_pop(hearts);
	instance_destroy(heart);
}