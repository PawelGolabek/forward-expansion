/// @description Menu navigation


// Move the selection cursor up/down between settings
if keyboard_check_pressed(vk_up) {
	selected = (selected - 1 + setting_count) mod setting_count;
}
if keyboard_check_pressed(vk_down) {
	selected = (selected + 1) mod setting_count;
}

// Change the currently selected setting
var _left = keyboard_check_pressed(vk_left);
var _right = keyboard_check_pressed(vk_right);
var _space = keyboard_check_pressed(vk_space);
var _forward = _right || _space;
var _change = _left || _forward;

if (_change) {
	switch (selected) {
		// Toggle main CRT pass
		case 0:
			if my_crt.final_pass_shader == shd_pass_crt {
				my_crt.set_shader(shd_pass_crt_raw_variant);
			} else {
				my_crt.set_shader(shd_pass_crt);
			}
		break;

		// Toggle NTSC pass
		case 1:
			my_crt.configure_ntsc(not my_crt.ntsc.enabled);
		break;

		// Toggle bloom pass
		case 2:
			my_crt.configure_bloom(not my_crt.bloom.enabled);
		break;

		// Toggle curvature
		case 3:
			if my_crt.geometry.curvature == 0 {
				my_crt.configure_geometry({curvature: 0.1});
			} else {
				my_crt.configure_geometry({curvature: 0});
			}
		break;

		// Toggle tate mode
		case 4:
			my_crt.configure_lines({do_tate: not my_crt.lines.do_tate});
		break;

		// Toggle debug overlay
		case 5:
			show_debug_overlay(not is_debug_overlay_open());
		break;

		// Cycle horizontal mask type
		case 6:
			if (_forward) {
				switch(my_crt.mask.sprite) {
					case spr_mask_rgbx: my_crt.mask.sprite = spr_mask_bgrx; break;
					case spr_mask_bgrx: my_crt.mask.sprite = spr_mask_gm; break;
					case spr_mask_gm: my_crt.mask.sprite = spr_mask_yb; break;
					case spr_mask_yb: my_crt.mask.sprite = spr_mask_rycb; break;
					case spr_mask_rycb: my_crt.mask.sprite = spr_mask_rmcg; break;
					case spr_mask_rmcg: my_crt.mask.sprite = spr_mask_rgbx; break;
				}
			} else {
				switch(my_crt.mask.sprite) {
					case spr_mask_rgbx: my_crt.mask.sprite = spr_mask_rmcg; break;
					case spr_mask_rmcg: my_crt.mask.sprite = spr_mask_rycb; break;
					case spr_mask_rycb: my_crt.mask.sprite = spr_mask_yb; break;
					case spr_mask_yb: my_crt.mask.sprite = spr_mask_gm; break;
					case spr_mask_gm: my_crt.mask.sprite = spr_mask_bgrx; break;
					case spr_mask_bgrx: my_crt.mask.sprite = spr_mask_rgbx; break;
				}
			}
		break;

		// Cycle shadow mask type
		case 7:
			if (_forward) {
				if my_crt.mask.do_shadow {
					my_crt.configure_mask({do_shadow: false});
				} else if my_crt.mask.slot_strength == 0 {
						my_crt.configure_mask({slot_strength: 1.0});
				} else {
					switch(my_crt.mask.slot_height) {
						case 0: my_crt.configure_mask({slot_height: 1}); break;
						case 1: my_crt.configure_mask({slot_height: 2}); break;
						case 2: {
							my_crt.configure_mask({slot_height: 0, slot_strength: 0.0, do_shadow: true});
						}break;
					}
				}
			} else {
				if my_crt.mask.do_shadow {
					my_crt.configure_mask({do_shadow: false, slot_strength: 1.0, slot_height: 2});
				} else if my_crt.mask.slot_strength == 0 {
						my_crt.configure_mask({do_shadow: true});
				} else {
					switch(my_crt.mask.slot_height) {
						case 2: my_crt.configure_mask({slot_height: 1}); break;
						case 1: my_crt.configure_mask({slot_height: 0}); break;
						case 0: {
							my_crt.configure_mask({slot_strength: 0.0});
						}break;
					}
				}
			}
		break;

		// Cycle lines
		case 8:
			if (_forward) {
				switch (my_crt.lines.min_sigma) {
					case 0.225: {
						my_crt.configure_lines({min_sigma:0.15, max_sigma: 0.3});
					} break;
					case 0.15: {
						my_crt.configure_lines({min_sigma:0.5, max_sigma: 0.5});
					} break;
					case 0.5: {
						my_crt.configure_lines({min_sigma:0.225, max_sigma: 0.5});
					} break;
				}
			} else {
				switch (my_crt.lines.min_sigma) {
					case 0.225: {
						my_crt.configure_lines({min_sigma:0.5, max_sigma: 0.5});
					} break;
					case 0.5: {
						my_crt.configure_lines({min_sigma:0.15, max_sigma: 0.3});
					} break;
					case 0.15: {
						my_crt.configure_lines({min_sigma:0.225, max_sigma: 0.5});
					} break;
				}
			}
		break;

		// Cycle presentation
		case 9:
			// Classify current presentation from geometry
			var _pres = 0;
			if (my_crt.geometry.do_int_scale) {
				_pres = 2;
			} else if (my_crt.geometry.zoom == 1.0) {
				_pres = 1;
			} else {
				_pres = 0;
			}

			if (_forward) {
				_pres = (_pres + 1) mod 3;
			} else {
				_pres = (_pres - 1 + 3) mod 3;
			}

			switch (_pres) {
				case 0: // Immersive
					my_crt.configure_geometry({zoom: 1.1, border_width: 0.05, do_int_scale: false});
				break;
				case 1: // Full
					my_crt.configure_geometry({zoom: 1.0, border_width: 0.15, do_int_scale: false});
				break;
				case 2: // Integer
					my_crt.configure_geometry({zoom: 1.0, border_width: 0.15, do_int_scale: true});
				break;
			}
		break;

		// Next / previous demo
		case 10:
			if (_forward) {
				if room == room_last {
					room_goto(rm_example_nes);
				} else {
					room_goto_next();
				}
			} else {
				if room == rm_example_nes {
					room_goto(room_last);
				} else {
					room_goto_previous();
				}
			}
		break;
	}
}
