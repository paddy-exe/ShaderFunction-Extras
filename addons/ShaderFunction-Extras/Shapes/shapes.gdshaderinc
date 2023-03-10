float polygon(vec2 uv, float width, int sides) {
	uv = uv * 2.0 - 1.0;
	float angle = atan(uv.x, uv.y);
	float radius = 6.28318530718 / float(sides);
	float dist = cos(floor(0.5 + angle / radius) * radius - angle) * length(uv);
	return step(width, dist);
}

float circle(vec2 uv, float radius, float feather) {
	return smoothstep(radius, radius + feather, dot(position, position) * 4.0);
}

float square(vec2 uv, float width) {
	uv = uv * 2.0 - 1.0;
	vec2 abs_uv = abs(uv.xy);
	return step(width, max(abs_uv.x, abs_uv.y));
}

float square_stroke(vec2 uv, float width, float stroke_width) {
	uv = uv * 2.0 - 1.0;
	vec2 abs_uv = abs(uv.xy);
	float dist = max(abs_uv.x, abs_uv.y);
	return 1.0 - (step(width, dist) - step(width + stroke_width, dist));
}

float square_rounded(vec2 uv, float width, float radius) {
	uv = uv * 2.0 - 1.0;
	radius *= width;
	vec2 abs_uv = abs(uv.xy) - radius;
	vec2 dist = vec2(max(abs_uv.xy, 0.0));
	return step(width - radius, length(dist));
}

float swirl(vec2 uv, float size, int arms) {
	float angle = atan(-uv.y + 0.5, uv.x - 0.5);
	float len = length(uv - vec2(0.5, 0.5));
	return sin(len * size + angle * float(arms));
}

float line(vec2 uv, vec2 p1, vec2 p2, float width) {
	float dist = distance(p1, p2);
	float dist_uv = distance(p1, uv);
	return 1.0 - floor(1.0 - (0.001 * width) + distance (mix(p1, p2, clamp(dist_uv / dist, 0.0, 1.0)), uv));
}

float border(vec2 uv, float border_width) {
	vec2 bottom_left = step(vec2(border_width), uv);
	vec2 top_right = step(vec2(border_width), 1.0 - uv);
	return bottom_left.x * bottom_left.y * top_right.x * top_right.y;
}

