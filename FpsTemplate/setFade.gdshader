shader_type canvas_item;

uniform float time : hint_range(0.0, 10.0);

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    float alpha = clamp(time / 10.0, 0.0, 1.0);  // Normalize time to range [0, 1] over 10 seconds
    tex_color.a *= alpha;
    COLOR = tex_color;
}
