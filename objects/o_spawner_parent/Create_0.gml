event_inherited()
spawn_object = o_inferna;
active = false;
selected = false;
mousePressed = false;
deploymentsLeft = 0;

//card = instance_create_depth(100,100,depth+10,o_card)
//card.owner = self;

function setCrystalCost(){

	var inst = instance_create_depth(-10000, -10000, 0, spawn_object);
	crystalCost = inst.crystalCost;
	instance_destroy(inst);

}

function mouseEvent(){
	if(not selected){
		mousePressed = true;
	}
}


