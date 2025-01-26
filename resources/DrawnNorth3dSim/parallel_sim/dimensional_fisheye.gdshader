shader_type canvas_item;

uniform float strength : hint_range(0.0, 1.0) = 0.5; // Controls the strength of the effect

void fragment() {
    vec2 uv = FRAGCOORD.xy / vec2(TEXTURE_PIXEL_SIZE.x, TEXTURE_PIXEL_SIZE.y);
    vec2 center = vec2(0.5, 0.5); // Center of the texture
    vec2 offset = uv - center; // Offset from the center
    float dist = length(offset); // Distance from the center

    // Fisheye effect formula
    float factor = 1.0 - (dist * strength);
    uv = center + offset * factor; // Apply distortion

    // Sample the texture
    vec4 color = texture(TEXTURE, uv);
    COLOR = color;
}
