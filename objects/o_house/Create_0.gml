event_inherited()

function initiate(){
dragging = false;

name = "Forward Expansion";
hp = 3
maxhp = hp
damage = 0
baseDamage = damage
allegience = "player"
range = 300
revealRange = range * 2

//peaceful = true;

myUnitlet = o_house_let;
unit_collisions = mask_index

og_image_xscale = 2;
og_image_yscale = 2;
image_xscale = og_image_xscale;
image_yscale = og_image_yscale;
mySprite = sprite_index;
noUnitlets = false;

unitletsPerHp = 0.5;

sprite_center_offset = (sprite_get_width(sprite_index) / 2) - sprite_get_xoffset(sprite_index);

	createUnitlets()
}
initiate()

handleHeartsCreation(self)