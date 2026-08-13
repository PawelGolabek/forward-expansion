if(image_xscale < 10){
	image_xscale += delta_time * 1000000;
	image_yscale += delta_time * 1000000;
}
if(image_xscale > 10){
	image_xscale = 10;
	image_yscale = 10;
}

x = og_x - sprite_width/2;
y = og_y - sprite_height/2;