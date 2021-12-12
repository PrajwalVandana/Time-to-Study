shader_type canvas_item;

uniform float radius = 1.0;

void fragment() {
	vec4 col = texture(TEXTURE, UV);
	vec2 pixel_size = TEXTURE_PIXEL_SIZE;

	col += texture(TEXTURE, UV + vec2(0.0, -radius) * pixel_size);
	col += texture(TEXTURE, UV + vec2(0.0, radius) * pixel_size);
	col += texture(TEXTURE, UV + vec2(-radius, 0.0) * pixel_size);
	col += texture(TEXTURE, UV + vec2(radius, 0.0) * pixel_size);
	col /= 5.0;

	COLOR = col;
}