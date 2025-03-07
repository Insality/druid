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
			component_class = require("example.examples.panthera.basic_animation.basic_animation"),
		},
		{
			name_id = "ui_example_panthera_animation_blend",
			information_text_id = "ui_example_panthera_animation_blend_description",
			template = "animation_blend",
			root = "animation_blend/root",
			code_url = "example/examples/panthera/animation_blend/animation_blend.lua",
			component_class = require("example.examples.panthera.animation_blend.animation_blend"),
			properties_control = function(instance, properties_panel)
				---@cast instance examples.animation_blend
				local vertical_time = panthera.get_time(instance.animation_vertical)

				local vertical_slider = properties_panel:add_slider("ui_animation_vertical", vertical_time, function(value)
					panthera.set_time(instance.animation_vertical, "vertical", value)
				end)

				local horizontal_time = panthera.get_time(instance.animation_horizontal)

				local horizontal_slider = properties_panel:add_slider("ui_animation_horizontal", horizontal_time, function(value)
					panthera.set_time(instance.animation_horizontal, "horizontal", value)
				end)

				instance.on_update:subscribe(function()
					vertical_slider:set_value(panthera.get_time(instance.animation_vertical))
					horizontal_slider:set_value(panthera.get_time(instance.animation_horizontal))
				end)
			end,
		}
	}
end

return M
