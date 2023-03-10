float linear_scene_depth_vulkan(sampler2D depth_tex, vec2 screen_uv, mat4 inv_proj_mat) {
	float log_depth = texture(depth_tex, screen_uv).x;
	vec4 depth_world_pos = inv_proj_mat * vec4(vec3(screen_uv, log_depth) * 2.0 - 1.0, 1.0);
	depth_world_pos.xyz /= depth_world_pos.w;
	return -depth_world_pos.z;
}

float linear_scene_depth_gles(sampler2D depth_tex, vec2 screen_uv, mat4 inv_proj_mat) {
	float log_depth = texture(depth_tex, screen_uv).x;
	vec4 depth_world_pos = inv_proj_mat * vec4(screen_uv * 2.0 - 1.0, log_depth, 1.0);
	depth_world_pos.xyz /= depth_world_pos.w;
	return -depth_world_pos.z;
}

float distance_fade(float min_dist, float max_dist, vec3 vertex) {
	return clamp(smoothstep(min_dist, max_dist,-vertex.z),0.0,1.0);
}

float proximity_fade_vulkan(sampler2D depth_tex, vec2 screen_uv, mat4 inv_proj_mat, vec3 vertex, float fade_dist) {
	float log_depth = texture(depth_tex, screen_uv).x;
	vec4 depth_world_pos = inv_proj_mat * vec4(vec3(screen_uv, log_depth) * 2.0 - 1.0, 1.0);
	return clamp(1.0 - smoothstep(depth_world_pos.z + fade_dist, depth_world_pos.z, vertex.z), 0.0, 1.0);
}

float proximity_fade_gles(sampler2D depth_tex, vec2 screen_uv, mat4 inv_proj_mat, vec3 vertex, float fade_dist) {
	float log_depth = texture(depth_tex, screen_uv).x;
	vec4 depth_world_pos = inv_proj_mat * vec4(screen_uv * 2.0 - 1.0, log_depth, 1.0);
	return clamp(1.0 - smoothstep(depth_world_pos.z + fade_dist, depth_world_pos.z, vertex.z), 0.0, 1.0);
}

// 3D Noise with friendly permission by Inigo Quilez\n";
vec3 hash_noise_range( vec3 p ) {
	p *= mat3(vec3(127.1, 311.7, -53.7), vec3(269.5, 183.3, 77.1), vec3(-301.7, 27.3, 215.3));
	return 2.0 * fract(fract(p)*4375.55) -1.;
}

float random_range(vec3 seed, float min, float max) {
	return mix(min, max, hash_noise_range(seed).x);
}

float remap(float value, float input_min, float input_max, float output_min, float output_max) {
	float _input_range = input_max - input_min;
	float _output_range = output_max - output_min;
	return output_min + _output_range * ((value - input_min) / _input_range);
}

float fresnel(float amount, vec3 normal, vec3 view) {
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}

vec3 fresnel_glow(float amount, float intensity, vec3 color, vec3 normal, vec3 view) {
	return pow((1.0 - dot(normalize(normal), normalize(view))), amount) * color * intensity;
}
