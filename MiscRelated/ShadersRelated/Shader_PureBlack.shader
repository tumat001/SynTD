shader_type canvas_item;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	float new_col = 0.0;
	COLOR.rgb = vec3(new_col);
}
