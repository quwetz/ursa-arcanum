shader_type canvas_item;

uniform float alpha = 0.8;

void fragment() {
	vec4 prev_color = texture(TEXTURE, UV);
	vec4 red = vec4(1.0, 0.0, 0.0, alpha);
	COLOR = red;
}