event_inherited()

allegience = "enemy";
function initiate(){

	allegience = "enemy";
	name = "harpoon"
	mySprite = sprite_index;
	myUnitlet = o_enemy_archer_let;
	sprite_center_offset = (sprite_get_width(sprite_index) / 2) - sprite_get_xoffset(sprite_index);
	hp = 2
	maxhp = hp
	crystalCost = 60
	damage = 2
	antiAir = 1;
	baseDamage = damage
	allegience = "enemy"
	range = 220
	revealRange = range * 2
	dragging = false;
	mySprite = s_enemy_harpoon_flag;
	uletDeployMaxRange = 200;
	turnCounter = 0;
	maxTurnCounter = 3;
	turnCounterOn = false;
	hasTurnCounter = true;

	og_image_xscale = 2;
	og_image_yscale = 2;
	image_xscale = og_image_xscale;
	image_yscale = og_image_yscale;
	mySprite = sprite_index;

	sprite_center_offset = (sprite_get_width(sprite_index) / 2) - sprite_get_xoffset(sprite_index);
	myUnitlet = o_harpoon_let;

	createUnitlets()
}


function onAntiAir(){
	turnCounterOn = true;
	turnCounter = maxTurnCounter;
	instance_create_depth(x,y,depth,o_antimissle)

}

function triggerTurnCounter(){
	antiAir = 1;
	turnCounterOn = false;
	

}