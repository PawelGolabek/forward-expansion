// --- 1. DRAGGING LINE ---
if (global.draggingUnit == self and global.deployHighlight != noone){
    draw_line_width(x, y - drag_draw_offset, global.deployHighlight.x, global.deployHighlight.y, 10);
}

// --- 2. THREAT RADIUS & PERSISTENT CIRCLE ---
/*
draw_text(x,y+100,mouse_x)
draw_text(x+100,y+100,mouse_y)
draw_text(x,y+150,x)
draw_text(x,y+200,y)
*/

function draw_half_circle(cx, cy, radius, start_angle, end_angle)
{
    var segments = 32;
    draw_primitive_begin(pr_trianglefan);
    draw_vertex(cx, cy);
    for (var i = 0; i <= segments; i++)
    {
        var ang = lerp(start_angle, end_angle, i / segments);
        draw_vertex(
            cx + lengthdir_x(radius, ang),
            cy + lengthdir_y(radius, ang)
        );
    }
    draw_primitive_end();
}

function draw_half_circle_scale(cx, cy, radius, start_angle, end_angle, xscale, yscale)
{
    var segments = 32;
    draw_primitive_begin(pr_trianglefan);
    draw_vertex(cx, cy);
    for (var i = 0; i <= segments; i++)
    {
        var ang = lerp(start_angle, end_angle, i / segments);
        draw_vertex(
            cx + lengthdir_x(radius, ang) * xscale,
            cy + lengthdir_y(radius, ang) * yscale
        );
    }
    draw_primitive_end();
}

mous = (x - sprite_width/2 < mouse_x and x + sprite_width/2 > mouse_x and y - sprite_height < mouse_y and y > mouse_y);

// Default: child circle is allowed to die once it's invisible.
// Only cleared to false below while we still want it alive.
killImmortal = true;

var wantCircle = (mous or dragging or drawCircle);

// Resync our tracking flag in case the child already self-destructed.
if (immortalExists and not instance_exists(circleInst)) {
    immortalExists = false;
}

if (wantCircle) {
    if (not immortalExists) {
        circleInst = instance_create_layer(x, y, "units", o_expand_circle);
        circleInst.life = 1;
        circleInst.end_scale = (range / circleInst.sprite_width) * 2;
        circleInst.owner = self;
        circleInst.immortal = true;
        circleInst.timer = circleInst.life;
        immortalExists = true;
    }
    circleInst.x = x;
    circleInst.y = y;
    killImmortal = false;
    mousVisible = true;

    // Draw the threat-radius half circle whenever the persistent circle is active
    draw_set_alpha(0.15);
    draw_set_color(c_blue);
    draw_half_circle(x, y, range, 0, 180);              // bottom half
    draw_half_circle_scale(x, y, range, 180, 360, 1.0, 0.6); // top half (squashed)
    draw_set_alpha(1.0);
} else {
    mousVisible = false;
}

// --- 3. PERIODIC PULSE CIRCLES (self-destructing, unrelated to immortal one) ---
if (mousCooldown == 0){
    u = instance_create_layer(x, y, "units", o_expand_circle);
    u.life = random(150) + 150;
    u.end_scale = (range / u.sprite_width) * 2;
    u.owner = self;
    u.timer = 0;
    mousCooldown = mousMaxCooldown;
}
if (mousCooldown != 0){
    mousCooldown -= delta_time;
}
if (mousCooldown < 0){
    mousCooldown = 0;
}

// --- 4. TILEMAP & ALPHA STATE ---
color = c_white;
var tilemap = layer_tilemap_get_id("Tiles_1");
tilemap_get_at_pixel(tilemap, x, y);
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

// HP Hover UI
if (position_meeting(mouse_x, mouse_y, id)){
    draw_set_font(Font3);
    draw_text_ext_colour(x + sprite_width/2, y + sprite_height - drag_draw_offset + 40, string(hp), 0, 200, c_gray, c_dkgray, c_dkgray, c_black, 0.9);
}