// Inherit the parent event
event_inherited();

name = "crystal"
range = 0;
hp = 6;
maxHp = hp;
firstStrike = false;
damage = 0;
noEyes = true;
allegience = "none";
logDeath = false;
logHit = false;

noUnitlets = true;

unit_collisions = mask_index
		sprite_center_offset = (sprite_get_width(sprite_index) / 2) - sprite_get_xoffset(sprite_index);