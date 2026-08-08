event_inherited()
dragging = false;

name = "Explosive Drone";
hp = 1
maxhp = hp
damage = 5;
baseDamage = damage
allegience = "player"
range = 250
revealRange = range * 2

myUnitlet = o_explosive_drone_let;
unitletsPerHp = 20
unit_collisions = mask_index
flying = true;
destroyOnAttack = true;
explosionOnDeath = true;

og_image_xscale = 2;
og_image_yscale = 2;
image_xscale = og_image_xscale;
image_yscale = og_image_yscale;
mySprite = sprite_index;

sprite_center_offset = (sprite_get_width(sprite_index) / 2) - sprite_get_xoffset(sprite_index);

handleHeartsCreation(self)