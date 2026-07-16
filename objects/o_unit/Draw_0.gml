// --- 1. SET UP UNIFIED COORDINATES ---
// We calculate scaled bounds using the original scale variables to prevent scale-desync
var _sw = sprite_get_width(sprite_index) * abs(og_image_xscale);
var _sh = sprite_get_height(sprite_index) * abs(og_image_yscale);

// Change this to (_sh / 2) if you want the vertical center directly on the cursor
var draw_x = x - (_sw / 2);
var draw_y = y + drag_draw_offset - _sh; 

// --- 3. DRAGGING LINE ---
if (global.draggingUnit == self and global.deployHighlight != noone){
    draw_line_width(x, y, global.deployHighlight.x, global.deployHighlight.y, 10);
}


// --- 2. THREAT RADIUS & RANGE CIRCLES ---
if (drawCircle or global.deployHighlight == id or signalFromUnitlet){
    // Draw threat radius
    var circleColor = c_blue; 
    draw_set_alpha(0.5); 
    draw_circle_color(x, y, range, circleColor, circleColor, true);
    
    draw_set_alpha(0.15); // Filled center
    draw_circle_color(x, y, range, circleColor, circleColor, false);
    
    draw_set_alpha(1.0); // Reset alpha
    
    if (global.deployHighlight == id){
        global.deployHighlight = noone;
    }
}

// --- 4. TILEMAP & ALPHA STATE ---
color = c_white;
var tilemap = layer_tilemap_get_id("Tiles_1");
tilemap_get_at_pixel(tilemap, x, y);

if (inCombat){
    alpha = 0.7;
} else {
    alpha = 1;
}

glow = false;

// --- 6. ADDITIONAL GAMEPLAY ELEMENTS ---
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
    skull.visible = true;
} else {
    skull.visible = false;
}

if (inst != noone && inst != id)
{
    draw_text_colour(
        x, y - 180, "Im colliding",
        c_yellow, c_yellow, c_yellow, c_green, 1
    );
}

// Active / Combat checks
inCombat = false;
with(o_unit){
    if (point_distance(x, y, other.x, other.y) <= range and allegience != other.allegience){
        other.inCombat = true;
    }
}

if (inCombat){
    color = c_gray;
}

// HP Bar
var w = 30;
var h = 12;
var x1 = x - w * 0.5;
var y1 = y - 40;

var hp_ratio = hp / maxhp;
var totalLength = w + maxhp;

draw_set_color(c_gray);
draw_rectangle(x1, y1, x1 + totalLength, y1 + h, false);

draw_set_color(c_lime);
if (hp_ratio <= 0.5) {
    draw_set_color(c_yellow);
}
if (hp_ratio <= 0.2) {
    draw_set_color(c_red);
}

draw_rectangle(x1, y1, x1 + (hp_ratio * totalLength), y1 + h, false);
draw_set_color(c_white);

// HP Hover UI
if (position_meeting(mouse_x, mouse_y, id)){
    draw_set_font(Font3);
    draw_text_ext_colour(x, y + 40, string(hp), 0, 200, c_gray, c_dkgray, c_dkgray, c_black, 0.9);
}