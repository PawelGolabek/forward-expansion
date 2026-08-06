varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 u_resolution; // Screen size in pixels (e.g. [1920.0, 1080.0])
uniform float u_time;      // Optional animated light angle or movement
uniform vec3 u_lightDir;   // Light direction vector (e.g. [0.2, -0.8, 0.6])

void main() {
    // Normalize UV coordinates to match aspect ratio
    vec2 st = (gl_FragCoord.xy - 0.5 * u_resolution.xy) / u_resolution.y;

    // Convert screen coordinates into an isometric projection space (2:1 ratio)
    vec2 isoCoord;
    isoCoord.x = st.x - st.y * 1.732; // 1.732 approx sqrt(3)
    isoCoord.y = st.x + st.y * 1.732;

    // Scale grid tiles
    vec2 gridScale = isoCoord * 12.0;
    vec2 tileID = floor(gridScale);
    vec2 tileUV = fract(gridScale);

    // Calculate a fake height/bevel profile for isometric blocks
    float height = sin(tileID.x * 0.5) * cos(tileID.y * 0.5) * 0.3 + 0.5;
    
    // Compute surface normal (flat top with sloped edges)
    vec3 normal = vec3(0.0, 0.0, 1.0);
    float edgeDist = min(min(tileUV.x, 1.0 - tileUV.x), min(tileUV.y, 1.0 - tileUV.y));
    
    if (edgeDist < 0.15) {
        // Sloped bevel edge toward tile center
        vec2 d = tileUV - 0.5;
        normal = normalize(vec3(d.x, d.y, 0.5));
    }

    // Light direction (from top / slightly forward)
    vec3 lightDir = normalize(u_lightDir);

    // Lambertian Diffuse Lighting (N · L)
    float diffuse = max(dot(normal, lightDir), 0.0);
    
    // Ambient light so shadows aren't pitch black
    float ambient = 0.25;
    float lightIntensity = ambient + diffuse * 0.75;

    // Base color tint for isometric ground
    vec3 baseColor = vec3(0.2, 0.45, 0.65);

    // Apply color and vertex alpha tint
    vec3 finalColor = baseColor * lightIntensity;
    gl_FragColor = vec4(finalColor, 1.0) * v_vColour;
}