// shd_shadow.fsh - Fragment Shader
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4 u_shadow_color; // Passes our custom shadow color (RGBA)

void main()
{
    // Get the original pixel color from the sprite texture
    vec4 tex_color = texture2D(gm_BaseTexture, v_vTexcoord);
    
    // Mix the original sprite's transparency (alpha) with our solid shadow color
    gl_FragColor = vec4(u_shadow_color.rgb, tex_color.a * u_shadow_color.a);
}