shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, unshaded;

uniform sampler2D depth_texture : hint_depth_texture, repeat_disable, filter_nearest;

#include "res://addons/diablo_particles/shaders/diablo_particle.gdshaderinc"

void fragment() {
	vec4 sample1 = texture(tex1, uv1);
	vec4 sample2 = texture(tex2, uv2);
	vec4 sample3 = texture(tex3, uv3);
	vec4 sample4 = texture(tex4, uv4);
	ALBEDO = sample1.rgb * sample2.rgb * sample3.rgb * sample4.rgb * color_boost * COLOR.rgb;
	ALPHA = sample1.a * sample2.a * sample3.a * sample4.a * alpha_boost * COLOR.a;
	
	// Proximity Fade: Enabled
	float proximity_depth_tex = textureLod(depth_texture, SCREEN_UV, 0.0).r;
	vec4 proximity_view_pos = INV_PROJECTION_MATRIX * vec4(SCREEN_UV * 2.0 - 1.0, proximity_depth_tex, 1.0);
	proximity_view_pos.xyz /= proximity_view_pos.w;
	float proximity_fade_distance = 0.2;
	ALPHA *= clamp(1.0 - smoothstep(proximity_view_pos.z + proximity_fade_distance, proximity_view_pos.z, VERTEX.z), 0.0, 1.0);
	
	// -- Lifetime-based alpha --
	// ALPHA = ALPHA * (1.0-lifetime);
	
	// -- Debug render --
	// TODO: Add a debug render mode toggle
	//ALBEDO = vec3(1,1,1);
	//ALPHA = 0.1;
}
