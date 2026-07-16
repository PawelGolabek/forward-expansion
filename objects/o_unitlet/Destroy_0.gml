instance_create_depth(x,y,depth-20,o_blood_droplet)

	
if(not noEyes){
	instance_destroy(lPupil)
	instance_destroy(rPupil)
	instance_destroy(lEye)
	instance_destroy(rEye)
	instance_destroy(lEyeLid)
	instance_destroy(rEyeLid)
}
for (var i = array_length(o_draw_manager.ulets) - 1; i >= 0; i--) {
    if (o_draw_manager.ulets[i] == id) {
        array_delete(o_draw_manager.ulets, i, 1);
        break;
    }
}