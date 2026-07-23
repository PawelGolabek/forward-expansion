
event_inherited()

function initiate2(){
	pickaxe = instance_create_depth(x + sprite_width/2,y - 64,depth-10,o_pickaxe);
	pickaxe.x -= rPupil.sprite_width/2
	pickaxe.y -= rPupil.sprite_height/2
	pickaxe.originX = pickaxe.x - x;
	pickaxe.originY = pickaxe.y - y;
	pickaxe.owner = unit;
	
image_xscale = 0.125;
image_yscale = 0.125;
sprite_center_offset = (sprite_get_width(sprite_index) / 2);

og_image_xscale = image_xscale
og_image_yscale = image_yscale


}
