// Inherit the parent event
event_inherited();


noEyes = true;
function initiate2(){
	
	image_xscale = 1;
	image_yscale = 1;	
sprite_center_offset = (sprite_get_width(sprite_index) / 2) - sprite_get_xoffset(sprite_index);
og_image_xscale = image_xscale
og_image_yscale = image_yscale
	
	/*
	shield = instance_create_depth(x-42 ,y,depth-10,o_shield);
	shield.y -= rPupil.sprite_height/2
	shield.originX = shield.x - x;
	shield.originY = shield.y - y;
	shield.image_xscale = image_xscale/16
	shield.image_yscale = image_yscale/16
	shield.owner = self;
	*/
	
}