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

function executeStep(){

	if(owner != noone){
		visible = owner.wantCircle or owner.mousVisible
	}

	var t = clamp(timer / life, 0, 1);
	var e = sin(t * pi * 0.5);
	var scale = lerp(start_scale, end_scale, e);
	image_xscale = scale;
	image_yscale = scale*3/5;
	image_alpha = clamp(0.5 - t*0.5, 0.01, 1);
	image_angle = ((life % 4) * angleShift ) % 4

	x = owner.x
	y = owner.y //+ owner.drag_draw_offset


	if(not immortal){
		timer++;
	}else{
		image_alpha = 1.0;
		visible = true;
	}


	if (t >= 1 and not immortal)
	    instance_destroy();


	if(immortal and not visible and owner.killImmortal){
		owner.immortalExists = false;
	    instance_destroy();
	}
}