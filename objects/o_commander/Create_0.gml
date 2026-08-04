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
uletSize = s_new_unit;
specialFriendly = true;
aura = true;

sprite_center_offset = (sprite_get_width(sprite_index) / 2) - sprite_get_xoffset(sprite_index);
handleHeartsCreation(self);

var damageBoostAbility = 3;

inflictAura = function(targetUnit){
    targetUnit.damageBoost += 3;
    targetUnit.damage += targetUnit.damageBoost; // Explicitly reference targetUnit's boost
    
    // Use auraEffect to prevent overwriting targetUnit.aura (which is a boolean!)
    targetUnit.auraEffect = instance_create_depth(targetUnit.x, targetUnit.y, targetUnit.depth, o_red_aura);
    targetUnit.auraEffect.owner = targetUnit;
}

onEnter = function(){
    var myX = x;
    var myY = y;
    var myRange = range;
    var commanderObj = id;

    with(o_unit){
        if (id != commanderObj && point_distance_ellipse(x, y, myX, myY, 0.6) <= myRange){
            commanderObj.inflictAura(id);
        }
    }
}