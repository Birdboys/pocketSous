shader_type canvas_item;
uniform vec4 food_color : source_color;
uniform bool doing;
void fragment() {
	if (COLOR == vec4(1.0,1.0,1.0,1.0)) {
		COLOR = food_color;
	}
	// Place fragment code here.
}
