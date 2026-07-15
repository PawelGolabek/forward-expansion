

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









color = c_white
var tilemap = layer_tilemap_get_id("Tiles_1");
tilemap_get_at_pixel(tilemap,x,y)


outline_surf = scr_draw_sprite_outline(
    sprite_index, image_index,
     x - sprite_width, y + drag_draw_offset - sprite_height,
     og_image_xscale, og_image_yscale,
    c_white, image_alpha,   // sprite blend/alpha
    20, c_black,              // outline thickness (px), outline colour
    outline_surf
);



if (redGlow){
outline_surf = scr_draw_sprite_outline(
    sprite_index, image_index,
     x - sprite_width, y + drag_draw_offset - sprite_height, og_image_xscale, og_image_yscale,
    c_white, image_alpha,   // sprite blend/alpha
    2, c_red,              // outline thickness (px), outline colour
    outline_surf
);
	redGlow = false;
} else if (glow) {
outline_surf = scr_draw_sprite_outline(
    sprite_index, image_index,
     x + 1/2*sprite_width, y + drag_draw_offset - 1/2 * sprite_height, og_image_xscale, og_image_yscale,
    c_white, image_alpha,   // sprite blend/alpha
    20, c_yellow,              // outline thickness (px), outline colour
    outline_surf
);
	glow = false;
}



if(inCombat){
	alpha = 0.7;
}else{
	alpha = 1;
}

//draw_sprite_ext(sprite_index, image_index, x + 1/2*sprite_width, y + drag_draw_offset - 1/2 * sprite_height, og_image_xscale, og_image_yscale, image_angle, c_white, alpha);

outline_surf = scr_draw_sprite_outline(
    sprite_index, image_index,
     x + 1/2*sprite_width, y + drag_draw_offset - 1/2 * sprite_height, og_image_xscale, og_image_yscale,
    c_white, alpha,   // sprite blend/alpha
    0, c_white,              // outline thickness (px), outline colour
    outline_surf
);

glow = false;


if(not noEyes){
	lPupil.movePupil();
	rPupil.movePupil();
	lEye.moveEye();
	rEye.moveEye();
	lEyeLid.moveEye();
	rEyeLid.moveEye();
}

/*
if(animationOn){
	draw_sprite_ext(sprite_index, image_index, x, y - sprite_height*1.1/2 + drag_draw_offset, og_image_xscale, og_image_yscale, image_angle, color, alpha);
}else{
	draw_self();
}

*/

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



// hp on hover. to change or delete tbh
if (position_meeting(mouse_x, mouse_y, id)){

    draw_set_font(Font3);
	draw_text_ext_colour(x, y+40 ,string(hp),0, 200, c_grey,c_dkgrey,c_dkgray,c_black,0.9 );
}


// this has to be replaced with a sprite with a nice shade. This is a death to the optimisation. The destroyer of worlds
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