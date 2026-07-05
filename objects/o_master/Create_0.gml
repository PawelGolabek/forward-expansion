event_inherited()
dragging = false;

name = "Master";
hp = 20;
maxhp = hp;
damage = 4;
allegience = "player";
range = 480;
description = "Deflects enemy first strikes";

// unique
parry = true;
parried = false;
firstStrike = false;


katana = instance_create_depth(x,y - 64,depth-10,o_katana_cosmetic);
katana.image_angle = -45
katana.originX = katana.x - x;
katana.originY = katana.y - y;
katana.owner = self;


dzida = instance_create_depth(x + sprite_width/2,y - 64,depth-10,o_dzida);
dzida.image_angle = 45
dzida.originX = dzida.x - x;
dzida.originY = dzida.y - y;
dzida.owner = self;