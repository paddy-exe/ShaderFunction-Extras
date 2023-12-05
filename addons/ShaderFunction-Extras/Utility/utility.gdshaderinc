vec4 depth_camera_vulkan(sampler2D depth_tex, vec2 screen_uv, mat4 inv_proj_mat) {
	vec4 depth = texture(depth_tex, screen_uv);
	return inv_proj_mat * vec4(screen_uv * 2.0 - 1.0, depth.x, 1.0);
}

vec4 depth_camera_gles(sampler2D depth_tex, vec2 screen_uv, mat4 inv_proj_mat) {
	vec4 depth = texture(depth_tex, screen_uv);
	return inv_proj_mat * vec4(vec3(screen_uv, depth.x) * 2.0 - 1.0, 1.0);
}

vec4 depth_vertex_vulkan(sampler2D depth_tex, vec2 screen_uv, mat4 inv_proj_mat) {
	vec4 depth_world_pos = depth_camera_vulkan(depth_tex, screen_uv, inv_proj_mat);
	depth_world_pos.xyz /= depth_world_pos.w;
	return depth_world_pos;
}

vec4 depth_vertex_gles(sampler2D depth_tex, vec2 screen_uv, mat4 inv_proj_mat) {
	vec4 depth_world_pos = depth_camera_gles(depth_tex, screen_uv, inv_proj_mat);
	depth_world_pos.xyz /= depth_world_pos.w;
	return depth_world_pos;
}

float linear_scene_depth_vulkan(sampler2D depth_tex, vec2 screen_uv, mat4 inv_proj_mat) {
	vec4 depth_world_pos = depth_vertex_vulkan(depth_tex, screen_uv, inv_proj_mat);
	return -depth_world_pos.z;
}

float linear_scene_depth_gles(sampler2D depth_tex, vec2 screen_uv, mat4 inv_proj_mat) {
	vec4 depth_world_pos = depth_vertex_gles(depth_tex, screen_uv, inv_proj_mat);
	return -depth_world_pos.z;
}

float distance_fade(float min_dist, float max_dist, vec3 vertex) {
	return clamp(smoothstep(min_dist, max_dist, -vertex.z), 0.0, 1.0);
}

float proximity_camera_fade_vulkan(sampler2D depth_tex, vec2 screen_uv, mat4 inv_proj_mat, vec3 vertex, float fade_dist) {
	vec4 depth_world_pos = depth_camera_vulkan(depth_tex, screen_uv, inv_proj_mat);
	return clamp(1.0 - smoothstep(depth_world_pos.z + fade_dist, depth_world_pos.z, vertex.z), 0.0, 1.0);
}

float proximity_camera_fade_gles(sampler2D depth_tex, vec2 screen_uv, mat4 inv_proj_mat, vec3 vertex, float fade_dist) {
	vec4 depth_world_pos = depth_camera_gles(depth_tex, screen_uv, inv_proj_mat);
	return clamp(1.0 - smoothstep(depth_world_pos.z + fade_dist, depth_world_pos.z, vertex.z), 0.0, 1.0);
}

float proximity_vertex_fade_vulkan(sampler2D depth_tex, vec2 screen_uv, mat4 inv_proj_mat, vec3 vertex, float fade_dist) {
	vec4 depth_world_pos = depth_vertex_vulkan(depth_tex, screen_uv, inv_proj_mat);
	return clamp(1.0 - smoothstep(depth_world_pos.z + fade_dist, depth_world_pos.z, vertex.z), 0.0, 1.0);
}

float proximity_vertex_fade_gles(sampler2D depth_tex, vec2 screen_uv, mat4 inv_proj_mat, vec3 vertex, float fade_dist) {
	vec4 depth_world_pos = depth_vertex_gles(depth_tex, screen_uv, inv_proj_mat);
	return clamp(1.0 - smoothstep(depth_world_pos.z + fade_dist, depth_world_pos.z, vertex.z), 0.0, 1.0);
}

vec3 world_position_from_depth_vulkan(sampler2D depth_tex, vec2 screen_uv, mat4 inv_proj_mat, mat4 inv_view_mat) {
	vec4 depth_world_pos = depth_vertex_vulkan(depth_tex, screen_uv, inv_proj_mat);
	return (inv_view_mat * depth_world_pos).xyz;
}

vec3 world_position_from_depth_gles(sampler2D depth_tex, vec2 screen_uv, mat4 inv_proj_mat, mat4 inv_view_mat) {
	vec4 depth_world_pos = depth_vertex_gles(depth_tex, screen_uv, inv_proj_mat);
	return (inv_view_mat * depth_world_pos).xyz;
}

vec3 screen_normal_world_space(sampler2D normal_rough_tex, vec2 screen_uv, mat4 inv_view_mat) {
	vec3 normals = texture(normal_rough_tex, screen_uv).xyz;
	return mat3(inv_view_mat) * (normals * 2.0 - 1.0);
}

mat4 rotation_matrix_by_axis(float angle, vec3 axis) {
	vec3 n_axis = normalize(axis);
	mat3 rot_matrix = mat3(
		vec3(
			cos(angle) + n_axis.x * n_axis.x * (1.0 - cos(angle)),
			n_axis.x * n_axis.y * (1.0 - cos(angle)) - n_axis.z * sin(angle),
			n_axis.x * n_axis.z * (1.0 - cos(angle)) + n_axis.y * sin(angle)
		),
		vec3(
			n_axis.y * n_axis.x * (1.0 - cos(angle)) + n_axis.z * sin(angle),
			cos(angle) + n_axis.y * n_axis.y * (1.0 - cos(angle)),
			n_axis.y * n_axis.z * (1.0 - cos(angle)) - n_axis.x * sin(angle)
		),
		vec3(
			n_axis.z * n_axis.x * (1.0 - cos(angle)) - n_axis.y * sin(angle),
			n_axis.z * n_axis.y * (1.0 - cos(angle)) + n_axis.x * sin(angle),
			cos(angle) + n_axis.z * n_axis.z * (1.0 - cos(angle))
		)
	);
	return mat4(rot_matrix);
}

vec3 rotate_by_axis(vec3 input, float angle, vec3 axis) {
	return input * mat3(rotation_matrix_by_axis(angle, axis));
}

// 3D Noise with friendly permission by Inigo Quilez\n";
vec3 hash_noise_range(vec3 p) {
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

float smooth_clamp(float value, float min, float max) {
	return smoothstep(0.0, 1.0, (value - min) / (max - min)) * (max - min) + min;
}

float soft_clamp(float value, float min, float max) {
	return smoothstep(0.0, 1.0, (2.0 / 3.0) * (value - min) / (max - min) + (1.0 / 6.0)) * (max - min) + min;
}

float saturate(float value, float scale) {
	return clamp(((value - 0.5) * scale) + 0.5, 0.0, 1.0);
}

vec3 vertex_billboard(vec2 uv, mat4 view_mat, vec3 vertex, float scale) {
	uv.x = remap(uv.x, 0.0, 1.0, -1.0, 1.0);
	uv.y = remap(uv.y, 0.0, 1.0, -1.0, 1.0);
	uv *= scale;
	return vertex + ((vec4(uv, 0.0, 0.0) * view_mat)).xyz;
}
