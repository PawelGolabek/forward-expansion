depth = owner.y - y/2 +  20;
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

redGlow = true;
array_push(o_draw_manager.ulets, id);