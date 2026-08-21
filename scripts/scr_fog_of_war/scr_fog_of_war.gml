function fogOfWarCheck(){
	
	with(o_unit){
		visible = false;						
		uletsNum = array_length(unitlets)
		for (i = 0; i < uletsNum; i++){
			unitlets[i].visible = false;
		}
		if(allegiance == "player"){
			visible = true;
			uletsNumber = array_length(unitlets);
			for(i = 0; i < uletsNumber; i += 1){
				unitlets[i].visible = true;
			}
		}
	}	
	with(o_unit){
		// fog of war
		with(o_outlinable){
			otherU = other
			if(isUnit){
				if(allegiance != "player" and other.allegiance == "player"){
					distToPlayer = point_distance_ellipse(x, y - drag_draw_offset, otherU.x, otherU.y - otherU.drag_draw_offset, 0.6)
					if(distToPlayer < range + otherU.revealRange){
						fowVisible = true;
						visible = true;
						uletsNum = array_length(unitlets)
						for (i = 0; i < uletsNum; i++){
							udistToPlayer2 = point_distance_ellipse_sq(unitlets[i].x, unitlets[i].y, otherU.x, otherU.y - otherU.drag_draw_offset, 0.6)
							if(udistToPlayer2 < otherU.revealRange * otherU.revealRange){
								unitlets[i].visible = true;
							}
						}
					}
				}
			}
			if(isTree and other.allegiance == "player"){						
				udistToPlayer = point_distance_ellipse(x, y, otherU.x + (other.sprite_width/other.image_xscale)/2, 
					otherU.y + (sprite_height/other.image_yscale) - otherU.drag_draw_offset, 0.6)
				if(udistToPlayer < other.revealRange){
					fowVisible = true;
					visible = true;
				}
			}
		}
	
		if (not o_fog_of_war.active){
			with(o_object){
				visible = true;
				if(isUnit){
					uletsNum = array_length(unitlets);
					for (i = 0; i < uletsNum; ++i) {
						unitlets[i].visible = true;
					}
				}
			}
		}
	}
}