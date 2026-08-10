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
		for (var i = 0; i < 200; i++) {
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



