function checkForAuras(unit){
	var myX = unit.x;
	var myY = unit.y;
	var myId = unit.id;
	with(o_unit){
		if(id == myId) continue; // don't let the placed unit buff itself
		if(aura){
			var dist = point_distance_ellipse(x, y - drag_draw_offset, myX, myY - myId.drag_draw_offset, 0.6);
			if(dist <= range and other.allegience == unit.allegience){
				inflictAura(other);
				o_combat_log.log(unit.name + " inflicts aura upon " + other.name);
			}
		}
	}
}

// aura related
function hasAuraFromSource(unit,_source){
	for(var i = 0; i < array_length(activeAuras); i++){
		if(activeAuras[i].source == _source){
			return true;
		}
	}
	return false;
}


function applyAura(unit,_source, _boost, _effectObj){
	if(_source == unit.id || hasAuraFromSource(unit,_source)){
		return false;
	}

	unit.damageBoost += _boost;
	unit.damage += _boost;

	var _effectInst = instance_create_depth(unit.x, unit.y + drag_draw_offset, unit.depth, _effectObj);
	_effectInst.owner = unit.id;

	array_push(activeAuras, { source: _source, boost: _boost, effect: _effectInst });
	return true;
}


// Optional but recommended: call this if an aura source dies/leaves so the
// buff and its visual effect are cleanly removed instead of lingering.
function removeAura(unit,_source){
	for(var i = 0; i < array_length(activeAuras); i++){
		if(activeAuras[i].source == _source){
			var _entry = activeAuras[i];
			damage -= _entry.boost;
			damageBoost -= _entry.boost;
			if(instance_exists(_entry.effect)){
				instance_destroy(_entry.effect);
			}
			array_delete(activeAuras, i, 1);
			return true;
		}
	}
	return false;
}

// Strips every aura currently applied to THIS unit (from any/all sources).
// Reverses each boost individually so `damage`/`damageBoost` stay correct,
// and destroys each aura's visual effect instance instead of leaking it.
function resetAuras(unit){
	for(var i = array_length(activeAuras) - 1; i >= 0; i--){
		var _entry = activeAuras[i];
		damage -= _entry.boost;
		damageBoost -= _entry.boost;
		if(instance_exists(_entry.effect)){
			instance_destroy(_entry.effect);
		}
	}
	activeAuras = [];
}

