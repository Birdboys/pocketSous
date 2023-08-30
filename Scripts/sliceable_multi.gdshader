shader_type canvas_item;
uniform float percent;
uniform bool horizontal;
void fragment() {
	if (horizontal){
		if ((1.0-UV.y) > percent) {
			COLOR.a = 0.0;
		}
	} else {
		if ((1.0-UV.x) > percent) {
			COLOR.a = 0.0;
		}
	}
}