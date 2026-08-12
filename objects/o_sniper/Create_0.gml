event_inherited()

dragging = false;

name = "Firehawk"
hp = 2
maxhp = hp
damage = 3
baseDamage = damage
allegience = "player"
damageTaken = 0
firstStrike = true;
explosiveShots = true;
reverseTargetting = true;

og_image_xscale = 2;
og_image_yscale = 2;
image_xscale = og_image_xscale;
image_yscale = og_image_yscale;
range = 360
revealRange = range * 2
aiType = "range"


handleHeartsCreation(self)

function initiate(){
	mySprite = s_archer_flag_3
	myUnitlet = o_archer_let;
	uletSize = s_archer_let;
	sprite_center_offset = (sprite_get_width(sprite_index) / 2) - sprite_get_xoffset(sprite_index);
	createUnitlets()
}

initiate()