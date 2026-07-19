// Inherit the parent event
event_inherited();

name = "crystal"
range = 10;
hp = 10;
maxHp = hp;
//firstStrike = false;
damage = 0;
//noEyes = true;
//allegience = "none";
//logDeath = false;
//logHit = false;
allegience = "enemy"
noUnitlets = true;

og_image_xscale = 2;
og_image_yscale = 2;
image_xscale = og_image_xscale;
image_yscale = og_image_yscale;


sprite_center_offset = (sprite_get_width(sprite_index) / 2) - sprite_get_xoffset(sprite_index);
mySprite = sprite_index;