event_inherited()

if(parried){

	katana.image_angle = 45
	dzida.image_angle = -45
}else{

	katana.image_angle = -45
	dzida.image_angle = 45
}

draw_text(x,y+40,parried);

katana.move();
dzida.move();