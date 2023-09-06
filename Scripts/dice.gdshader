shader_type canvas_item;
uniform float dice_percent : hint_range(0.0, 1.0, 0.1) = 0.0;
void fragment() {
	float dist = distance(UV, vec2(0.5,0.5));
	if (dist > pow((1.0-dice_percent),2)) {
		COLOR.a = 0.0; 
	}
}
