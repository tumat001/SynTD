shader_type canvas_item;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	COLOR.rbg = vec3(COLOR.r + COLOR.b + COLOR.g) / (3.0 * 4.0);
	
	//float new_col = 0.05;
	//COLOR.rgb = vec3(new_col);
}
