event_inherited()
dragging = false;

name = "tank";
hp = 5;
maxhp = hp;
damage = 1;
baseDamage = damage;
allegience = "player";
range = 400;
revealRange = range * 2;
noEyes = true;

mySprite = sprite_index;
myUnitlet = o_tank_let;
uletSize = Sprite67;

og_image_xscale = 2;
og_image_yscale = 2;
image_xscale = og_image_xscale;
image_yscale = og_image_yscale;
mySprite = sprite_index;

sprite_center_offset = (sprite_get_width(sprite_index) / 2) - sprite_get_xoffset(sprite_index);


handleHeartsCreation(self)
