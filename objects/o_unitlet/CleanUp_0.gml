if (surface_exists(final_surf)) {
    surface_free(final_surf);
    final_surf = -1;
}

if (surface_exists(scratch_surf)) {
    surface_free(scratch_surf);
    scratch_surf = -1;
}