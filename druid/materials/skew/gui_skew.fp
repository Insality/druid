#version 140

uniform sampler2D texture_sampler;

in vec2 var_texcoord0;
in vec4 var_color;

out vec4 color_out;

void main() {
	lowp vec4 tex = texture(texture_sampler, var_texcoord0.xy);
	if (tex.a < 0.5) {
		discard;
	}

	// Final color of stencil texture
	color_out = tex * var_color;
}