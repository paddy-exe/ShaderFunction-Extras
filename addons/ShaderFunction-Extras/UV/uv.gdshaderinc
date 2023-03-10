vec2 uv_panning(vec2 uv, vec2 scale, vec2 offset) {
	return offset * scale + uv;
}

vec2 uv_scaling(vec2 uv, vec2 scale, vec2 pivot) {
	return (uv - pivot) * scale + pivot;
}

vec2 uv_rotate(vec2 uv, vec2 pivot, float angle) {
	mat2 rotation = mat2(vec2(sin(angle), -cos(angle)), vec2(cos(angle), sin(angle)));
	uv -= pivot;
	uv = uv * rotation;
	uv += pivot;
	return uv;
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

vec2 uv_flipbook(vec2 uv, int columns, int rows, int starting_frame, int ending_frame, float anim_speed) {
	starting_frame += int(fract(TIME * anim_speed) * float(ending_frame));
	float frame = float(clamp(starting_frame, 0, ending_frame));
	vec2 offPerFrame = vec2((1.0 / float(columns)), (1.0 / float(rows)));

	vec2 sprite_size = vec2(uv.x / float(columns), uv.y / float(rows));
	vec2 current_sprite = vec2(0.0, 1.0 - offPerFrame.y);
	current_sprite.x += frame * offPerFrame.x;
	float rowIndex;
	float _mod = modf(frame / float(columns), rowIndex);
	current_sprite.y -= rowIndex * offPerFrame.y;
	current_sprite.x -= rowIndex * float(columns) * offPerFrame.x;

	vec2 sprite_uv = (sprite_size + current_sprite);

	return sprite_uv;
}

vec2 uv_twirl(vec2 uv, vec2 center, float strength, vec2 offset) {
	vec2 __delta = uv - center;
	float __angle = strength * length(__delta);
	float __x = cos(__angle) * __delta.x - sin(__angle) * __delta.y;
	float __y = sin(__angle) * __delta.x + cos(__angle) * __delta.y;
	return vec2(__x + center.x + offset.x, __y + center.y + offset.y);
}

vec2 uv_grid_tiler(vec2 uv, float columns, float rows) {
	return fract(vec2(uv.x * columns, uv.y * rows));
}
