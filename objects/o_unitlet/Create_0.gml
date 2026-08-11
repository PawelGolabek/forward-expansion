// Create event or a persistent spot
//Outline shader
sprite_scale = shader_get_uniform(shd_outline, "sprite_size");
outline_surf = -1
tex = sprite_get_texture(sprite_index,image_index);
//Texel
tex_h = (1/sprite_height)*image_yscale;
tex_w = (1/sprite_width)*image_xscale;
glow = false;
redGlow = false;
blueGlow = false;
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
// fog of war related
isUnit = false;
activeAuras = []; // list of structs: { source, boost, effect } currently applied to this unit
bloodOnDeath = true;
explosionOnDeath = false;
sprite_center_offset = sprite_width/2
defaultSprite = sprite_index;
attacks = 0;
attackingSprite = s_attacking_placeholder;
targettedBySpell = false;
markForDeath = false;
ttl = -1;

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


function executeStep(){
	depth = owner.y + y/1.2 - 20;

	if(not noEyes){
		blink-=delta_time;
		if(blink <= 0){
			lEye.blink()
			rEye.blink()
			blink = maxBlink
		}
	}

	if(image_index >= image_number - 1){
	    attacks -= 1;
	    image_index = 0;
	    if(attacks <= 0){
	        global.unitActing = noone;
	        o_clock.animationBlocked = false;
			owner.unitletsCleanup();
	        unitletsNumber = array_length(owner.unitlets);
	        for(i = 0; i < unitletsNumber; i += 1){
	            owner.unitlets[i].sprite_index = defaultSprite;
	            owner.unitlets[i].attacks = 0;
	        }
	    }
	}
	if (position_meeting(mouse_x + sprite_width/2, mouse_y + sprite_height, id)){
		unit.signalFromUnitlet = true;
	}
	if (animationOn) {
		breathe_timer += breathe_speed * (delta_time / 1000000) * 60;
		image_xscale = og_image_xscale * (base_scale + sin(breathe_timer) * breathe_amount);
		image_yscale = og_image_yscale * base_scale;
		// "true" position is whatever x was before we started nudging it
		if (instance_exists(owner.tmpTarget) && owner.tmpTarget != noone) {
			if(owner.tmpTarget.x < x){
				image_xscale = - image_xscale;
			}
		} else if (instance_exists(owner.target) && owner.target != noone) {
			if(owner.target.x < x){
				image_xscale = - image_xscale;
			}
		}
		breatheDrawXOffset = ((image_xscale - og_image_xscale) * sprite_center_offset);
		image_xscaleToSend = image_xscale;
	}
	timeElapsed += delta_time
	//image_angle = (sin(timeElapsed/100000)) 

	if(owner.dragging){
		if(point_distance_ellipse_sq(x, y, owner.x, owner.y, 0.6) > owner.uletDeployMaxRange * owner.uletDeployMaxRange){
			var placed_ok = false;
			var tries = 0;
			var angle;
			var dist;
			var px;
			var py;
			var best_dist = 999999;
			var best_x = x;
			var best_y = y;
			for (i = 0; i < 200; i++) {
				angle = random(360);
				dist = random(300);
				px = owner.x + lengthdir_x(dist, angle);
				py = owner.y + lengthdir_y(dist, angle);
				// 1. Terrain Check: If not flying, must be on placeable terrain
				if (!owner.flying) {
					var _placable_terrain = instance_position(px, py, o_placable_terrain);
					if (_placable_terrain == noone) continue; // Properly skips to next for-loop iteration
				}
				// 2. Collision Check: Check for overlapping unitlets or units
				var blocked = false;
				blocked = place_meeting(px, py, o_unitlet) || 
					        place_meeting(px, py, o_unit);
				// 3. Line of Sight / Final Placement Evaluation
				if (!blocked) {
					if (dist < best_dist) {
					    best_dist = dist;
					    best_x = px;
					    best_y = py;
					}
				}
			}
			x = best_x;
			y = best_y;
		}
	}


	if(targettedBySpell){
		blueGlow = true;
	}
	if(markForDeath){
		ttl -= delta_time;
	}
	if(markForDeath and ttl < 0){
		instance_destroy();
	}
}

