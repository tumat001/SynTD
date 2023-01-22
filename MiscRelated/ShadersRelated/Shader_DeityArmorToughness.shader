shader_type canvas_item;

uniform float blob_threshold = 1.0;

uniform vec4 background_edge: hint_color = vec4(1.0, 0, 0.6, 0.0);
uniform vec4 background_center: hint_color = vec4(0.4, 0, 1.0, 0.0);

uniform vec4 blob_top: hint_color = vec4(0.1, 0, 0.85, 0.4);
uniform vec4 blob_bottom: hint_color = vec4(0.85, 0.32, 0, 0.4);


float oscillate(float x, float offset, float speed) {
	return pow(sin(speed * x + offset), 2);
}

void fragment() {
	// color each fragment the Sprite covers black
	vec4 background_color_here = vec4(0, 0, 0, 0); //mix(background_edge, background_center, abs(0.5 - UV.x));
	//COLOR = background_color_here;
	// declare the blob_centers as
	// a changing array of vec3s
	// with length 2 (2 elements)
	vec3 blob_centers[6];
	// define the blob centers
	// we start counting at 0
	blob_centers[0] = vec3(0.5, oscillate(TIME, 0.2, 0.2), 2.0);
	blob_centers[1] = vec3(0.4, oscillate(TIME, 0.5, 0.1), 1.0);
	blob_centers[2] = vec3(0.6, oscillate(TIME, 0.3, 0.3), 3.0);
	blob_centers[3] = vec3(0.4, oscillate(TIME, 0.1, 0.1), 2.0);
	blob_centers[4] = vec3(0.5, oscillate(TIME, 0.4, 0.1), 5.0);
	blob_centers[5] = vec3(0.6, oscillate(TIME, 0.3, 0.2), 3.0);
	// start counting influence at 0
	float influence = 0.0;
	// for each of the blobs, we add some influence based on how close
	// this point is to each blob
	for (int i = 0; i < blob_centers.length(); i++) {
		// TODO: explain each of these variables
		float distance_to_blob_center = distance(blob_centers[i].xy / TEXTURE_PIXEL_SIZE, UV / TEXTURE_PIXEL_SIZE);
		influence += blob_centers[i].z * (1.0 / distance_to_blob_center);
	}
	// if influence is larger than a certain threshold, set the color at this
	// point to the gradient
	COLOR = mix(background_color_here, mix(blob_top, blob_bottom, UV.y), pow(influence, 6));
	if (influence > blob_threshold) {
		COLOR = mix(blob_top, blob_bottom, UV.y);
		COLOR = vec4(COLOR.r, COLOR.g, COLOR.b, 0.3);
		//COLOR = vec4(blob_top.r, blob_top.g, blob_top.b, 0.3)
	}
	
}






