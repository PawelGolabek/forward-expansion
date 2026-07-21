// scr_palette_enforcer.gml
//
// Modifiable Palette Enforcer — GML side.
// Create a script resource called "scr_palette_enforcer" and paste this in.
//
// Usage overview:
//   global.palette_enforcer = new PaletteEnforcer();
//   global.palette_enforcer.set_palette([c_black, c_white, c_red]);
//   global.palette_enforcer.set_dither(0.04);
//   ... every frame: global.palette_enforcer.apply() before drawing the
//       application surface (see obj_palette_enforcer events below).

#macro PALETTE_ENFORCER_MAX_COLORS 64   // MUST match MAX_COLORS in the .fsh

/// @function hex_to_color(hex)
/// @desc Converts a "#RRGGBB" or "RRGGBB" string (e.g. from Lospec) into a GM colour.
function hex_to_color(_hex)
{
    _hex = string_replace(_hex, "#", "");
    var _r = real("0x" + string_copy(_hex, 1, 2));
    var _g = real("0x" + string_copy(_hex, 3, 2));
    var _b = real("0x" + string_copy(_hex, 5, 2));
    return make_color_rgb(_r, _g, _b);
}

/// @function palette_from_hex_array(hex_array)
/// @desc Converts an array of hex strings into an array of GM colours.
function palette_from_hex_array(_hex_array)
{
    var _n = array_length(_hex_array);
    var _out = array_create(_n);
    for (var i = 0; i < _n; i++) _out[i] = hex_to_color(_hex_array[i]);
    return _out;
}

