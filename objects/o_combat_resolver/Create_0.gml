global.draggingUnit = noone



function resolve_combat(){
	with(o_unit){
		if(target != noone){
			target.damageTaken += self.damage;	
		}
	}
	
	with(o_unit){
		hp -= damageTaken;
		damageTaken = 0
		if(hp <= 0){
			instance_destroy(arrow);			
			instance_destroy();
		}
	}
}