shader_type canvas_item;

uniform float cell = 4.0;  // distance between holes, in pixels
uniform float hole = 1.5;  // radius of each hole, in pixels
uniform vec4 grille_color : source_color = vec4(0.0, 0.0, 0.0, 0.75);

void fragment() {
	vec2 pos = mod(FRAGCOORD.xy, cell) - cell * 0.5;
	COLOR = grille_color;
	COLOR.a *= step(hole, length(pos)); // transparent inside the hole
}