/// @function PaletteEnforcer([shader])
/// @desc Runtime-modifiable palette quantizer. One instance drives the shader;
///       keep it in a global (see obj_palette_enforcer) so any script/object
///       in the game can reach in and change the palette.
function PaletteEnforcer(_shader = sh_palette_enforcer) constructor
{
    shader = _shader;

    u_palette = shader_get_uniform(shader, "u_palette");
    u_size    = shader_get_uniform(shader, "u_paletteSize");
    u_dither  = shader_get_uniform(shader, "u_ditherStrength");
    u_perc    = shader_get_uniform(shader, "u_weightPerceptual");

    max_colors      = PALETTE_ENFORCER_MAX_COLORS;
    colors          = [];     // array of GM colour ints (make_color_rgb / c_red / hex_to_color / ...)
    dither_strength = 0.0;
    perceptual      = true;
    enabled         = true;

    // --- palette transition state (for smooth palette swaps) ---
    _from_colors = [];
    _to_colors   = [];
    _t           = 1.0;   // 1.0 = no transition in progress
    _duration    = 1;

    /// Replace the whole palette immediately.
    static set_palette = function(_color_array)
    {
        var _n = min(array_length(_color_array), max_colors);
        colors = array_create(_n);
        for (var i = 0; i < _n; i++) colors[i] = _color_array[i];
        _t = 1.0; // cancel any in-progress transition
        return self;
    }

    /// Set (or grow into) a single palette slot.
    static set_color = function(_index, _color)
    {
        if (_index < 0 || _index >= max_colors)
        {
            show_debug_message($"PaletteEnforcer: index {_index} out of range (0-{max_colors - 1})");
            return self;
        }
        while (array_length(colors) <= _index) array_push(colors, c_black);
        colors[_index] = _color;
        return self;
    }

    /// Append one colour to the end of the palette, if there's room.
    static add_color = function(_color)
    {
        if (array_length(colors) >= max_colors)
        {
            show_debug_message("PaletteEnforcer: palette full, colour ignored");
            return self;
        }
        array_push(colors, _color);
        return self;
    }

    static remove_color = function(_index)
    {
        if (_index < 0 || _index >= array_length(colors)) return self;
        array_delete(colors, _index, 1);
        return self;
    }

    static clear_palette = function()
    {
        colors = [];
        return self;
    }

    /// Build the palette from the unique pixel colours of a sprite — handy
    /// for letting an artist design a palette as a small strip/swatch PNG
    /// and just dropping it in as a sprite asset.
    static load_from_sprite = function(_sprite, _subimg = 0)
    {
        var _w = sprite_get_width(_sprite);
        var _h = sprite_get_height(_sprite);

        var _surf = surface_create(_w, _h);
        surface_set_target(_surf);
        draw_clear_alpha(0, 0);
        draw_sprite(_sprite, _subimg, 0, 0);
        surface_reset_target();

        var _buffer = buffer_create(_w * _h * 4, buffer_fixed, 1);
        buffer_get_surface(_buffer, _surf, 0);

        var _new_colors = [];

        for (var yy = 0; yy < _h; yy++)
        {
            for (var xx = 0; xx < _w; xx++)
            {
                var _offset = (yy * _w + xx) * 4;
                var _r = buffer_peek(_buffer, _offset,     buffer_u8);
                var _g = buffer_peek(_buffer, _offset + 1, buffer_u8);
                var _b = buffer_peek(_buffer, _offset + 2, buffer_u8);
                var _a = buffer_peek(_buffer, _offset + 3, buffer_u8);

                if (_a < 8) continue; // skip transparent pixels

                var _col = make_color_rgb(_r, _g, _b);

                var _found = false;
                for (var k = 0; k < array_length(_new_colors); k++)
                {
                    if (_new_colors[k] == _col) { _found = true; break; }
                }
                if (!_found && array_length(_new_colors) < max_colors)
                {
                    array_push(_new_colors, _col);
                }
            }
        }

        buffer_delete(_buffer);
        surface_free(_surf);

        set_palette(_new_colors);
        return self;
    }

    /// Smoothly blend from the current palette to a new one over N frames.
    /// Call update() once per Step for this to advance.
    static transition_to = function(_color_array, _frames)
    {
        _from_colors = (array_length(colors) > 0) ? colors : _color_array;

        var _n = min(array_length(_color_array), max_colors);
        _to_colors = array_create(_n);
        for (var i = 0; i < _n; i++) _to_colors[i] = _color_array[i];

        _duration = max(1, _frames);
        _t = 0.0;
        return self;
    }

    /// Advances any in-progress transition. Call once per Step event.
    static update = function()
    {
        if (_t < 1.0)
        {
            _t = min(1.0, _t + 1.0 / _duration);

            var _n = array_length(_to_colors);
            var _mixed = array_create(_n);
            for (var i = 0; i < _n; i++)
            {
                var _cA = (i < array_length(_from_colors)) ? _from_colors[i] : _to_colors[i];
                _mixed[i] = merge_color(_cA, _to_colors[i], _t);
            }
            colors = _mixed;
        }
    }

    static set_dither     = function(_strength) { dither_strength = clamp(_strength, 0, 1); return self; }
    static set_perceptual  = function(_on)       { perceptual = _on; return self; }
    static set_enabled     = function(_on)       { enabled = _on; return self; }

    /// Uploads the current palette to the shader and turns it on.
    /// Returns false (and does nothing) if disabled or empty — caller should
    /// still draw the surface normally in that case. See obj_palette_enforcer.
    static apply = function()
    {
        if (!enabled || array_length(colors) == 0) return false;

        var _n = array_length(colors);
        var _flat = array_create(_n * 3);
        for (var i = 0; i < _n; i++)
        {
            var _c = colors[i];
            _flat[i * 3 + 0] = color_get_red(_c)   / 255;
            _flat[i * 3 + 1] = color_get_green(_c) / 255;
            _flat[i * 3 + 2] = color_get_blue(_c)  / 255;
        }

        shader_set(shader);
        shader_set_uniform_f_array(u_palette, _flat);
        shader_set_uniform_i(u_size, _n);
        shader_set_uniform_f(u_dither, dither_strength);
        shader_set_uniform_f(u_perc, perceptual ? 1.0 : 0.0);
        return true;
    }
}
