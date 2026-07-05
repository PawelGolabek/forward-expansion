
spawn_object = o_inferna;
active = false;

function setCrystalCost(){

	var inst = instance_create_depth(-10000, -10000, 0, spawn_object);
	crystalCost = inst.crystalCost;
	instance_destroy(inst);

}