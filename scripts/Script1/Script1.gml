

/// @function scr_draw_sprite_outline(_sprite, _subimg, _x, _y, _xscale, _yscale, _blend, _alpha, _thickness, _outline_colour, _surf)
/// @description Draws a sprite with a crop-safe outline of adjustable pixel
///              thickness and colour. Works by rendering the sprite onto a
///              padded surface first, so texture-page cropping never eats
///              into the outline.
///
/// @param {Asset.GMSprite} _sprite
/// @param {Real}   _subimg
/// @param {Real}   _x
/// @param {Real}   _y
/// @param {Real}   _xscale
/// @param {Real}   _yscale
/// @param {Constant.Color} _blend
/// @param {Real}   _alpha
/// @param {Real}   _thickness        outline thickness in pixels, 0-8 (see shd_outline.fsh)
/// @param {Constant.Color} _outline_colour
/// @param {Id.Surface} _surf         pass -1 the first call; then keep passing back
///                                   whatever this function returns
/// @returns {Id.Surface}             store this back into your instance variable
///
/// NOTE: if you also rotate the sprite before calling this, the padding below
/// won't account for the larger rotated bounding box - pad extra manually in
/// that case, or rotate the surface itself with draw_surface_ext instead.
function scr_draw_sprite_outline(_sprite, _subimg, _x, _y, _xscale, _yscale, _blend, _alpha, _thickness, _outline_colour, _surf)
{
    static _u_texel   = shader_get_uniform(shd_outline, "u_texel");
    static _u_thick   = shader_get_uniform(shd_outline, "u_thickness");
    static _u_colour  = shader_get_uniform(shd_outline, "u_outlineColour");
    static _u_uvclamp = shader_get_uniform(shd_outline, "u_uvClamp");

    var _pad    = ceil(_thickness) + 1;
    var _sw     = ceil( sprite_get_width(_sprite)  * abs(_xscale) );
    var _sh     = ceil( sprite_get_height(_sprite) * abs(_yscale) );
    var _surf_w = _sw + _pad * 2;
    var _surf_h = _sh + _pad * 2;

    // (Re)create the surface if it doesn't exist or the required size changed
    if ( !surface_exists(_surf) || surface_get_width(_surf) != _surf_w || surface_get_height(_surf) != _surf_h )
    {
        if ( surface_exists(_surf) ) surface_free(_surf);
        _surf = surface_create(_surf_w, _surf_h);
    }

    // Draw the plain sprite into the padded surface (no shader here)
    surface_set_target(_surf);
    draw_clear_alpha(0, 0);
    draw_sprite_ext(_sprite, _subimg, _pad, _pad, _xscale, _yscale, 0, c_white, 1);
    surface_reset_target();

    // Draw the padded surface to the screen through the outline shader
    shader_set(shd_outline);
    shader_set_uniform_f(_u_texel, 1 / _surf_w, 1 / _surf_h);
    shader_set_uniform_f(_u_thick, _thickness);
    shader_set_uniform_f(_u_colour,
        color_get_red(_outline_colour)   / 255,
        color_get_green(_outline_colour) / 255,
        color_get_blue(_outline_colour)  / 255,
        1);
    // Whole surface belongs to this one draw, so no atlas bleed protection needed
    shader_set_uniform_f(_u_uvclamp, 0, 0, 1, 1);

    draw_surface_ext(_surf, _x - _pad, _y - _pad, 1, 1, 0, _blend, _alpha);

    shader_reset();

    return _surf;
}





