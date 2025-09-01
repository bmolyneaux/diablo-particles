shader_type canvas_item;

uniform float scale;
uniform vec2 speed;

varying vec2 uv;

void vertex() {
	uv = UV * scale + speed * TIME * scale * vec2(1,1);
}

void fragment() {
	COLOR = vec4(texture(TEXTURE, uv).rgb, 1);
}
