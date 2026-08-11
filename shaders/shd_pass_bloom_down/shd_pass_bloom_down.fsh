varying vec2 v_vTexcoord;

uniform vec2 u_texel_size;

void main() {
    // Dual Kawase downsample: sample center + 4 diagonal corners
    vec2 halfpixel = u_texel_size * 0.5;
    vec2 o = halfpixel;

    // Sample center with 4x weight
    vec4 color = texture2D(gm_BaseTexture, v_vTexcoord) * 4.0;

    // Sample 4 diagonal corners with 1x weight each
    color += texture2D(gm_BaseTexture, v_vTexcoord + vec2(-o.x, -o.y));
    color += texture2D(gm_BaseTexture, v_vTexcoord + vec2( o.x, -o.y));
    color += texture2D(gm_BaseTexture, v_vTexcoord + vec2(-o.x,  o.y));
    color += texture2D(gm_BaseTexture, v_vTexcoord + vec2( o.x,  o.y));

    // Apply normalize by total weight
    gl_FragColor = (color / 8.0);
}