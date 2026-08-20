event_inherited()

function initiate(){
	dragging = false;
	name = "Rebels";
	hp = 2;
	maxhp = hp;
	damage = 0;
	baseDamage = damage;
	range = 300;
	uletDeployMaxRange = 150;
	revealRange = range * 2;
	noEyes = true;
	mySprite = sprite_index;
	myUnitlet = o_tank_let;
	uletSize = s_tank_let;
	og_image_xscale = 2;
	og_image_yscale = 2;
	image_xscale = og_image_xscale;
	image_yscale = og_image_yscale;
	unitletsPerHp = 2;
	crystalCost = 2;
	mySprite = sprite_index;
	sprite_center_offset = (sprite_get_width(sprite_index) / 2) - sprite_get_xoffset(sprite_index);
	deploymentsLeft = 3;
	createUnitlets();
}