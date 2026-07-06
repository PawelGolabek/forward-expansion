if (keyboard_check_pressed(vk_f10))
{
    visible = !visible;
	if(not visible){
		mask_index = -1;
	}else{
		mask_index = og_sprite;
	}
}