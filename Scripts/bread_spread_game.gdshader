shader_type canvas_item;
uniform vec4 og_color : source_color = vec4(0.0,0.0,0.0,0.0);
uniform vec4 new_color : source_color;
uniform float percent = 0.0;
uniform bool horizontal = true;
void fragment() {
	if (UV.x < percent && COLOR.a != 0.0) {
		COLOR = new_color;
	} else {
		if (COLOR.a != 0.0){
			COLOR = og_color;
		}
	}
}
