// Create event or a persistent spot
//Outline shader
//Outline shader
sprite_scale = shader_get_uniform(shd_outline, "sprite_size");
outline_surf = -1
tex = sprite_get_texture(sprite_index,image_index);
//Texel
tex_h = (1/sprite_height)*image_yscale;
tex_w = (1/sprite_width)*image_xscale;
glow = false;
redGlow = false;
// Create event (once)
u_outlineColor = shader_get_uniform(shd_outline, "outlineColor");
u_spriteSize   = shader_get_uniform(shd_outline, "sprite_size");
noEyes = false;
//animations
animationOn = true
breathe_timer = random(200000);
breathe_speed = 0.05;   // how fast it breathes
breathe_amount = 0.05;  // how much it scales (0.05 = 5%)
base_scale = 1;         // your sprite's normal scale
hit_timer = 0;
drawCircle = false;
og_image_xscale = 1;
og_image_yscale = 1;
breatheDrawXOffset = 0
image_xscaleToSend = 1;
inCombat = false;
color= c_white;
alpha = 1.0;
timeElapsed = random(100000)

function initiate(){
	if(not noEyes){
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

		blink = 10000000+random(20000000);
		maxBlink = blink;
	}
	drag_draw_offset = 0;
}


function initiate2(){}