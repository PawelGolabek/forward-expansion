event_inherited()

function initiate(){


	name = "cavalry";
	hp = 2
	maxhp = hp
	crystalCost = 60
	damage = 10
	baseDamage = damage
	allegience = "player"
	damageTaken = 0
	reactionStrike = false;
	range = 220
	revealRange = range * 2
	dragging = false;
	mySprite = s_cavalry_flag_3;
	uletDeployMaxRange = 200;

	og_image_xscale = 2;
	og_image_yscale = 2;
	image_xscale = og_image_xscale;
	image_yscale = og_image_yscale;
	mySprite = sprite_index;

	sprite_center_offset = (sprite_get_width(sprite_index) / 2) - sprite_get_xoffset(sprite_index);
	myUnitlet = o_calvalry_let;

	createUnitlets()
}
initiate();

handleHeartsCreation(self)