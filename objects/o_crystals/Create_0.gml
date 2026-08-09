// Inherit the parent event
event_inherited();

function initiate(){
	name = "crystal"
	range = 10;
	hp = 1;
	maxhp = hp;
	//firstStrike = false;
	damage = 0;
	baseDamage = damage
	//noEyes = true;
	//allegience = "none";
	//logDeath = false;
	//logHit = false;
	allegience = "enemy"
	noUnitlets = true;
	damageTaken = 0


	og_image_xscale = 1;
	og_image_yscale = 1;
	image_xscale = og_image_xscale;
	image_yscale = og_image_yscale;

	mySprite = sprite_index;

	sprite_center_offset = (sprite_get_width(sprite_index) / 2) - sprite_get_xoffset(sprite_index);
	createUnitlets()

}
initiate()

handleHeartsCreation(self)
