varying vec2 v_vTexcoord;

uniform vec2 u_texel_size;

void main() {
    // Dual Kawase upsample: sample 4 edge centers + 4 diagonal corners
    vec2 halfpixel = u_texel_size * 0.5;
    vec2 o = halfpixel;

    vec4 color = vec4(0.0);

    // Sample 4 edge centers with 1x weight each
    color += texture2D(gm_BaseTexture, v_vTexcoord + vec2(-o.x * 2.0, 0.0));
    color += texture2D(gm_BaseTexture, v_vTexcoord + vec2( o.x * 2.0, 0.0));
    color += texture2D(gm_BaseTexture, v_vTexcoord + vec2(0.0, -o.y * 2.0));
    color += texture2D(gm_BaseTexture, v_vTexcoord + vec2(0.0,  o.y * 2.0));

    // Sample 4 diagonal corners with 2x weight each
    color += texture2D(gm_BaseTexture, v_vTexcoord + vec2(-o.x,  o.y)) * 2.0;
    color += texture2D(gm_BaseTexture, v_vTexcoord + vec2( o.x,  o.y)) * 2.0;
    color += texture2D(gm_BaseTexture, v_vTexcoord + vec2(-o.x, -o.y)) * 2.0;
    color += texture2D(gm_BaseTexture, v_vTexcoord + vec2( o.x, -o.y)) * 2.0;

    // Apply normalize by total weight
    gl_FragColor = (color / 12.0);
}