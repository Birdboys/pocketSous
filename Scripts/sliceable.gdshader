shader_type canvas_item;
uniform float percent;
uniform bool cut;
uniform float cut_time;
uniform bool horizontal;
void fragment() {
	if (horizontal){
		if (UV.y < percent) {
			if (UV.y/percent < cut_time) {
				COLOR.a = 0.0;
			} 
		}
	} else {
		if (UV.x < percent) {
			if (UV.x/percent < cut_time) {
				COLOR.a = 0.0;
			} 
		}
	}
}