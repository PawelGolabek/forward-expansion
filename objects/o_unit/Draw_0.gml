// --- 3. DRAGGING LINE ---
if (global.draggingUnit == self and global.deployHighlight != noone){
    draw_line_width(x, y - drag_draw_offset, global.deployHighlight.x, global.deployHighlight.y, 10);
}

// --- 2. THREAT RADIUS & RANGE CIRCLES ---
/*
draw_text(x,y+100,mouse_x)
draw_text(x+100,y+100,mouse_y)
draw_text(x,y+150,x)
draw_text(x,y+200,y)
*/

if(dragging){
	mous = true;
	mousVisible = true;
	if(TheOne == noone){
		TheOne = instance_create_layer(x, y, "units", o_expand_circle);
		TheOne.life = 1
		TheOne.end_scale =( range / TheOne.sprite_width) * 2
		TheOne.owner = self;
		TheOne.immortal = true;
		TheOne.timer = TheOne.life;
		immortalExists = true;
		}
		TheOne.x = x;
		TheOne.y = y;
		
}
if (drawCircle or global.deployHighlight == id  or mous
){
    // Draw threat radius
  //  var circleColor = c_blue; 
  //  draw_set_alpha(0.5); 
 //   draw_circle_color(x, y + drag_draw_offset, range, circleColor, circleColor, true);
    
   // draw_set_alpha(0.15); // Filled center
  //  draw_circle_color(x , y + drag_draw_offset, range, circleColor, circleColor, false);
    
    draw_set_alpha(1.0); // Reset alpha
	if(not immortalExists){
		u = instance_create_layer(x, y, "units", o_expand_circle);
		u.life = 1
		u.end_scale =( range / u.sprite_width) * 2
		u.owner = self;
		u.immortal = true;
		u.timer = u.life;
		immortalExists = true;
	}
	mousVisible = true;
}else{
	mousVisible = false
	immortalExists = false;
}

if(mousCooldown == 0){
	u = instance_create_layer(x, y, "units", o_expand_circle);
	u.life = random(150)+150
	u.end_scale =( range / u.sprite_width) * 2
	u.owner = self;
	mousCooldown = mousMaxCooldown;
}
if(mousCooldown != 0){
	mousCooldown -= delta_time
}
if(mousCooldown < 0){
	mousCooldown = 0;
}



// --- 4. TILEMAP & ALPHA STATE ---
color = c_white;
var tilemap = layer_tilemap_get_id("Tiles_1");
tilemap_get_at_pixel(tilemap, x, y);

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
   // skull.visible = true;
} else {
    skull.visible = false;
}

if (inst != noone && inst != id)
{
    draw_text_colour(
        x + sprite_width/2, y + sprite_height - drag_draw_offset - 180, "Im colliding",
        c_yellow, c_yellow, c_yellow, c_green, 1
    );
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
    draw_text_ext_colour(x + sprite_width/2, y + sprite_height - drag_draw_offset + 40, string(hp), 0, 200, c_gray, c_dkgray, c_dkgray, c_black, 0.9);
}