event_inherited();
function initiate(){
	dragging = false;
	name = "Observer";
	hp = 2;
	maxhp = hp;
	damage = 0;
	baseDamage = damage
	allegience = "player";
	damageTaken = 0;
	firstStrike = true;

	og_image_xscale = 2;
	og_image_yscale = 2;
	image_xscale = og_image_xscale;
	image_yscale = og_image_yscale;
	range = 240;
	revealRange = range * 2;
	aiType = "range";

	mySprite = s_observer_flag;
	myUnitlet = o_observer_let;
	uletSize = s_observer_let;
	specialFriendly = true;

	unitletsPerHp = 2;
	sprite_center_offset = (sprite_get_width(sprite_index) / 2) - sprite_get_xoffset(sprite_index);
	handleHeartsCreation(self);
	createUnitlets()
}
initiate();

onEnter = function(){
	with(o_unit){
		if(point_distance_ellipse_sq(x,y + drag_draw_offset,other.x,other.y + other.drag_draw_offset,0.6) <= other.range * other.range){
			performAttacks(false)	// true for retaliation
		}
	}
}