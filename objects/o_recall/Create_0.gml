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
recall = 3;

function onEnter(){
	var me = id;
	var myRange = range;
	var myY = y;
	var myX = x;
	with(o_unit){
		if (id != me && point_distance_ellipse_sq(x, y + drag_draw_offset, myX, myY + me.drag_draw_offset, 0.6) <= myRange * myRange and allegience = "player"){
			if(not noUnitlets){
				scr_recall(id,600000)
				maxUnitlets = array_length(unitlets);
			}
		}
	}
	toDestroy = true;
}

function onPlace(){
}