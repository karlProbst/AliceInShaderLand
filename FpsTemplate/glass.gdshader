shader_type spatial;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D HINT_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float distortion_size = 0.4;
uniform sampler2D glass;

void fragment() {
    vec2 d = texture(glass, UV).xy;
    vec4 rgba = texture(glass, UV);
    vec4 screen_sample = texture(SCREEN_TEXTURE, SCREEN_UV + d * distortion_size);
    vec4 hint_color = texture(HINT_TEXTURE, SCREEN_UV);


	vec3 rgbb= rgba.rgb;
	rgbb.r/=2.0;

    ALPHA=hint_color.a*(distortion_size/20.0);
	
    ALBEDO = screen_sample.rgb+(rgbb+rgba.a); // Use both colors in some way
}
