event_inherited()
dragging = false;

name = "Master";
hp = 20;
maxhp = hp;
damage = 4;
allegience = "player";
range = 480;
description = "Deflects enemy first strikes";

// unique
parry = true;
parried = false;
firstStrike = false;




myUnitlet = o_master_let;
unit_collisions = mask_index
sprite_center_offset = (sprite_get_width(sprite_index) / 2.0)