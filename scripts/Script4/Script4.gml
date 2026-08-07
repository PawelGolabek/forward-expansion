function checkInCombat(){
	with(o_unit){
		inCombat = false;
	}

	with(o_unit){
		with(o_unit){
			if (point_distance_ellipse_sq(x, y - drag_draw_offset, other.x, other.y - other.drag_draw_offset, 0.6) <= range * range 
			and allegience != other.allegience and not other.peaceful){
				other.inCombat = true;
			}
		}
	}
}