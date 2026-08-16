event_inherited()

allegience = "enemy";
function initiate(){

	allegience = "enemy";
	name = "harpoon"
	mySprite = sprite_index;
	myUnitlet = o_enemy_heartbeat_let;
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
	mySprite = s_enemy_heartbeat_flag;
	uletDeployMaxRange = 200;
	turnCounter = 0;
	maxTurnCounter = 3;
	turnCounterOn = true;
	hasTurnCounter = true;
	hasShield = false;
	shieldActive = false;
	myShield = noone;
	abilityActive = true;
	og_image_xscale = 2;
	og_image_yscale = 2;
	image_xscale = og_image_xscale;
	image_yscale = og_image_yscale;
	mySprite = sprite_index;
	sprite_center_offset = (sprite_get_width(sprite_index) / 2) - sprite_get_xoffset(sprite_index);
	uletDeployMaxRange = 300;

	createUnitlets()
}



function triggerTurn(){
	if(abilityActive){
		if(shieldActive == false){
			myShield = instance_create_depth(x,y,depth - 40, o_pulse_shield);
			shieldActive = true;
			with(o_unit){
				if(point_distance_ellipse_sq(x,y,other.x,other.y,0.6) <= other.range * other.range and allegience == other.allegience){
					shieldActive = true;
				}
			}
		}else{
			instance_destroy(myShield);
			myShield = noone;
			shieldActive = false;
			with(o_unit){
				if(point_distance_ellipse_sq(x,y,other.x,other.y,0.6) <= other.range * other.range and allegience == other.allegience){
					shieldActive = false;
				}
			}
		}
	}
}
// possible race condition