//
// shd_outline.fsh
// Multi-pixel outline with adjustable thickness and colour.
//
// Meant to be used on a texture that already has transparent padding around
// the sprite (e.g. a surface) so the outline has room to be drawn without
// being clipped by GameMaker's automatic texture-page cropping.
//
// Loop is fixed at -8..8 (GLSL ES requires constant loop bounds), which caps
// supported thickness at 8px. Widen the loop range if you need more, but
// cost grows roughly with the square of the radius.
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2  u_texel;         // 1.0 / texture width, 1.0 / texture height
uniform float u_thickness;     // outline thickness in pixels (0 - 8)
uniform vec4  u_outlineColour; // outline colour, rgba, 0-1 range
uniform vec4  u_uvClamp;       // xy = min uv of the drawable region, zw = max uv
                                // (stops the shader reading a neighbouring sprite
                                // if you ever skip the padded-surface approach)

void main()
{
    vec4 baseCol = texture2D( gm_BaseTexture, v_vTexcoord );

    // Inside the sprite's own pixels -> draw as normal.
    if ( baseCol.a > 0.0 )
    {
        gl_FragColor = baseCol * v_vColour;
        return;
    }

    // Outside the sprite -> scan a circular neighbourhood for any opaque
    // pixel. If one exists within u_thickness pixels, this becomes outline.
    float maxAlpha = 0.0;
    int   iThick   = int( ceil( u_thickness ) );

    for ( int x = -8; x <= 8; x++ )
    {
        if ( x < -iThick || x > iThick ) continue;

        for ( int y = -8; y <= 8; y++ )
        {
            if ( y < -iThick || y > iThick ) continue;
            if ( x == 0 && y == 0 ) continue;

            float dist = length( vec2( float(x), float(y) ) );
            if ( dist > u_thickness ) continue;

			vec2 sampleUV = v_vTexcoord + vec2( float(x), float(y) ) * u_texel;
			if ( sampleUV.x < u_uvClamp.x || sampleUV.x > u_uvClamp.z ||
			     sampleUV.y < u_uvClamp.y || sampleUV.y > u_uvClamp.w )
{
    continue; // outside this sprite's own frame — treat as no data, don't sample
}
maxAlpha = max( maxAlpha, texture2D( gm_BaseTexture, sampleUV ).a );
        }
    }

    gl_FragColor = ( maxAlpha > 0.0 ) ? vec4( u_outlineColour.rgb, u_outlineColour.a ) : vec4(0.0);
}
