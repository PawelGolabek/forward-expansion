event_inherited();
dragging = false;
name = "commander";
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
range = 200;
revealRange = range * 2;
aiType = "range";
mySprite = s_commander_flag;
myUnitlet = o_commander_let;
uletSize = s_observer_let;
specialFriendly = true;
aura = true;
sprite_center_offset = (sprite_get_width(sprite_index) / 2) - sprite_get_xoffset(sprite_index);
handleHeartsCreation(self);

damageBoostAbility = 3; // plain instance var — must persist past Create, so no `var`

function inflictAura(targetUnit){
	applyAura(targetUnit, self, damageBoostAbility, o_red_aura);
	if(targetUnit.dragging){
		mousVisible = true;
		applyingAura = true;
		blueGlow = true;
	}
}

/*
onEnter = function(){
	var myX = x;
	var myY = y;
	var myRange = range;
	var commanderObj = id;
	with(o_unit){
		if (id != commanderObj && point_distance_ellipse(x, y + drag_draw_offset, myX, myY + drag_draw_offset, 0.6) <= myRange and ){
			commanderObj.inflictAura(id);
		}
	}
}