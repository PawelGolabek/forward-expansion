var inst = instance_position(x, y, o_unit);


if (inst != noone && inst != id)
{
    draw_text_colour(
        x, y - 180, "Im colliding",
        c_yellow,
        c_yellow,
        c_yellow,
        c_green,
        1
    );
}

image_alpha = 0.5
color = c_white

if (shader_is_compiled(shd_shadow)) {
	shader_set(shd_shadow);
	var shadow_r = 0.1;
	var shadow_g = 0.1;
	var shadow_b = 0.1;
	if (hit_timer > 0) {
	    shadow_r = 1.0;
	    shadow_g = 0.0;
	    shadow_b = 0.0;
		color = c_red
	}
	//shadow
    shader_set_uniform_f(u_shadow_color, shadow_r, shadow_g, shadow_b, shadow_alpha);
    draw_sprite_ext(
        sprite_index,
        image_index,
        x, y + shadow_offset_y,
        image_xscale * 0.9,
        image_yscale * 0.5,
        0,
        c_white,
        0.4
    );

    shader_reset();
}
// --- 2. DRAW SELF (Your original code starts here) ---


// active / in combat
color = c_white
inCombat = false;
with(o_unit){
	if(point_distance(x,y,other.x,other.y) <= range and allegience != other.allegience){
		other.inCombat = true;
	}
}
if(inCombat){
	color = c_gray;
}

if(animationOn){
	
	draw_sprite_ext(sprite_index, image_index, x, y + drag_draw_offset, image_xscale, image_yscale, image_angle, color, alpha);
}else{
	draw_self();
}
var w = 30;
var h = 12;
var x1 = x - w * 0.5;
var y1 = y - 40;

var hp_ratio = hp / maxhp;
totalLength = w + maxhp ;

// hp
// background
draw_set_color(c_gray);
draw_rectangle(x1, y1, x1 + totalLength, y1 + h, false);

// fill 
draw_set_color(c_lime);
if(hp_ratio <= 0.5){
	draw_set_color(c_yellow);
}

if(hp_ratio <= 0.2){
	draw_set_color(c_red);
}

draw_rectangle(x1, y1, x1 + ( hp_ratio * totalLength), y1 + h, false);
draw_set_color(c_white);

// 2. Check if a valid unit is currently being dragged

if(drawCircle or global.deployHighlight == id or signalFromUnitlet){
	
	ulets = array_length(unitlets) - 1
	while(ulets >= 0){
		unitlets[ulets].glow = true;
		ulets-=1;
	}
	signalFromUnitlet = false;
	// The enemy is in range! Draw this unit's threat radius.
	var circleColor = c_orange; // Orange/Yellow works great for a warning outline
	draw_set_alpha(0.5); // Semi-transparent outline
	draw_circle_color(x, y, range, circleColor, circleColor, true);
	draw_set_alpha(0.15); // Super faint filled center
	draw_circle_color(x, y, range, circleColor, circleColor, false);

	// Reset alpha back to normal
	draw_set_alpha(1.0);
	if(global.deployHighlight == self){
		global.deployHighlight = noone;
	}
}

if(global.draggingUnit == self and global.deployHighlight != noone){
	draw_line_width(x,y,global.deployHighlight.x, global.deployHighlight.y,10)
}
			
	
if (global.draggingUnit == self)
{
	draw_set_font(fnt_24);
	draw_text_colour(x, y-180, global.expectedDmg,
    c_yellow,  // bottom-right
    c_yellow,  // bottom-right
    c_yellow,  // bottom-right
    c_green,  // bottom-right
    1)
}


if (position_meeting(mouse_x, mouse_y, id)){
	draw_set_font(fnt_24);
	draw_text_colour(x, y+40, hp,
    c_yellow,  // bottom-right
    c_yellow,  // bottom-right
    c_yellow,  // bottom-right
    c_green,  // bottom-right
    1
);
}

if(not noEyes){
	lPupil.movePupil();
	rPupil.movePupil();
	lEye.moveEye();
	rEye.moveEye();
	lEyeLid.moveEye();
	rEyeLid.moveEye();

}