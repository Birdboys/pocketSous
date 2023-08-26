shader_type canvas_item;
uniform vec3 color : source_color;
uniform float percent;
//const float speed_scale = 0.25;
//const float wiggle_scale = 5.0;
void fragment() {
	if (UV.y > 1.0 - percent/100.0) {
		COLOR.xyz = color;
	} else {
		COLOR.a = 0.0;
	}
}

void vertex() {
	if (UV.y < 1.0) {
		//VERTEX.y += sin((VERTEX.x + TIME)*2.0) * 32.0;
	}
}