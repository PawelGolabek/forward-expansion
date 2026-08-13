
event_inherited()

function initiate(){
	dragging = false;

	name = "ram";
	hp = 4
	maxhp = hp
	damage = 80
	baseDamage = damage
	damageTaken = 0
	mySprite = sprite_index;


	range = 20
	revealRange = range * 2
	unit_collisions = mask_index
	sprite_center_offset = (sprite_get_width(sprite_index) / 2.0)
	createUnitlets()
}