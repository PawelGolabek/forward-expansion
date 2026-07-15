varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 texel;
uniform vec4 outline_color;

void main()
{
    vec4 base = texture2D(gm_BaseTexture, v_vTexcoord);

    float alpha = base.a;

    float around = 0.0;
    around += texture2D(gm_BaseTexture, v_vTexcoord + vec2(texel.x, 0.0)).a;
    around += texture2D(gm_BaseTexture, v_vTexcoord - vec2(texel.x, 0.0)).a;
    around += texture2D(gm_BaseTexture, v_vTexcoord + vec2(0.0, texel.y)).a;
    around += texture2D(gm_BaseTexture, v_vTexcoord - vec2(0.0, texel.y)).a;

    if (alpha == 0.0 && around > 0.0)
    {
        gl_FragColor = outline_color;
    }
    else
    {
        gl_FragColor = base * v_vColour;
    }
}