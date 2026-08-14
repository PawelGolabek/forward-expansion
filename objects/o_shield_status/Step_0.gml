
if(image_xscale != 1){
	image_xscale += delta_time * 0.00001;
}

if(image_xscale > 1){
	image_xscale = 1;
}




visible = owner.owner.shieldActive;

x = owner.x
y = owner.y
depth = owner.depth - 100000

if(!visible){
	instance_destroy();
}