event_inherited()

function initiate(){
	dragging = false;

	name = "Katana";
	hp = 1
	maxhp = hp
	damage = 4
	baseDamage = damage
	range = 180
	revealRange = range * 2


	myUnitlet = o_katana_let;
	unit_collisions = mask_index
	mySprite = sprite_index;

	sprite_center_offset = (sprite_get_width(sprite_index) / 2.0)

	og_image_xscale = 2;
	og_image_yscale = 2;
	createUnitlets()
}