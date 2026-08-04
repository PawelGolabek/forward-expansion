event_inherited();
dragging = false;
name = "archer";
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
uletSize = s_new_unit;
specialFriendly = true;

sprite_center_offset = (sprite_get_width(sprite_index) / 2) - sprite_get_xoffset(sprite_index);

handleHeartsCreation(self);

onEnter = function(){
	with(o_unit){
		if(point_distance_ellipse(x,y + drag_draw_offset,other.x,other.y + other.drag_draw_offset,0.6) <= other.range){
			o_combat_resolver.resolve_first_strike_without_retaliation(self);
		}
	}


}