// Inherit the parent event
event_inherited();

sprite_center_offset = (sprite_get_width(sprite_index) / 2) - sprite_get_xoffset(sprite_index);
/*
katana = instance_create_depth(x,y - 64,depth-10,o_katana_cosmetic);
katana.image_angle = -45
katana.originX = katana.x - x;
katana.originY = katana.y - y;
katana.owner = self;
*/
/*
dzida = instance_create_depth(x + sprite_width/2,y - 64,depth-10,o_dzida);
dzida.image_angle = 45
dzida.originX = dzida.x - x;
dzida.originY = dzida.y - y;
dzida.owner = self;
*/

image_index = random(image_number)