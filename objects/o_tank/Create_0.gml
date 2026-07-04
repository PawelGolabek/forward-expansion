event_inherited()
dragging = false;

name = "tank";
hp = 50
maxhp = hp
damage = 1
allegience = "player"
range = 500

shield = instance_create_depth(x-42 ,y,depth-10,o_shield);
shield.y -= rPupil.sprite_height/2
shield.originX = shield.x - x;
shield.originY = shield.y - y;
shield.owner = self;