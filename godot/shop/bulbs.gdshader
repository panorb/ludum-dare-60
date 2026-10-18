shader_type canvas_item;

uniform vec2 size = vec2(512.0, 96.0); // size of the Bulbs node in pixels
uniform float inset = 5.0;    // distance of the dots from the edge
uniform float spacing = 18.0; // distance between dots
uniform float radius = 3.0;   // dot size
uniform float speed = 3.0;    // swaps per second
uniform int mode : hint_range(0, 4) = 0; // 0 blink, 1 flash, 2 all on, 3 all off, 4 disabled
uniform vec4 on_color : source_color = vec4(1.0, 0.855, 0.439, 1.0);   // #ffda70
uniform vec4 off_color : source_color = vec4(0.408, 0.235, 0.204, 1.0); // #683c34
uniform vec4 disabled_color : source_color = vec4(0.133, 0.165, 0.361, 1.0); // #222a5c

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

	// Decide whether this dot is lit.
	float tick = floor(TIME * speed);
	float lit = mod(cell.x + cell.y + tick, 2.0); // 0: blink, every second dot
	float disabled = 0.0;
	
	if (mode == 1) {
		lit = mod(tick, 2.0);                      // 1: flash, all dots together
	} else if (mode == 2) {
		lit = 1.0;                                 // 2: all on
	} else if (mode == 3) {
		lit = 0.0;                                 // 3: all off
	} else if (mode == 4) {
		disabled = 1.0;
	}

	COLOR = mix(mix(off_color, on_color, lit), disabled_color, disabled);
	COLOR.a = circle * float(on_edge);
}
