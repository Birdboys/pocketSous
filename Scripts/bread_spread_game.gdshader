shader_type canvas_item;
uniform vec4 og_color : source_color = vec4(0.0,0.0,0.0,0.0);
uniform vec4 new_color : source_color;
uniform float percent = 0.0;
uniform bool horizontal = true;
uniform int direction = 1;
void fragment() {
	float uv_val;
	if (horizontal) {
		uv_val = UV.x;
	} else {
		uv_val = UV.y;
	}
	if (direction < 0) {
		uv_val = 1.0-uv_val;
	}
	if (uv_val < percent && COLOR.a != 0.0) {
		COLOR = new_color;
	} else {
		if (COLOR.a != 0.0){
			COLOR = og_color;
		}
	}
}
