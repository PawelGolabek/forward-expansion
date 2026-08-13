function checkForAuras(unit){
	if(instance_exists(unit)){
		var myX = unit.x;
		var myY = unit.y;
		var myId = unit.id;

		// first, drop auras from sources that are gone or now out of range
		for(i = array_length(unit.activeAuras) - 1; i >= 0; i--){
			var _source = unit.activeAuras[i].source;
			var _stillValid = false;
			if(instance_exists(_source) && _source.aura && _source.allegience == unit.allegience){
				var _dist2 = point_distance_ellipse_sq(_source.x, _source.y - _source.drag_draw_offset, myX, myY - myId.drag_draw_offset, 0.6);
				if(_dist2 <= _source.range * _source.range){
					_stillValid = true;
				}
			}
			if(!_stillValid){
				removeAura(unit, _source);
			}
		}

		with(o_unit){
			if(id == myId) continue; // don't let the placed unit buff itself
			if(aura){
				var dist2 = point_distance_ellipse_sq(x, y - drag_draw_offset, myX, myY - myId.drag_draw_offset, 0.6);
				if(dist2 <= range * range and allegience == unit.allegience){
					inflictAura(other);
				//	o_combat_log.log(unit.name + " inflicts aura upon " + other.name);
				}
			}
		}
	}
}
// aura related
function hasAuraFromSource(unit,_source){
	for(i = 0; i < array_length(unit.activeAuras); i++){
		if(unit.activeAuras[i].source == _source){
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
	var _effectInst = instance_create_depth(unit.x, unit.y + unit.drag_draw_offset, unit.depth, _effectObj);
	_effectInst.owner = unit.id;
	_effectInst.initiated = true;
	array_push(unit.activeAuras, { source: _source, boost: _boost, effect: _effectInst });
	return true;
}

function removeAura(unit,_source){
	for(i = 0; i < array_length(unit.activeAuras); i++){
		if(unit.activeAuras[i].source == _source){
			var _entry = unit.activeAuras[i];
			unit.damage -= _entry.boost;
			unit.damageBoost -= _entry.boost;
			if(instance_exists(_entry.effect)){
				instance_destroy(_entry.effect);
			}
			array_delete(unit.activeAuras, i, 1);
			return true;
		}
	}
	return false;
}

function resetAuras(unit){
	for(i = array_length(unit.activeAuras) - 1; i >= 0; i--){
		var _entry = unit.activeAuras[i];
		unit.damage -= _entry.boost;
		unit.damageBoost -= _entry.boost;
		if(instance_exists(_entry.effect)){
			instance_destroy(_entry.effect);
		}
	}
	unit.activeAuras = [];
}