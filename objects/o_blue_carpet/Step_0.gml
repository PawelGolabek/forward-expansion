
if(initiated){
	recallTime -= delta_time
	image_xscale = startingXScale * recallTime/recallTimeStart
	image_yscale = startingYScale * recallTime/recallTimeStart
	unit.recallTime -= delta_time
	unit.og_image_xscale = unit.og_image_xscale * recallTime/recallTimeStart
	unit.og_image_yscale = unit.og_image_yscale * recallTime/recallTimeStart
	
	heightDelta = lastHeight - sprite_height;
	lastHeight = sprite_height;
	y += heightDelta;
	
	if(recallTime < 0){
		instance_destroy(unit)
		instance_destroy()
	}
}