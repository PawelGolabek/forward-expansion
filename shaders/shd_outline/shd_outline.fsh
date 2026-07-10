//
// Outline shader with configurable color
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform vec2 sprite_size;
uniform vec4 outlineColor;

void main()
{
    float alpha = 0.0;

    //Add alpha depending on the pixels surrounding it
    alpha += texture2D( gm_BaseTexture, v_vTexcoord + vec2(-sprite_size.x, 0.0) ).a; //Left
    alpha += texture2D( gm_BaseTexture, v_vTexcoord + vec2( sprite_size.x, 0.0) ).a; //Right
    alpha += texture2D( gm_BaseTexture, v_vTexcoord + vec2(0.0,  sprite_size.y) ).a; //Down
    alpha += texture2D( gm_BaseTexture, v_vTexcoord + vec2(0.0, -sprite_size.y) ).a; //Up

    alpha = clamp(alpha, 0.0, 1.0); //avoid overbright/clipped edges from multiple overlapping neighbors

    //Use the passed-in color instead of hardcoded black
    gl_FragColor = vec4(outlineColor.rgb, alpha * outlineColor.a);
}