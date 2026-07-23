event_inherited()
dragging = false;

name = "inferna";
hp = 20
maxhp = hp
damage = 4
allegience = "player"
range = 350
revealRange = range * 2

myUnitlet = o_inferna_let;
unit_collisions = mask_index

og_image_xscale = 1;
og_image_yscale = 1;
image_xscale = og_image_xscale;
image_yscale = og_image_yscale;
mySprite = sprite_index;

sprite_center_offset = (sprite_get_width(sprite_index) / 2) - sprite_get_xoffset(sprite_index);