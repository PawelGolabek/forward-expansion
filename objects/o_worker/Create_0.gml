event_inherited()
dragging = false;

hp = 3
maxhp = hp
damage = 10
allegience = "player"

range = 500

firstStrike = false;
reactionStrike = false;


pickaxe = instance_create_depth(x + sprite_width/2,y - 64,depth-10,o_pickaxe);
pickaxe.x -= rPupil.sprite_width/2
pickaxe.y -= rPupil.sprite_height/2
pickaxe.originX = pickaxe.x - x;
pickaxe.originY = pickaxe.y - y;
pickaxe.owner = self;