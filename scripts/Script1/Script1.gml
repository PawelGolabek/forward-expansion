/// @function scr_draw_sprite_outline(_sprite, _subimg, _x, _y, _xscale, _yscale, _blend, _alpha, _thickness, _outline_colour)
/// @description Draws a sprite with an outline, using a temporary surface that is freed immediately.
///              No persistent surfaces, no memory leaks.
function scr_draw_sprite_outline(_sprite, _subimg, _x, _y, _xscale, _yscale, _blend, _alpha, _thickness, _outline_colour)
{
    shader_reset();

    //  Crucial: free the temporary surface immediately
    surface_free(_surf);
}

/// @param _instances
/// @param _thickness
/// @param _outline_colour
/// @param _instances   array of instance ids to draw
/// @param _thickness   outline thickness in px, used only for glowing instances
/// @param _instances       array of instance ids to draw
/// @param _thickness       glow outline thickness (px), used when redGlow/glow is set
/// @param _black_thickness black background outline thickness (px), always drawn
function scr_draw_units_batch(_instances, _thickness, _black_thickness)
{
    static _u_texel   = shader_get_uniform(shd_outline, "u_texel");
    static _u_thick   = shader_get_uniform(shd_outline, "u_thickness");
    static _u_colour  = shader_get_uniform(shd_outline, "u_outlineColour");
    static _u_uvclamp = shader_get_uniform(shd_outline, "u_uvClamp");

    var n = array_length(_instances);

    for (var i = 0; i < n; i++)
    {
        var inst = _instances[i];
        if (!instance_exists(inst)) continue;

        var _spr = inst.sprite_index;
        var _idx = inst.image_index;
        var _tex = sprite_get_texture(_spr, _idx);
        var _uv  = texture_get_uvs(_tex);

        shader_set(shd_outline);
        shader_set_uniform_f(_u_texel, texture_get_texel_width(_tex), texture_get_texel_height(_tex));
        shader_set_uniform_f(_u_uvclamp, _uv[0], _uv[1], _uv[2], _uv[3]);

        // 1) always: bigger black ring behind everything
        shader_set_uniform_f(_u_thick, _black_thickness);
        shader_set_uniform_f(_u_colour, 0, 0, 0, 1);
        draw_sprite_ext(_spr, _idx, inst.x, inst.y, inst.image_xscale, inst.image_yscale, inst.image_angle, c_white, inst.image_alpha);

        // 2) optional: coloured glow ring on top of the black one
        if (inst.redGlow || inst.glow)
        {
            var _col = inst.redGlow ? c_red : c_yellow;
            shader_set_uniform_f(_u_thick, _thickness);
            shader_set_uniform_f(_u_colour,
                color_get_red(_col)   / 255,
                color_get_green(_col) / 255,
                color_get_blue(_col)  / 255,
                1);
            draw_sprite_ext(_spr, _idx, inst.x, inst.y, inst.image_xscale, inst.image_yscale, inst.image_angle, c_white, inst.image_alpha);

            inst.redGlow = false;
            inst.glow    = false;
        }

        shader_reset();

        // 3) the real sprite on top, masking the ring's interior
        draw_sprite_ext(_spr, _idx, inst.x, inst.y, inst.image_xscale, inst.image_yscale, inst.image_angle, c_white, inst.image_alpha);
    }
}