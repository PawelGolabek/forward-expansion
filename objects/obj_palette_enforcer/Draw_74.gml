

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

if (surface_exists(application_surface))
{
    if (global.palette_enforcer.apply())
    {
        draw_surface_stretched(application_surface, 0, 0, _gw, _gh);
        shader_reset();
    }
    else
    {
        // enforcer disabled or palette empty — draw normally
        draw_surface_stretched(application_surface, 0, 0, _gw, _gh);
    }
}
