/// @description How to setup

// You can init from defaults
	/*
	my_crt = new CRT();
	*/

// You can init with some custom settings
	/*
	var overrides = {
		ntsc: {
			color_temperature: 0.5
		}
	}
	my_crt = new CRT(overrides);
	*/

// You can init and change things later on-the-fly
	/*
	my_crt = new CRT().configure_ntsc(false).configure_lines({max_sigma:0.5}).update_uniforms();
	*/

// You can init from JSON
	/*
	var json = "{ntsc:{color_saturation:2.0}}"
	my_crt = new CRT(json);
	*/

// You can init from an object's variable definitions (like in earlier versions)
	/*
	my_crt = new CRT(ExamplePresetAsAnObject);
	*/


// This is just for the debug overlay in the demo
var _info = os_get_info();
gfx_name = _info[? "video_adapter_description"] 
             ?? _info[? "GL_RENDERER"] 
             ?? _info[? "gl_renderer"] 
             ?? "Unknown Graphics Adapter";
ds_map_destroy(_info);

gfx_name += "\n    Detected window size: " +string(window_get_width()) + ", " +string(window_get_height());
display_set_gui_size(window_get_width(), window_get_height());

// Menu navigation: which setting row is currently selected
// Use Up/Down to move, Left/Right or Space to change the selected setting
selected = 0;
setting_count = 11;