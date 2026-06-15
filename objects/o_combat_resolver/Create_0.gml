function resolve_combat(){
	with(o_unit_parent){
		var target
		if(allegience == "player"){
			target = instance_nearest(x, y, o_enemy_unit_parent);
			target.damageTaken += self.damage;
		}else{
			target = instance_nearest(x, y, o_inferna);
			target.damageTaken += self.damage;		
		}
	}
	
	with(o_unit_parent){
		hp -= damageTaken;
		damageTaken = 0
		if(hp <= 0){
			instance_destroy();
		}
	}
}