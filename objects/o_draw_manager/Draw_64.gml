relics = [];

with(o_relic){
	array_push(other.relics,self);
}

scr_draw_units_batch_trees(relics, 1);