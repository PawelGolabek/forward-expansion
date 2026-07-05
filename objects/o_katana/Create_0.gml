event_inherited()
dragging = false;

name = "katana";
hp = 17
maxhp = hp
damage = 4
allegience = "player"

range = 380


katana = instance_create_depth(x + sprite_width/2,y - 64,depth-10,o_katana_cosmetic);
katana.x -= rPupil.sprite_width/2
katana.y -= rPupil.sprite_height/2
katana.originX = katana.x - x;
katana.originY = katana.y - y;
katana.owner = self;