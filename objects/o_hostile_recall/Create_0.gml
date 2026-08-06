event_inherited()

dragging = false;
name = "recall"
hp = 2
maxhp = hp
damage = 1
baseDamage = damage
allegience = "player"
damageTaken = 0
firstStrike = true;

og_image_xscale = 2;
og_image_yscale = 2;
image_xscale = og_image_xscale;
image_yscale = og_image_yscale;
range = 180
revealRange = range * 2
aiType = "range"
mySprite = s_recall_flag
noUnitlets = true;
specialFriendly = true;

sprite_center_offset = (sprite_get_width(sprite_index) / 2) - sprite_get_xoffset(sprite_index);

handleHeartsCreation(self)
aura = true;
recall = 3;

inflictAura = function(targetUnit){
	applyAura(targetUnit, id, recall, o_blue_carpet);
	recalling = true;
	mousVisible = true;
	applyingAura = true;
}

function onEnter(){
	var me = id;
	var myRange = range;
	var myY = y;
	var myX = x;
	with(o_unit){
		if (id != me && point_distance_ellipse(x, y + drag_draw_offset, myX, myY + me.drag_draw_offset, 0.6) <= myRange){
			if(not noUnitlets){
				scr_recall(id,600000)
				maxUnitlets = array_length(unitlets);
				for(i = 0; i < maxUnitlets; i += 1){					
					me.inflictAura(unitlets[i]);
				}
			}
		}
	}
	toDestroy = true;
}

function onPlace(){
	show_debug_message("a")
}