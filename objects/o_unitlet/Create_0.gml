function initiate(){
	
	show_debug_message(image_xscale)
	show_debug_message(image_yscale)
	noEyes = false;
	eyeX = 20;
	eyeDist = 30;

	lEye = instance_create_depth(x-sprite_width+eyeDist + eyeX,y,depth-10,o_eye);
	rEye = instance_create_depth(x-sprite_width+sprite_width-eyeDist + eyeX,y,depth-10,o_eye);

	lEye.image_xscale = image_xscale
	lEye.image_yscale = image_yscale
	rEye.image_xscale = image_xscale
	rEye.image_yscale = image_yscale
	lEye.owner = self;
	rEye.owner = self;
	lEye.unit = unit;
	rEye.unit = unit;
	lEye.initiate();
	rEye.initiate();

	lEye.originX = lEye.x - x;
	lEye.originY = lEye.y - y;
	rEye.originX = rEye.x - x;
	rEye.originY = rEye.y - y;

	lEyeLid = instance_create_depth(x-sprite_width+eyeDist + eyeX,y,depth-10,o_eye_lid);
	rEyeLid = instance_create_depth(x-sprite_width+sprite_width-eyeDist + eyeX,y,depth-10,o_eye_lid);

	rEyeLid.image_xscale = image_xscale
	rEyeLid.image_yscale = image_yscale
	lEyeLid.image_xscale = image_xscale
	lEyeLid.image_yscale = image_yscale
	lEyeLid.owner = self;
	rEyeLid.owner = self;
	lEyeLid.unit = unit;
	rEyeLid.unit = unit;

	rEyeLid.originX = rEye.x - x;
	rEyeLid.originY = rEye.y - y;
	lEyeLid.originX = lEye.x - x;
	lEyeLid.originY = lEye.y - y;

	lPupil = instance_create_depth(
	    lEye.x,
	    lEye.y,
	    depth-10,
	    o_pupil
	);
	lPupil.image_xscale = image_xscale;
	lPupil.image_yscale = image_yscale;

	lPupil.owner = self;
	lPupil.unit = unit;

	lPupil.originX = lPupil.x - x;
	lPupil.originY = lPupil.y - y;

	rPupil = instance_create_depth(
	    rEye.x,
	    rEye.y,
	    depth-10,
	    o_pupil
	);
	rPupil.image_xscale = image_xscale
	rPupil.image_yscale = image_yscale

	rPupil.owner = self;
	rPupil.unit = unit;

	rPupil.originX = rPupil.x - x;
	rPupil.originY = rPupil.y - y;

	blink = 20000000+random(200000);
	maxBlink = blink;
	drag_draw_offset = 0;
}


function initiate2(){}