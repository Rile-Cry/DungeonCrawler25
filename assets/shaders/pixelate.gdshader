shader_type spatial;
render_mode unshaded;

uniform sampler2D screen_texture : source_color, hint_screen_texture, filter_nearest;
uniform sampler2D depth_texture : source_color, hint_depth_texture, filter_nearest;

void vertex() {
	POSITION = vec4(VERTEX, 1.0);
}

void fragment() {
	vec3 original = texture(screen_texture, SCREEN_UV).rgb;
	ALBEDO = original;
}