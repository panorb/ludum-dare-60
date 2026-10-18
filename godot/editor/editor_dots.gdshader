shader_type canvas_item;

uniform vec4 bg_color : source_color = vec4(0.22, 0.0, 0.173, 1.0);
uniform vec4 dot_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float spacing = 32.0;
uniform float radius = 3.0;

varying vec2 local_pos;

void vertex() {
	local_pos = VERTEX;
}

void fragment() {
	vec2 cell = mod(local_pos, spacing) - spacing * 0.5;
	float dist = length(cell);
	float edge = fwidth(dist);
	float dot_mask = 1.0 - smoothstep(radius - edge, radius + edge, dist);
	COLOR = mix(bg_color, dot_color, dot_mask);
}