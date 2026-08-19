varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 u_target;
uniform float u_radius;
uniform float u_edge;

void main()
{
    float d = distance(v_vTexcoord, u_target);

    float alpha = 1.0 - smoothstep(
        u_radius - u_edge,
        u_radius,
        d
    );

    vec4 surface_colour = texture2D(
        gm_BaseTexture,
        v_vTexcoord
    );

    gl_FragColor = surface_colour * alpha;
}