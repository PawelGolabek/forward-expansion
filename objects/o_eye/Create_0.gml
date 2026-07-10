function initiate(){
	// Create event
	blink_max_time = 100000   // 0.1s per phase -> ~0.2s full blink (close+open)
	blink_state = "default"
	blink_time = blink_max_time
	height = sprite_height
	base_yScale = image_yscale;
}

function moveEye(){
	x = originX + owner.x
	y = originY + owner.y
	depth = owner.depth - 2
	image_yscale = sin((blink_time / blink_max_time) * pi/2) * base_yScale;
	offset = height * (1- sin((blink_time / blink_max_time) * pi/2))/1.5;
	y += offset;
}

function blink(){
	blink_state = "blink"
	blink_time = blink_max_time
}
