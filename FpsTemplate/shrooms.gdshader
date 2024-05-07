shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform vec2 screen_size;

uniform float blur_radius : hint_range(0, 1) = 0.2; // Radius of the blur effect
uniform float blur_amount : hint_range(0, 5) = 1.0; // Strength of the blur effect
uniform float blur_inner : hint_range(0, 1) = 0.6; // Inner edge of the blur effect
uniform float blur_outer : hint_range(0, 1) = 0.66; // Outer edge of the blur effect

void fragment() {
    // Calculate UV coordinates by flipping the y-axis
    vec2 uv = vec2(FRAGCOORD.x / screen_size.x, 1.0 - FRAGCOORD.y / screen_size.y);

    // Sample the screen texture using correct UV coordinates
    vec4 pixelColor = texture(SCREEN_TEXTURE, uv);

    // Calculate distance from the center of the screen
    float distance = length(FRAGCOORD.xy / screen_size - vec2(0.5, 0.5));

    // Apply smoothstep function to control transition between areas
    float blur = smoothstep(blur_inner - blur_radius, blur_outer, distance);

    // Output the sampled color with the blur effect
    COLOR = mix(pixelColor, textureLod(SCREEN_TEXTURE, uv, blur_amount), blur);
}
