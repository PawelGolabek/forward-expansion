depth = owner.y + y/1.2 - 20;

if(not noEyes){
	blink-=delta_time;
	if(blink <= 0){
		lEye.blink()
		rEye.blink()
		blink = maxBlink
	}
}


if (position_meeting(mouse_x + sprite_width/2, mouse_y + sprite_height, id))
{
	unit.signalFromUnitlet = true;
}


	if (animationOn) {
	    breathe_timer += breathe_speed * (delta_time / 1000000) * 60;
	    image_xscale = og_image_xscale * (base_scale + sin(breathe_timer) * breathe_amount);
	    image_yscale = og_image_yscale * base_scale;

	    // "true" position is whatever x was before we started nudging it

	    breatheDrawXOffset = ((image_xscale - og_image_xscale) * sprite_center_offset);
		image_xscaleToSend = image_xscale;
	}
timeElapsed += delta_time
//image_angle = (sin(timeElapsed/100000)) 


if(owner.dragging){
	if(point_distance_ellipse_sq(x, y, owner.x, owner.y, 0.6) > owner.range * owner.range){
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


