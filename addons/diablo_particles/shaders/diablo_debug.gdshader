shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, unshaded;

#include "res://addons/diablo_particles/shaders/diablo_particle.gdshaderinc"

void fragment() {
	ALBEDO = vec3(1.0, 1.0, 1.0);
	ALPHA = 0.1;
}
