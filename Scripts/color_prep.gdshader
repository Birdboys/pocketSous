shader_type canvas_item;
uniform vec4 color : source_color;
uniform bool set_color;
void fragment() {
	if (set_color){
		COLOR = COLOR * color;
	}
}
