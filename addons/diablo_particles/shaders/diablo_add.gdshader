shader_type spatial;
render_mode blend_add, depth_draw_opaque, cull_back, unshaded;

#include "res://addons/diablo_particles/shaders/diablo_particle.gdshaderinc"

void fragment() {
	vec4 sample1 = texture(tex1, uv1);
	vec4 sample2 = texture(tex2, uv2);
	vec4 sample3 = texture(tex3, uv3);
	vec4 sample4 = texture(tex4, uv4);
	ALBEDO = sample1.rgb * sample2.rgb * sample3.rgb * sample4.rgb * color_boost * COLOR.rgb;
	ALPHA = sample1.a * sample2.a * sample3.a * sample4.a * alpha_boost * COLOR.a;
}
