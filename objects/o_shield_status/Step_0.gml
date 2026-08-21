
if(image_xscale != 1){
	image_xscale += delta_time * 0.00001;
}

if(image_xscale > 1){
	image_xscale = 1;
}



if(owner.owner != noone){
	visible = owner.owner.shieldActive;
}else{
	visible = false;
}
	// shield logic will probably change to be about the individual unit instead;
x = owner.x
y = owner.y
depth = owner.depth - 100000

if(!visible){
	instance_destroy();
}