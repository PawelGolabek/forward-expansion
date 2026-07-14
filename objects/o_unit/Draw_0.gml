

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
        og_image_xscale * 0.9,
        og_image_yscale * 0.5,
        0,
        c_white,
        0.4
    );
    shader_reset();
}


var cam = view_camera[0];
var vx = camera_get_view_x(cam) - 50;
var vy = camera_get_view_y(cam) - 50;
var vw = camera_get_view_width(cam) + 100;
var vh = camera_get_view_height(cam) + 100;

if (bbox_right < vx ||
    bbox_left > vx + vw ||
    bbox_bottom < vy ||
    bbox_top > vy + vh)
{
    exit; // Don't draw
}
// Draw event
shader_set(shd_outline);


shader_set_uniform_f(u_outlineColor, 0.0, 0.0, 0.0, 1.0); // black

draw_sprite_ext(sprite_index, image_index, x, y, og_image_xscale*1.2, og_image_yscale*1.2, image_angle, c_white, image_alpha);


if (redGlow){
	redGlow = false;
	shader_set_uniform_f(u_outlineColor, 1.0, 0.0, 0.0, 1.0); // red	
	draw_sprite_ext(sprite_index, image_index, x, y, og_image_xscale*1.1, og_image_yscale*1.1, image_angle, c_white, image_alpha);
} else if (glow) {
	glow = false;
    shader_set_uniform_f(u_outlineColor, 1.0, 1.0, 0.0, 1.0); // yellow
	draw_sprite_ext(sprite_index, image_index, x, y, og_image_xscale*1.1, og_image_yscale*1.1, image_angle, c_white, image_alpha);

}

shader_reset();

if(not noEyes){
	lPupil.movePupil();
	rPupil.movePupil();
	lEye.moveEye();
	rEye.moveEye();
	lEyeLid.moveEye();
	rEyeLid.moveEye();
}

if(animationOn){
	
	draw_sprite_ext(sprite_index, image_index, x, y + drag_draw_offset, og_image_xscale, og_image_yscale, image_angle, color, alpha);
}else{
	draw_self();
}



// death indicator
var inst = instance_position(x, y, o_unit);
if(expectedDamage >= hp){
	skull.visible = true;
}else{
	skull.visible = false;
}

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


// active / in combat
color = c_white
inCombat = false;
with(o_unit){
	if(point_distance(x,y,other.x,other.y) <= range and allegience != other.allegience){
		other.inCombat = true;
	}
}

// in combat indicator for blocked spawn
if(inCombat){
	color = c_gray;
}


//////////// hp bar
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


if(drawCircle or global.deployHighlight == id or signalFromUnitlet){
	if(not noUnitlets){
		glow = true;
		ulets = array_length(unitlets) - 1
		while(ulets >= 0){
			unitlets[ulets].glow = true;
			ulets-=1;
		}
		signalFromUnitlet = false;
	}
	// The enemy is in range! Draw this unit's threat radius.
	var circleColor = c_blue; // Orange/Yellow works great for a warning outline
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

// hp on hover. to change or delete tbh
if (position_meeting(mouse_x, mouse_y, id)){

    draw_set_font(Font3);
	draw_text_ext_colour(x, y+40 ,string(hp),0, 200, c_grey,c_dkgrey,c_dkgray,c_black,0.9 );
}


// this has to be replaced with a sprite with a nice shader. This is a death to the optimisation. The destroyer of worlds
function draw_circle_square(){
	var tile = 16; // grid size
	var radius = range;

	draw_set_alpha(0.1);
	draw_set_color(c_maroon);

	var start_x = floor((x - radius) / tile);
	var end_x   = floor((x + radius) / tile);
	var start_y = floor((y - radius) / tile);
	var end_y   = floor((y + radius) / tile);

	for (var gx = start_x; gx <= end_x; gx++) {
		for (var gy = start_y; gy <= end_y; gy++) {
			var cx = gx * tile + tile * 0.5;
			var cy = gy * tile + tile * 0.5;

			if (point_distance(x, y, cx, cy) <= radius) {
				draw_rectangle(
					gx * tile,
					gy * tile,
					gx * tile + tile,
					gy * tile + tile,
					true
				);
			}
		}
	}

	draw_set_alpha(1);
	
	


}