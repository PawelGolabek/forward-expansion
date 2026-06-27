// --- 1. DRAW SHADOW FIRST ---
if (shader_is_compiled(shd_shadow)) 
{
    shader_set(shd_shadow);
    // Set shadow color to dark grey/black with our alpha setting
    shader_set_uniform_f(u_shadow_color, 0.1, 0.1, 0.1, shadow_alpha);
    
var width_scale = 0.9; // 1.5 = 150% wider
var skew = -8; 
var sw = sprite_width * width_scale; // Scale the base width
var sh = sprite_height * 0.5;

var _x = x;
var _y = y + shadow_offset_y;

draw_sprite_pos(
    sprite_index,
    image_index,
    _x - (sw / 2) + skew, _y - sh, // Top-Left
    _x + (sw / 2) - skew, _y - sh, // Top-Right
    _x + (sw / 2),        _y,      // Bottom-Right
    _x - (sw / 2),        _y,      // Bottom-Left
    1.0
);
    
    shader_reset();
}

// --- 2. DRAW SELF (Your original code starts here) ---
//draw_self();

draw_self()

var w = 30;
var h = 12;

var x1 = x - w * 0.5;
var y1 = y - 40;

var hp_ratio = hp / maxhp;
totalLength = w + maxhp ;

// hp
// background
draw_set_color(c_red);
draw_rectangle(x1, y1, x1 + totalLength, y1 + h, false);

// fill 
draw_set_color(c_lime);
draw_rectangle(x1, y1, x1 + ( hp_ratio * totalLength), y1 + h, false);

draw_set_color(c_white);

// 2. Check if a valid unit is currently being dragged
if (instance_exists(global.draggingUnit))
{
        // 4. Check if that dragged enemy is within THIS unit's range
        var dist = point_distance(x, y, global.draggingUnit.x, global.draggingUnit.y);
		drawCircle = false
        if(global.draggingUnit == self){
			drawCircle = true
		}else if (dist <= range and global.draggingUnit.allegience != allegience
		){
			drawCircle = true
			tmpTarget = global.draggingUnit;
		}
		if(drawCircle){
	        // The enemy is in range! Draw this unit's threat radius.
	        var circleColor = c_orange; // Orange/Yellow works great for a warning outline
            
	        draw_set_alpha(0.3); // Semi-transparent outline
	        draw_circle_color(x, y, range, circleColor, circleColor, true);
            
	        draw_set_alpha(0.05); // Super faint filled center
	        draw_circle_color(x, y, range, circleColor, circleColor, false);
            
	        // Reset alpha back to normal
	        draw_set_alpha(1.0);
		}
}else{
	tmpTarget = target
}

if (position_meeting(mouse_x, mouse_y, id)){
	draw_set_font(fnt_24);
	draw_text_colour(x, y, hp,
    c_green,  // bottom-right
    c_green,  // bottom-right
    c_green,  // bottom-right
    c_green,  // bottom-right
    1
);
}