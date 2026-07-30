event_inherited()
dragging = false;

name = "inferna";
hp = 1
maxhp = hp
damage = 1
allegience = "player"
range = 350
revealRange = range * 2

myUnitlet = o_inferna_let;
unit_collisions = mask_index


og_image_xscale = 2;
og_image_yscale = 2;
image_xscale = og_image_xscale;
image_yscale = og_image_yscale;
mySprite = sprite_index;

sprite_center_offset = (sprite_get_width(sprite_index) / 2) - sprite_get_xoffset(sprite_index);

handleHeartsCreation(self)