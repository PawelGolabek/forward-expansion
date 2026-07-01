function ai_evaluate_and_place() {

    // --- read stats directly from the actual objects ---
    var _types = [o_enemy_archer, o_enemy_inferna, o_enemy_cavalry];
    var unit_types = [];
    
    for (var i = 0; i < array_length(_types); i++) {
        var _tmp = instance_create_layer(-9999, -9999, "units", _types[i]);
        array_push(unit_types, {
            obj:           _types[i],
            range:         _tmp.range,
            damage:        _tmp.damage,
            hp:            _tmp.hp,
            fragility:     (1 / _tmp.hp) * (1 / max(_tmp.range, 1)),
            is_aggressive: _tmp.range < 80  // melee/short range = aggressive hunter
        });
        instance_destroy(_tmp);
    }

    // --- board bounds ---
    var bx1  = 0;
    var by1  = 0;
    var bx2  = room_width;
    var by2  = room_height;
    var step = 120;

    // --- precompute fragile own unit (to screen) ---
    var fragile_own_x   = -1;
    var fragile_own_y   = -1;
    var _lowest_own_hp  = 999999;
    with (o_unit) {
        var _is_ai = (allegience == "enemy" || allegience != "player");
        if (_is_ai && hp < _lowest_own_hp) {
            _lowest_own_hp = hp;
            fragile_own_x  = x;
            fragile_own_y  = y;
        }
    }

    // --- precompute most fragile enemy (to hunt) ---
    var fragile_enemy_x   = -1;
    var fragile_enemy_y   = -1;
    var _lowest_enemy_hp  = 999999;
    with (o_unit) {
        if (allegience == "player" && hp < _lowest_enemy_hp) {
            _lowest_enemy_hp = hp;
            fragile_enemy_x  = x;
            fragile_enemy_y  = y;
        }
    }

    // --- main scan ---
    var best_score1 = -999999;
    var best_x     = -1;
    var best_y     = -1;
    var best_type  = -1;

    for (var cx = bx1; cx < bx2; cx += step) {
        for (var cy = by1; cy < by2; cy += step) {

            if (position_meeting(cx, cy, o_unit))       continue;
            if (position_meeting(cx, cy, o_impassable)) continue;


			
            // closest enemy unit to this cell (for screening term)
            var closest_enemy_x    = -1;
            var closest_enemy_y    = -1;
            var closest_enemy_dist = 999999;
			var _deployable = false;
            with (o_unit) {
				if(allegience == "enemy"){
					if(point_distance(cx, cy, x, y) < range){
						_deployable = true;
					}		
				}
                if (allegience == "player") {
                    var _d = point_distance(cx, cy, x, y);
                    if (_d < closest_enemy_dist) {
                        closest_enemy_dist = _d;
                        closest_enemy_x    = x;
                        closest_enemy_y    = y;
                    }
                }
            }
			if(!_deployable){
				continue;
			}

            for (var t = 0; t < array_length(unit_types); t++) {
                var u     = unit_types[t];
                var score1 = 0;
				
				closestEnemy = noone;
				var minDist = 9999999

                with (o_unit) {
                    var _d    = point_distance(cx, cy, x, y);
                    var _is_ai = (allegience == "enemy" || allegience != "player");

                    if (!_is_ai) {
                        // + proximity to player units/nodes
                        score1 += 10 / (1 + _d / 100);
						
						if(minDist > _d){
							minDist = _d;
							closestEnemy = self;
						}
                        // - danger: player units whose range covers this cell
                        if (_d <= range) {
                            score1 -= u.fragility * 5;
                        }

                        // + player units we can hit from here
                        if (_d <= u.range) {
                            score1 += 2;
                        }
                    } else {
                        // + wall synergy: friendly units in range
                        if (_d <= u.range) {
                            score1 += 3;
                        }
                    }
                }

                // + SCREENING: bonus for sitting between closest enemy and own fragile unit
                if (fragile_own_x != -1 && closest_enemy_x != -1) {
                    var _dte       = point_distance(cx, cy, closest_enemy_x, closest_enemy_y);
                    var _dtf       = point_distance(cx, cy, fragile_own_x, fragile_own_y);
                    var _etf       = point_distance(closest_enemy_x, closest_enemy_y, fragile_own_x, fragile_own_y);
                    var _intercept = _etf - (_dte + _dtf);
                    var _finv      = 1 - u.fragility;
                    score1 += (1 / (1 + abs(_intercept) / 50)) * _finv * 6;
                }

                // + HUNTING: aggressive units chase fragile enemies
                if (u.is_aggressive && fragile_enemy_x != -1) {
                    var _dfe = point_distance(cx, cy, fragile_enemy_x, fragile_enemy_y);
					if(range > minDist){
						score1 += u.damage  * 5;
					}
                }

                if (score1 > best_score1) {
                    best_score1 = score1;
                    best_x     = cx;
                    best_y     = cy;
                    best_type  = t;
                }
            }
        }
    }
	var _spawned = noone
    // --- spawn winner ---
    if (best_type != -1 && best_x != -1) {
        _spawned        = instance_create_layer(best_x, best_y, "units", unit_types[best_type].obj);
        _spawned.placed     = true;
        _spawned.allegience = "enemy";
        
        var _destroyed = false;
        
        // Execute collision and validation logic inside the newly spawned unit's context
        with (_spawned) {
            var _iterations = 300;
            repeat (_iterations) {
                var _list = ds_list_create();
                var _num = instance_place_list(x, y, o_unit, _list, false);
                var _moved = false;
                
                for (var i = 0; i < _num; i++) {
                    var _other = _list[| i];
                    if (_other == id) continue; // 'id' here means _spawned. Properly ignores itself now!
                    
                    var _dir = point_direction(_other.x, _other.y, x, y);
                    if (x == _other.x && y == _other.y) _dir = random(360);
                    
                    x += lengthdir_x(1, _dir);
                    y += lengthdir_y(1, _dir);
                    _moved = true;
					
		            // --- clamp to room bounds using sprite extents ---
		            var _halfLeft   = sprite_get_xoffset(sprite_index);
		            var _halfRight  = sprite_get_width(sprite_index)  - _halfLeft;
		            var _halfTop    = sprite_get_yoffset(sprite_index);
		            var _halfBottom = sprite_get_height(sprite_index) - _halfTop;
        
		            x = clamp(x, _halfLeft,  room_width  - _halfRight);
		            y = clamp(y, _halfTop,   room_height - _halfBottom);
        
					
                }
                ds_list_destroy(_list);
                if (!_moved) break;
            }
            
            // --- validate final position exactly like a player drop ---
            var _unit_hit    = instance_place(x, y, o_unit);
            var _terrain_hit = instance_place(x, y, o_impassable);

            var _blocked_by_unit    = (_unit_hit != noone && _unit_hit != id);
            var _blocked_by_terrain = (_terrain_hit != noone && _terrain_hit != id);

            if (_blocked_by_unit || _blocked_by_terrain) {
                _destroyed = true;
                instance_destroy();
            }
        }
        
        // --- Process final resolution back in manager scope if the unit survived ---
        if (!_destroyed) {
			x = _spawned.x
			y = _spawned.y
            global.dropped = _spawned;
            o_combat_resolver.resolve_first_strike();
            global.dropped = noone;
			visible = true
        }
		else{
			visible = false	
		}
    }
	
	if(_spawned == noone){
		visible = false	
	}
    
    show_debug_message(string(best_x) + " " +  string(best_y));
}