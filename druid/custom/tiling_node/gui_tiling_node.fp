#version 140

uniform sampler2D texture_sampler;

in vec2 var_texcoord0;
in vec4 var_color;
in vec4 var_uv;
in vec4 var_repeat; // [repeat_x, repeat_y, anchor_x, anchor_y]
in vec4 var_params; // [margin_x, margin_y, offset_x, offset_y]
in vec4 var_uv_rotated;

out vec4 color_out;

void main() {
	vec2 pivot = var_repeat.zw;
	// Margin is a value between 0 and 1 that means offset/padding from the one image to another
	vec2 margin = var_params.xy;
	vec2 offset = var_params.zw;
	vec2 repeat = var_repeat.xy;

	// Atlas UV to local UV [0, 1]
	float u = (var_texcoord0.x - var_uv.x) / (var_uv.z - var_uv.x);
	float v = (var_texcoord0.y - var_uv.y) / (var_uv.w - var_uv.y);

	// Adjust local UV by the pivot point. So 0:0 will be at the pivot point of node
	u = u - (0.5 + pivot.x);
	v = v - (0.5 - pivot.y);

	// If rotated, swap UV
	if (var_uv_rotated.y < 0.5) {
		float temp = u;
		u = v;
		v = temp;
	}

	// Adjust repeat by the margin
	repeat.x = repeat.x / (1.0 + margin.x);
	repeat.y = repeat.y / (1.0 + margin.y);

	// Repeat is a value between 0 and 1 that represents the number of times the texture is repeated in the atlas.
	float tile_u = fract(u * repeat.x);
	float tile_v = fract(v * repeat.y);

	float tile_width = 1.0 / repeat.x;
	float tile_height = 1.0 / repeat.y;

	// Adjust tile UV by the pivot point.
	// Not center is left top corner, need to adjust it to pivot point
	tile_u = fract(tile_u + pivot.x + 0.5);
	tile_v = fract(tile_v - pivot.y + 0.5);

	// Apply offset
	tile_u = fract(tile_u + offset.x);
	tile_v = fract(tile_v + offset.y);

	// Extend margins
	margin = margin * 0.5;
	tile_u = mix(0.0 - margin.x, 1.0 + margin.x, tile_u);
	tile_v = mix(0.0 - margin.y, 1.0 + margin.y, tile_v);
	float alpha = 0.0;
	// If the tile is outside the margins, make it transparent, without IF
	alpha = step(0.0, tile_u) * step(tile_u, 1.0) * step(0.0, tile_v) * step(tile_v, 1.0);

	tile_u = clamp(tile_u, 0.0, 1.0); // Keep borders in the range 0-1
	tile_v = clamp(tile_v, 0.0, 1.0); // Keep borders in the range 0-1

	if (var_uv_rotated.y < 0.5) {
		float temp = tile_u;
		tile_u = tile_v;
		tile_v = temp;
	}

	// Remap local UV to the atlas UV
	vec2 uv = vec2(
		mix(var_uv.x, var_uv.z, tile_u), // Get texture coordinate from the atlas
		mix(var_uv.y, var_uv.w, tile_v) // Get texture coordinate from the atlas
		//mix(var_uv.x, var_uv.z, tile_u * var_uv_rotated.x + tile_v * var_uv_rotated.z),
		//mix(var_uv.y, var_uv.w, 1.0 - (tile_u * var_uv_rotated.y + tile_v * var_uv_rotated.x))
	);

	lowp vec4 tex = texture(texture_sampler, uv);
	color_out = tex * var_color;
}
