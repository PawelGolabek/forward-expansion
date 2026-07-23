// Inherit the parent event
event_inherited();


function initiate2(){
	/*
	katana = instance_create_depth(x + sprite_width/2,y - 64,depth-10,o_katana_cosmetic);
	katana.x -= rPupil.sprite_width/2
	katana.y -= rPupil.sprite_height/2
	katana.originX = katana.x - x;
	katana.originY = katana.y - y;
	katana.owner = unit;
	sprite_center_offset = (sprite_get_width(sprite_index) / 2) - sprite_get_xoffset(sprite_index);
	
	*/
	noEyes = true;
	image_xscale = 1;
	image_yscale = 1;
	sprite_center_offset = (sprite_get_width(sprite_index) / 2);
	og_image_xscale = image_xscale
	og_image_yscale = image_yscale
image_index = random(image_number)

}