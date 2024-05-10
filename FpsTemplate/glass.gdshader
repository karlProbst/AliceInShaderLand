shader_type spatial;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D HINT_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float distortion_size = 0.4;
uniform sampler2D glass;

void fragment() {
    vec2 d = texture(glass, UV).xy * vec2(2.5);
    vec4 rgba = texture(glass, UV);
    vec4 screen_sample = texture(SCREEN_TEXTURE, SCREEN_UV + d * distortion_size);
    vec4 hint_color = texture(HINT_TEXTURE, SCREEN_UV);

  	screen_sample.r+=rgba.r;
	screen_sample.b+=rgba.b;
	screen_sample.g+=rgba.g;

    ALPHA=hint_color.a*distortion_size;
	
    ALBEDO = screen_sample.rgb; // Use both colors in some way
}
