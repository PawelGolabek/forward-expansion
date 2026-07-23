event_inherited()
dragging = false;
name = "worker";
hp = 3;
maxhp = hp;
damage = 7;
allegience = "player";
crystalCost = 0;
range = 800;
revealRange = range * 2
firstStrike = false;
reactionStrike = false;
myUnitlet = o_worker_let;
unit_collisions = mask_index;
sprite_center_offset = (sprite_get_width(sprite_index) / 2.0);



og_image_xscale = 0.25;
og_image_yscale = 0.25;
image_xscale = og_image_xscale;
image_yscale = og_image_yscale;
mySprite = sprite_index;

sprite_center_offset = (sprite_get_width(sprite_index) / 2) - sprite_get_xoffset(sprite_index);


