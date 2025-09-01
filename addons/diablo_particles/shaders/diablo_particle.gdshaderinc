uniform float color_boost = 1.0;
uniform float alpha_boost = 1.0;

uniform sampler2D tex1 : source_color, filter_linear_mipmap, repeat_enable;
uniform float scale1;
uniform vec2 speed1;

uniform sampler2D tex2 : source_color, filter_linear_mipmap, repeat_enable;
uniform float scale2;
uniform vec2 speed2;

uniform sampler2D tex3 : source_color, filter_linear_mipmap, repeat_enable;
uniform float scale3;
uniform vec2 speed3;

uniform sampler2D tex4 : source_color, filter_linear_mipmap, repeat_enable;
uniform float scale4;
uniform vec2 speed4;

varying vec2 uv1;
varying vec2 uv2;
varying vec2 uv3;
varying vec2 uv4;

varying float lifetime;

void vertex() {
	// Requires ParticleProcessMaterial anim_offset is [0, 1].
	float random = INSTANCE_CUSTOM.z;
	
	// -- UV panning --

	// TODO: Consider exposing speed range.
	const float SPEED_RANGE = 1.0;
	float speed_factor = 1.0 - 0.5 * SPEED_RANGE + SPEED_RANGE * random;
	// TODO: Consider randomizing UV panning speed per texture.
	vec2 rand_speed1 = speed1 * speed_factor;
	vec2 rand_speed2 = speed2 * speed_factor;
	vec2 rand_speed3 = speed3 * speed_factor;
	vec2 rand_speed4 = speed4 * speed_factor;

	vec2 offset1 = vec2(0.0, 0.0);
	vec2 offset2 = vec2(0.0, 0.0);
	vec2 offset3 = vec2(0.0, 0.0);
	vec2 offset4 = vec2(0.0, 0.0);
	if (speed1.x != 0.0 || speed1.y != 0.0) {
		offset1 = random * 12.3456 * vec2(1.0, 1.0);
	}
	if (speed2.x != 0.0 || speed2.y != 0.0) {
		offset2 = random * 23.4567 * vec2(1.0, 1.0);
	}
	if (speed3.x != 0.0 || speed3.y != 0.0) {
		offset3 = random * 34.5678 * vec2(1.0, 1.0);
	}
	if (speed4.x != 0.0 || speed4.y != 0.0) {
		offset4 = random * 45.6789 * vec2(1.0, 1.0);
	}

	uv1 = scale1 * (UV + rand_speed1 * TIME) + offset1;
	uv2 = scale2 * (UV + rand_speed2 * TIME) + offset2;
	uv3 = scale3 * (UV + rand_speed3 * TIME) + offset3;
	uv4 = scale4 * (UV + rand_speed4 * TIME) + offset4;
	
	// -- Vertex position --

	// Billboard Mode: Particles
	mat4 mat_world = mat4(
			normalize(MAIN_CAM_INV_VIEW_MATRIX[0]),
			normalize(MAIN_CAM_INV_VIEW_MATRIX[1]),
			normalize(MAIN_CAM_INV_VIEW_MATRIX[2]),
			MODEL_MATRIX[3]);
	mat_world = mat_world * mat4(
			vec4(cos(INSTANCE_CUSTOM.x), -sin(INSTANCE_CUSTOM.x), 0.0, 0.0),
			vec4(sin(INSTANCE_CUSTOM.x), cos(INSTANCE_CUSTOM.x), 0.0, 0.0),
			vec4(0.0, 0.0, 1.0, 0.0),
			vec4(0.0, 0.0, 0.0, 1.0));
	MODELVIEW_MATRIX = VIEW_MATRIX * mat_world;

	// Billboard Keep Scale: Enabled
	MODELVIEW_MATRIX = MODELVIEW_MATRIX * mat4(
			vec4(length(MODEL_MATRIX[0].xyz), 0.0, 0.0, 0.0),
			vec4(0.0, length(MODEL_MATRIX[1].xyz), 0.0, 0.0),
			vec4(0.0, 0.0, length(MODEL_MATRIX[2].xyz), 0.0),
			vec4(0.0, 0.0, 0.0, 1.0));

	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
	
	lifetime = INSTANCE_CUSTOM.y;
}
