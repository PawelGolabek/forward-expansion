// Inherit the parent event
event_inherited();


if(unit.parried){

	katana.image_angle = 45
	dzida.image_angle = -45
}else{

	katana.image_angle = -45
	dzida.image_angle = 45
}

draw_text(x,y+40,unit.parried);

katana.move();
dzida.move();