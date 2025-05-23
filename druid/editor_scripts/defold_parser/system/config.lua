local M = {}

-- Define a set of keys that should not have quotes
M.string_keys = {
	text = true,
	id = true,
	value = true,
	rename_patterns = true,
}


M.ALWAYS_LIST = {
	attributes = true,
	nodes = true,
	images = true,
	children = true,
	fonts = true,
	layers = true,
	textures = true,
	embedded_components = true,
	embedded_instances = true,
	collection_instances = true,
	instances = true,
}


M.with_dot_params = {
	"x",
	"y",
	"z",
	"w",
	"alpha",
	"outline_alpha",
	"shadow_alpha",
	"text_leading",
	"text_tracking",
	"pieFillAngle",
	"innerRadius",
	"leading",
	"tracking",
	"data",
	"t_x",
	"t_y",
	"spread",
	"start_delay",
	"inherit_velocity",
	"start_delay_spread",
	"duration_spread",
	"start_offset",
	"outline_width",
	"shadow_x",
	"shadow_y",
	"aspect_ratio",
	"far_z",
	"mass",
	"linear_damping",
	"angular_damping",
	"gain",
	"pan",
	"speed",
	"duration"
}

M.KEY_ORDER = {
	["font"] = {
		"extrude_borders",
		"images",
		"inner_padding",
		"margin",
		"font",
		"material",
		"size",
		"antialias",
		"alpha",
		"outline_alpha",
		"outline_width",
		"shadow_alpha",
		"shadow_blur",
		"shadow_x",
		"shadow_y",
		"extra_characters",
		"output_format",
		"all_chars",
		"cache_width",
		"cache_height",
		"render_mode",
	},
	["atlas"] = {
		"id",
		"images",
		"playback",
		"fps",
		"flip_horizontal",
		"flip_vertical",
		"image",
		"sprite_trim_mode",
		"images",
		"animations",
		"margin",
		"extrude_borders",
		"inner_padding",
		"max_page_width",
		"max_page_height",
		"rename_patterns",
	},
	["gui"] = {
		"position",
		"rotation",
		"scale",
		"size",
		"color",
		"type",
		"blend_mode",
		"text",
		"texture",
		"font",
		"id",
		"xanchor",
		"yanchor",
		"pivot",
		"outline",
		"shadow",
		"adjust_mode",
		"line_break",
		"parent",
		"layer",
		"inherit_alpha",
		"slice9",
		"outerBounds",
		"innerRadius",
		"perimeterVertices",
		"pieFillAngle",
		"clipping_mode",
		"clipping_visible",
		"clipping_inverted",
		"alpha",
		"outline_alpha",
		"shadow_alpha",
		"overridden_fields",
		"template",
		"template_node_child",
		"text_leading",
		"text_tracking",
		"size_mode",
		"spine_scene",
		"spine_default_animation",
		"spine_skin",
		"spine_node_child",
		"particlefx",
		"custom_type",
		"enabled",
		"visible",

		-- Scene
		"scripts",
		"fonts",
		"textures",
		"background_color",
		"nodes",
		"layers",
		"material",
		"layouts",
		"adjust_reference",
		"max_nodes",
		"spine_scenes",
		"particlefxs",
		"resources",
		"materials",
		"max_dynamic_textures",

		-- Vectors
		"x",
		"y",
		"z",
		"w",
	},
}

return M
