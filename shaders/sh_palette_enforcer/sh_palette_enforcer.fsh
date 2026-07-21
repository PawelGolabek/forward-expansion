// sh_palette_enforcer.fsh
//
// Modifiable Palette Enforcer
// Remaps every rendered pixel to the closest colour in a palette that is
// uploaded from GML every frame (so it can be changed live, transitioned,
// swapped, loaded from an image, etc).
//
// IMPORTANT: MAX_COLORS below must match PALETTE_ENFORCER_MAX_COLORS
// in scr_palette_enforcer.gml.

#ifdef GL_ES
precision mediump float;
#endif

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

#define MAX_COLORS 64

uniform vec3  u_palette[MAX_COLORS]; // active palette colours, 0..1 range
uniform int   u_paletteSize;         // how many entries of u_palette are in use
uniform float u_ditherStrength;      // 0 = off, try 0.02-0.08 for retro banding reduction
uniform float u_weightPerceptual;    // >0.5 = perceptually weighted distance, else plain RGB

// 4x4 Bayer ordered-dither threshold, written without dynamic array/matrix
// indexing so it compiles safely under GLSL ES 1.00 (mobile/HTML5 safe).
float GetBayerValue(vec2 fragCoord)
{
    float x = mod(fragCoord.x, 4.0);
    float y = mod(fragCoord.y, 4.0);
    float index = y * 4.0 + x; // 0..15

    if (index < 0.5)  return 0.0  / 16.0;
    if (index < 1.5)  return 8.0  / 16.0;
    if (index < 2.5)  return 2.0  / 16.0;
    if (index < 3.5)  return 10.0 / 16.0;
    if (index < 4.5)  return 12.0 / 16.0;
    if (index < 5.5)  return 4.0  / 16.0;
    if (index < 6.5)  return 14.0 / 16.0;
    if (index < 7.5)  return 6.0  / 16.0;
    if (index < 8.5)  return 3.0  / 16.0;
    if (index < 9.5)  return 11.0 / 16.0;
    if (index < 10.5) return 1.0  / 16.0;
    if (index < 11.5) return 9.0  / 16.0;
    if (index < 12.5) return 15.0 / 16.0;
    if (index < 13.5) return 7.0  / 16.0;
    if (index < 14.5) return 13.0 / 16.0;
    return 5.0 / 16.0;
}

void main()
{
    vec4 texColor = texture2D(gm_BaseTexture, v_vTexcoord) * v_vColour;

    // Leave fully transparent pixels alone (avoids colouring in empty space).
    if (texColor.a <= 0.0)
    {
        gl_FragColor = texColor;
        return;
    }

    vec3 col = texColor.rgb;

    if (u_ditherStrength > 0.0)
    {
        float d = (GetBayerValue(gl_FragCoord.xy) - 0.5) * u_ditherStrength;
        col += vec3(d);
    }

    float bestDist  = 1.0e6;
    vec3  bestColor = col;

    // Loop bound is the constant MAX_COLORS with an early break — this is
    // the portable pattern for GLSL ES 1.00 (constant loop form, runtime exit).
    for (int i = 0; i < MAX_COLORS; i++)
    {
        if (i >= u_paletteSize) break;

        vec3 pc   = u_palette[i];
        vec3 diff = col - pc;

        float dist;
        if (u_weightPerceptual > 0.5)
        {
            // "Redmean" style perceptual weighting — cheap approximation of
            // human colour sensitivity, much better than plain RGB distance.
            float rmean = (col.r + pc.r) * 0.5;
            vec3  w     = vec3(2.0 + rmean, 4.0, 3.0 - rmean);
            dist = dot(diff * diff, w);
        }
        else
        {
            dist = dot(diff, diff);
        }

        if (dist < bestDist)
        {
            bestDist  = dist;
            bestColor = pc;
        }
    }

    gl_FragColor = vec4(bestColor, texColor.a);
}
