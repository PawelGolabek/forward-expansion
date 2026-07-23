
event_inherited()

dragging = false;

name = "archer"
hp = 5
maxhp = hp
damage = 2
allegience = "player"
damageTaken = 0

firstStrike = false;

og_image_xscale = 1;
og_image_yscale = 1;
image_xscale = og_image_xscale;
image_yscale = og_image_yscale;
range = 160
revealRange = range * 2

aiType = "range"

mySprite = s_archer_flag_3
myUnitlet = o_archer_let;
uletSize = s_new_unit;


sprite_center_offset = (sprite_get_width(sprite_index) / 2) - sprite_get_xoffset(sprite_index);