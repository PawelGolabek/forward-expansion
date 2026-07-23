global.deployHighlight = noone

trees = [];
with(o_trees){
	array_push(other.trees,self);
	visible = false;
}

with(o_unit){
	expectedDmg = 0;
	drawCircle = false;
	minDistToPlayer = 9999999
	visible = false;
	if(allegience != "player"){
		for (var i = 0; i < array_length(unitlets); i++){
			unitlets[i].visible = false;
		}	
	}
}


with(o_unit){
	if(allegience == "player"){
		visible = true;
	}
	// fog of war
	with(o_outlinable){
		otherU = other
		if(isUnit){
			if(allegience != "player" and other.allegience == "player"){
				distToPlayer = point_distance_ellipse(x, y - drag_draw_offset, otherU.x, otherU.y - otherU.drag_draw_offset, 0.6)
				if(distToPlayer < range + otherU.revealRange){
					fowVisible = true;
					visible = true;
					for (var i = 0; i < array_length(unitlets); i++){
						udistToPlayer = point_distance_ellipse(unitlets[i].x, unitlets[i].y, otherU.x, otherU.y - otherU.drag_draw_offset, 0.6)
						if(udistToPlayer < otherU.revealRange){
							unitlets[i].visible = true;
						}
					}
				}
			}
		}
		if(isTree and other.allegience == "player"){						
			udistToPlayer = point_distance_ellipse(x, y, otherU.x + (other.sprite_width/other.image_xscale)/2, otherU.y + (sprite_height/other.image_yscale) - otherU.drag_draw_offset, 0.6)
			if(udistToPlayer < other.revealRange){
				fowVisible = true;
				visible = true;
			}
		}
	}
	executeStep();
	if(inCombat){
		alpha = 0.7
	}
}
	// Active / Combat checks
with(o_unit){
	inCombat = false;
}
with(o_unit){
	draw_text(x,y,x)
	with(o_unit){
		if (point_distance_ellipse(x, y - drag_draw_offset, other.x, other.y - other.drag_draw_offset, 0.6) <= range 
		and allegience != other.allegience and not other.peaceful){
			other.inCombat = true;
		}
	}
}

array_sort(trees, function(a, b) {
    return a.depth - b.depth;
});
array_sort(ulets, function(a, b) {
    return a.depth - b.depth;
});
array_sort(units, function(a, b) {
    return a.depth - b.depth;
});

scr_draw_units_batch_trees(trees, 1);
scr_draw_units_batch(ulets, 1, 2); // 2px glow ring, 3px black ring behind it
scr_draw_units_batch(units, 1, 2); // 2px glow ring, 3px black ring behind it
