if(owner != noone){
	visible = owner.mousVisible
}

var t = clamp(timer / life, 0, 1);
var e = sin(t * pi * 0.5);
var scale = lerp(start_scale, end_scale, e);
image_xscale = scale;
image_yscale = scale;
image_alpha = clamp(0.2 - t*0.2, 0.01, 1);
image_angle = ((life % 4) * angleShift ) % 4


if(not immortal){
	timer++;
}else{
	image_alpha = 0.3;
}


if (t >= 1 and not immortal)
    instance_destroy();
if(immortal and not visible){
    instance_destroy();
}