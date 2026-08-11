/// @description Init
event_inherited();

var demo_config = {
	geometry: {
		content_width: 640,
		content_height: 480,
		do_int_scale: false,
		zoom: 1.1,
		border_width: 0.05
	},
	ntsc: {
		phase_offset_per_line: 0.5,
		phase_offset_per_frame: 0.25
	},
	lines: {
		do_interlace: true
	}
}

my_crt = new CRT(demo_config);
demo_title = "480i Interlacing";