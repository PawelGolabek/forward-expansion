event_inherited()


function initiate(){

	dragging = false;

	name = "artillery"
	hp = 1
	maxhp = hp
	damage = 1
	baseDamage = damage
	damageTaken = 0

	firstStrike = true;
	reactionStrike = false;
	deployAlly = false;

	og_image_xscale = 2;
	og_image_yscale = 2;
	image_xscale = og_image_xscale;
	image_yscale = og_image_yscale;
	range = 1200;
	revealRange = range * 2;
	uletDeployMaxRange = 100;
	aiType = "range";
	unitletsPerHp = 2;
	mySprite = s_artillery_flag
	myUnitlet = o_artillery_let;
	uletSize = s_artillery_let;
	crystalCost = 2;

	sprite_center_offset = (sprite_get_width(sprite_index) / 2) - sprite_get_xoffset(sprite_index);
	createUnitlets()
}