relics = [];

with(o_relic){
	array_push(other.relics,self);
}




array_push(relics,o_energy);



scr_draw_units_batch_trees(relics, 1);