event_inherited()
dragging = false;
name = "recall";
hp = 0;
maxhp = hp;
damage = 0;
baseDamage = damage;
damageTaken = 0;
firstStrike = true;
og_image_xscale = 2;
og_image_yscale = 2;
image_xscale = og_image_xscale;
image_yscale = og_image_yscale;
range = 220;
revealRange = range;
aiType = "range";
mySprite = s_recall_flag;
noUnitlets = true;
highlightEnemy = true;
deployedAnywhere = true;
noTargetting = true;
untargetable = true;
isAirStrike = true;
sprite_center_offset = (sprite_get_width(sprite_index) / 2) - sprite_get_xoffset(sprite_index);

function onEnter(){
	instance_create_depth(room_width,y,-999999,o_plane_shadow)
    var me = id;
    var myRange = range;
    var myY = y;
    var myX = x;
    var unitsAffected = [];
    var uletsDestroyed = [];
    // Reset damaged counters on all units
    with(o_unit){
        damagedUlets = 0;
    }
    // Check all unitlets within the elliptical range
    with(o_unitlet){
        if (owner.id != me && point_distance_ellipse_sq(x, y, myX, myY, 0.6) <= myRange * myRange){
			targettedBySpell = true;
            toDestroy = true;
            array_push(uletsDestroyed, id);
            if (owner.damagedUlets == 0) {
                array_push(unitsAffected, owner);
            }
            owner.damagedUlets += 1;
        }
    }
	ttl = 1000000;
    // 1. Destroy marked unitlets
    var totalUlets = array_length(uletsDestroyed);
    for (var i = 0; i < totalUlets; i++) {
		uletsDestroyed[i].markForDeath = true;
		uletsDestroyed[i].ttl = ttl
    }

    // 2. Apply scaled HP damage to affected units
    var totalUnits = array_length(unitsAffected);
    for (var i = 0; i < totalUnits; i++) {
        var currentUnit = unitsAffected[i];
        currentUnit.realHpDmg = floor(currentUnit.damagedUlets / currentUnit.unitletsPerHp);
		currentUnit.realHpTriggerTime = ttl;
		currentUnit.realHpTriggerOn = true;
    }
	repeat(1){
		spread = 0;
		a = instance_create_depth(x - spread + random(spread*2),y - (spread * 0.6) + random(spread * 2 * 0.6), 0, o_delayed_explosion);
		a.image_xscale = 10
		a.image_yscale = 10
		a.image_index = 0;
	}
	instance_destroy();
}

function onIntercepted(){
	instance_create_depth(room_width,y,-999999,o_plane_shadow)	
}

// this might be standardized as a class airstrike or sth i think, should be the same for all like 5 strikes in final game
function onDragging(){
    var me = id;
    var myRange = range;
    var myY = y;
    var myX = x;
    with(o_unitlet){
        if (owner.id != me && point_distance_ellipse_sq(x, y, myX, myY, 0.6) <= myRange * myRange){
			targettedBySpell = true;
		}
	}
	with(o_unit){
		if(antiAir and point_distance_ellipse_sq(x, y, myX, myY, 0.6) <= myRange * myRange){
			greenGlow = true;
			wantCircle = true;		
		}
	}
}




function onPlace(){}