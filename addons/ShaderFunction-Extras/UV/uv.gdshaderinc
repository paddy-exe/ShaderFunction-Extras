vec2 uv_panning(vec2 uv, vec2 scale, vec2 offset) {
	return offset * scale + uv;
}

vec2 uv_scaling(vec2 uv, vec2 scale, vec2 pivot) {
	return (uv - pivot) * scale + pivot;
}

vec2 uv_polar_coord_canvas(vec2 uv, vec2 center, float zoom, float repeat) {
	vec2 dir = uv - center;
	float radius = length(dir) * 2.0;
	float angle = atan(dir.y, dir.x) * 1.0/(PI * 2.0);
	return mod(vec2(radius * zoom, angle * repeat), 1.0);
}

vec2 uv_polar_coord_spatial(vec2 uv, vec2 center, float zoom, float repeat) {
	vec2 dir = uv - center;
	float radius = length(dir) * 2.0;
	float angle = atan(dir.y, dir.x) * 1.0/(PI * 2.0);
	return vec2(radius * zoom, angle * repeat);
}
