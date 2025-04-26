local panthera = require("panthera.panthera")

local M = {}

function M.get_examples()
	return {
		{
			name_id = "ui_example_panthera_basic_animation",
			information_text_id = "ui_example_panthera_basic_animation_description",
			template = "basic_animation",
			root = "basic_animation/root",
			code_url = "example/examples/panthera/basic_animation/basic_animation.lua",
			widget_class = require("example.examples.panthera.basic_animation.basic_animation"),
		},
		{
			name_id = "ui_example_panthera_animation_blend",
			information_text_id = "ui_example_panthera_animation_blend_description",
			template = "animation_blend",
			root = "animation_blend/root",
			code_url = "example/examples/panthera/animation_blend/animation_blend.lua",
			widget_class = require("example.examples.panthera.animation_blend.animation_blend"),
		}
	}
end

return M
