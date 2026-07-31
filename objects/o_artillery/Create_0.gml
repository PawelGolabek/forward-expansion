event_inherited()

dragging = false;

name = "archer"
hp = 2
maxhp = hp
damage = 1
allegience = "player"
damageTaken = 0

firstStrike = true;
reactionStrike = false;
deployAlly = false;

og_image_xscale = 2;
og_image_yscale = 2;
image_xscale = og_image_xscale;
image_yscale = og_image_yscale;
range = 1200;
revealRange = range * 2;

aiType = "range";
unitletsPerHp = 1;


mySprite = s_artillery_flag
myUnitlet = o_artillery_let;
uletSize = s_new_unit;

sprite_center_offset = (sprite_get_width(sprite_index) / 2) - sprite_get_xoffset(sprite_index);

handleHeartsCreation(self)