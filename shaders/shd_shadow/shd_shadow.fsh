varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4 u_shadow_color;

void main()
{
    // Flip image vertically
    vec2 flipped_uv = vec2(v_vTexcoord.x, 1.0 - v_vTexcoord.y);

    vec4 tex_color = texture2D(gm_BaseTexture, flipped_uv);

    // Keep original shadow coloring
    gl_FragColor = vec4(u_shadow_color.rgb, tex_color.a * u_shadow_color.a);
}