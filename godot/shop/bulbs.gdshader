shader_type canvas_item;

uniform vec2 size = vec2(512.0, 96.0); // size of the Bulbs node in pixels
uniform float inset = 5.0;   // distance of the dots from the edge
uniform float spacing = 18.0; // distance between dots
uniform float radius = 3.0;   // dot size
uniform float speed = 3.0;    // swaps per second
uniform bool flash = false;   // false: alternate blinking, true: all dots flash together
uniform vec4 on_color : source_color = vec4(1.0, 0.855, 0.439, 1.0);   // #ffda70
uniform vec4 off_color : source_color = vec4(0.408, 0.235, 0.204, 1.0); // #683c34

void fragment() {
	// Fit the dots evenly into the area inside the inset.
	vec2 area = size - 2.0 * inset;
	vec2 count = max(round(area / spacing), vec2(1.0));
	vec2 gap = area / count;

	// Find the nearest dot and check that it lies on the edge.
	vec2 pos = UV * size - inset;
	vec2 cell = clamp(round(pos / gap), vec2(0.0), count);
	bool on_edge = cell.x == 0.0 || cell.y == 0.0 || cell.x == count.x || cell.y == count.y;

	// Draw a round dot.
	float circle = 1.0 - smoothstep(radius - 1.0, radius, distance(pos, cell * gap));

	// Blink: every second dot is lit. Flash: all dots share the same state.
	float offset = (cell.x + cell.y) * float(!flash);
	float lit = mod(offset + floor(TIME * speed), 2.0);

	COLOR = mix(off_color, on_color, lit);
	COLOR.a = circle * float(on_edge);
}