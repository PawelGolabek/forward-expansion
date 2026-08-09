event_inherited()

function initiate(){
	dragging = false;

	name = "slime";
	hp = 2
	maxhp = hp
	damage = 12
	baseDamage = damage
	allegience = "player"
	range = 210
	revealRange = range * 2

	myUnitlet = o_slime_let;
	unit_collisions = mask_index

	og_image_xscale = 2;
	og_image_yscale = 2;
	image_xscale = og_image_xscale;
	image_yscale = og_image_yscale;
	mySprite = sprite_index;

	sprite_center_offset = (sprite_get_width(sprite_index) / 2) - sprite_get_xoffset(sprite_index);
	createUnitlets()
}
initiate();
handleHeartsCreation(self)