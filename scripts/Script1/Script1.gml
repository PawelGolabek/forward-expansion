/// @function scr_draw_sprite_outline(_sprite, _subimg, _x, _y, _xscale, _yscale, _blend, _alpha, _thickness, _outline_colour, _surf)
/// @description Draws a sprite with a crop-safe outline of adjustable pixel
///              thickness and colour. Works by rendering the sprite onto a
///              padded surface first, so texture-page cropping never eats
///              into the outline. Works with any sprite origin or scale!
function scr_draw_sprite_outline(_sprite, _subimg, _x, _y, _xscale, _yscale, _blend, _alpha, _thickness, _outline_colour, _surf)
{
    static _u_texel   = shader_get_uniform(shd_outline, "u_texel");
    static _u_thick   = shader_get_uniform(shd_outline, "u_thickness");
    static _u_colour  = shader_get_uniform(shd_outline, "u_outlineColour");
    static _u_uvclamp = shader_get_uniform(shd_outline, "u_uvClamp");

    var _pad    = ceil(_thickness) + 1;
    var _w      = sprite_get_width(_sprite);
    var _h      = sprite_get_height(_sprite);
    var _xoffset = sprite_get_xoffset(_sprite);
    var _yoffset = sprite_get_yoffset(_sprite);

    var _sw     = ceil(_w * abs(_xscale));
    var _sh     = ceil(_h * abs(_yscale));
    var _surf_w = _sw + _pad * 2;
    var _surf_h = _sh + _pad * 2;

    // (Re)create the surface if it doesn't exist or the required size changed
    if ( !surface_exists(_surf) || surface_get_width(_surf) != _surf_w || surface_get_height(_surf) != _surf_h )
    {
        if ( surface_exists(_surf) ) surface_free(_surf);
        _surf = surface_create(_surf_w, _surf_h);
    }

    // Math: Determine the leftmost/topmost boundary of the sprite relative to its origin
    // This perfectly accounts for negative/flipped scales too!
    var _left_boundary = (_xscale >= 0) ? (-_xoffset * _xscale) : ((_w - _xoffset) * _xscale);
    var _top_boundary  = (_yscale >= 0) ? (-_yoffset * _yscale) : ((_h - _yoffset) * _yscale);

    var _draw_surf_x = _pad - _left_boundary;
    var _draw_surf_y = _pad - _top_boundary;

    // Draw the plain sprite into the padded surface
    surface_set_target(_surf);
    draw_clear_alpha(0, 0);
    draw_sprite_ext(_sprite, _subimg, _draw_surf_x, _draw_surf_y, _xscale, _yscale, 0, c_white, 1);
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
    shader_set_uniform_f(_u_uvclamp, 0, 0, 1, 1);

    // Calculate where to draw the surface in room space so the origin aligns perfectly
    var _room_draw_x = _x - _draw_surf_x;
    var _room_draw_y = _y - _draw_surf_y;

    draw_surface_ext(_surf, _room_draw_x, _room_draw_y, 1, 1, 0, _blend, _alpha);

    shader_reset();

    return _surf;
}