life = 30;
timer = 0;

start_scale = 0.1;	// it got 10x scaled for better circle
end_scale = 0.3;

start_x = x;
start_y = y;
angleShift = random(720) + 360

immortal = false;
owner = noone;

function draw(){
    draw_sprite_ext(
        sprite_index, 
        image_index, 
        x, 
        y, 
        image_xscale, 
        image_yscale, 
        image_angle, 
        image_blend, 
        image_alpha
    );

}