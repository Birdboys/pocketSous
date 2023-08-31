shader_type canvas_item;
uniform vec4 color : source_color;
uniform sampler2D bg : repeat_enable;
uniform float speed = 3.0;
uniform float direction_x;
uniform float direction_y;
void fragment() {
	vec2 bg_texture_size = vec2(textureSize(bg, 0));
	vec2 pixel_pos = FRAGCOORD.xy;
	vec2 relative_uv = vec2(pixel_pos.x/bg_texture_size.x,pixel_pos.y/bg_texture_size.y);
    relative_uv.x += TIME / speed * direction_x;
	relative_uv.y += TIME / speed * direction_y;
    vec4 c = texture(bg, relative_uv);
	if (length(c-vec4(1.0,1.0,1.0,1.0)) < 0.01) {
		COLOR = color;
	} else {
		COLOR = vec4(1.0,1.0,1.0,0.0);
	}
}
