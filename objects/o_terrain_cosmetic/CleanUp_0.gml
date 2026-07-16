/// Clean Up event
if (surface_exists(outline_surf)) {
    surface_free(outline_surf);
    outline_surf = -1;
}