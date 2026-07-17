depth = owner.y + y/1.2 - 20;

if(not noEyes){
	blink-=delta_time;
	if(blink <= 0){
		lEye.blink()
		rEye.blink()
		blink = maxBlink
	}
}


if (position_meeting(mouse_x, mouse_y, id))
{
	unit.signalFromUnitlet = true;
}

array_push(o_draw_manager.ulets, id);

	if (animationOn) {
	    breathe_timer += breathe_speed * (delta_time / 1000000) * 60;
	    image_xscale = og_image_xscale * (base_scale + sin(breathe_timer) * breathe_amount);
	    image_yscale = og_image_yscale * base_scale;

	    // "true" position is whatever x was before we started nudging it

	    breatheDrawXOffset = ((image_xscale - og_image_xscale) * sprite_center_offset);
		image_xscaleToSend = image_xscale;
	}