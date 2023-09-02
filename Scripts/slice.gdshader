shader_type canvas_item;
uniform float start;
const float offset = 0.05;
void fragment() {
	if (UV.x > start && UV.x < start + offset) {
		COLOR.a = 0.05;
	} else {
		COLOR.a = 1.0;
	}
}
