// --- 1. DRAGGING LINE ---
if (global.draggingUnit == self and global.deployHighlight != noone){
    draw_line_width(x, y - drag_draw_offset, global.deployHighlight.x, global.deployHighlight.y, 10);
}


mous = (x - sprite_width/2 < mouse_x and x + sprite_width/2 > mouse_x and y - sprite_height < mouse_y and y > mouse_y);
// Default: child circle is allowed to die once it's invisible.
// Only cleared to false below while we still want it alive.
wantCircle = (mous or dragging or drawCircle or targettedByDragging or applyingAura);
applyingAura = false;

circleOverride = true;
if(wantCircle){
	_expected = calculateDamageExpectedDelayed();
	for(i = 0; i < maxhp; i+=1){
		with(hearts[i]){
			visible = false;
			container.visible = true;
		}
	}
	for(i = 0; i < hp; i += 1){
		with(hearts[i]){
			visible = true;
		}
	}
}else{
	for(i = 0; i < array_length(hearts); i+=1){
		with(hearts[i]){
			visible = false;
			container.visible = false;
		}
	}
}

targettedByDragging = false;
// Resync our tracking flag in case the child already self-destructed.
if (immortalExists and not instance_exists(circleInst)) {
    immortalExists = false;
}


if (wantCircle or keyboard_check(vk_tab) or circleOverride) {
    if (not immortalExists) {
		if(deployAlly){
			if(allegience == "enemy"){
				circleInst = instance_create_layer(x, y - drag_draw_offset, "units", o_expand_circle_enemy);
			}else{
				circleInst = instance_create_layer(x, y - drag_draw_offset, "units", o_expand_circle_1);
				show_debug_message("created immortal")
	
			}
			
			immortal = circleInst
	        circleInst.life = 1;
	        circleInst.owner = id;
	        circleInst.end_scale = (range / circleInst.sprite_width) * 2;
	        circleInst.owner = self;
	        circleInst.immortal = true;
	        circleInst.timer = circleInst.life;
	        immortalExists = true;
		    circleInst.x = x;
		    circleInst.y = y - drag_draw_offset;
		}
    }
    killImmortal = false;
    mousVisible = true;
	circleOverride = false;

/*
	draw_surface(global.threatSurf, 0, 0); // no draw_set_alpha needed, it's baked in
    // Draw the threat-radius half circle whenever the persistent circle is active
    draw_set_alpha(0.15);
    draw_set_color(c_blue);
    draw_half_circle(x, y - drag_draw_offset, range, 0, 180);              // bottom half
    draw_half_circle_scale(x, y, range, 180, 360, 1.0, 0.6); // top half (squashed)
    draw_set_alpha(1.0);
	
	*/
	
} else {
    mousVisible = false;
}

// --- 3. PERIODIC PULSE CIRCLES (self-destructing, unrelated to immortal one) ---

if (mousCooldown == 0){
	if(allegience == "enemy"){
		u = instance_create_layer(x, y - drag_draw_offset, "units", o_expand_circle_enemy_top);
	    u.life = random(150) + 150;
	    u.end_scale = (range / u.sprite_width) * 2;
	    u.owner = self;
	    u.timer = 0;
	    mousCooldown = mousMaxCooldown;
	}else{
		if(aura){
			u1 = instance_create_layer(x, y - drag_draw_offset, "units", o_expand_circle_3);
			u1.owner = self;
			u2 = instance_create_layer(x, y - drag_draw_offset, "units", o_expand_circle_1);	
			u2.owner = self;
			
			u1.life = random(150) + 150;
		    u1.end_scale = (range / u1.sprite_width) * 2;
		    u1.owner = self;
		    u1.timer = 0;
		    mousCooldown = mousMaxCooldown;
		}else{
			u2 = instance_create_layer(x, y - drag_draw_offset, "units", o_expand_circle_1);
			
			u2.life = random(150) + 150;
		    u2.end_scale = (range / u2.sprite_width) * 2;
		    u2.owner = self;
		    u2.timer = 0;
		    mousCooldown = mousMaxCooldown;
		}
	}
}
if (mousCooldown != 0){
    mousCooldown -= delta_time;
}
if (mousCooldown < 0){
    mousCooldown = 0;
}

// --- 4. TILEMAP & ALPHA STATE ---
color = c_white;
//var tilemap = layer_tilemap_get_id("Tiles_1");
//tilemap_get_at_pixel(tilemap, x, y);
glow = false;

// --- 5. ADDITIONAL GAMEPLAY ELEMENTS ---
if (not noEyes){
    lPupil.movePupil();
    rPupil.movePupil();
    lEye.moveEye();
    rEye.moveEye();
    lEyeLid.moveEye();
    rEyeLid.moveEye();
}

// Death indicator
var inst = instance_position(x, y, o_unit);
if (expectedDamage >= hp){
  //  skull.visible = true;
  //skull is weirdly bugged so lets disable for now.
}else{
    skull.visible = false;
}

/*
if (inst != noone && inst != id)
{
    draw_text_colour(
        x + sprite_width/2, y + sprite_height - drag_draw_offset - 180, "Im colliding",
        c_yellow, c_yellow, c_yellow, c_green, 1
    );
}

// HP Hover UI
if (position_meeting(mouse_x, mouse_y, id)){
    draw_set_font(Font3);
    draw_text_ext_colour(x + sprite_width/2, y + sprite_height - drag_draw_offset + 40, string(hp), 0, 200, c_gray, c_dkgray, c_dkgray, c_black, 0.9);
}