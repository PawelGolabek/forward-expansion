event_inherited()
dragging = false;

name = "inferna";
hp = 20
maxhp = hp
damage = 4
allegience = "player"

range = 300


dzida = instance_create_depth(x + sprite_width/2,y - 64,depth-10,o_dzida);
dzida.x -= rPupil.sprite_width/2
dzida.y -= rPupil.sprite_height/2
dzida.originX = dzida.x - x;
dzida.originY = dzida.y - y;
dzida.owner = self;