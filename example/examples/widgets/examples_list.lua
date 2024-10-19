local M = {}

function M.get_examples()
	---@type druid.example.data[]
	return {
		{
			name_id = "ui_example_widget_hover_hint",
			information_text_id = "ui_example_widget_hover_hint_description",
			template = "hover_hint_example",
			root = "hover_hint_example/root",
			code_url = "example/examples/widgets/hover_hint/hover_hint_example.lua",
			component_class = require("example.examples.widgets.hover_hint.hover_hint_example"),
		},
		{
			name_id = "ui_example_widget_property_button",
			information_text_id = "ui_example_widget_property_button_description",
			template = "property_button",
			root = "property_button/root",
			code_url = "example/components/properties_panel/properties/property_button.lua",
			component_class = require("example.components.properties_panel.properties.property_button"),
			on_create = function(instance, output_list)
				---@cast instance property_button
				instance.button.on_click:subscribe(function()
					output_list:add_log_text("Button clicked")
				end)
			end,
		},
		{
			name_id = "ui_example_widget_property_slider",
			information_text_id = "ui_example_widget_property_slider_description",
			template = "property_slider",
			root = "property_slider/root",
			code_url = "example/components/properties_panel/properties/property_slider.lua",
			component_class = require("example.components.properties_panel.properties.property_slider"),
			on_create = function(instance, output_list)
				---@cast instance property_slider
				instance.slider.on_change_value:subscribe(function(_, value)
					output_list:add_log_text("Slider value: " .. value)
				end)
			end,
		},
		{
			name_id = "ui_example_widget_property_checkbox",
			information_text_id = "ui_example_widget_property_checkbox_description",
			template = "property_checkbox",
			root = "property_checkbox/root",
			code_url = "example/components/properties_panel/properties/property_checkbox.lua",
			component_class = require("example.components.properties_panel.properties.property_checkbox"),
			on_create = function(instance, output_list)
				---@cast instance property_checkbox
				instance.button.on_click:subscribe(function()
					output_list:add_log_text("Checkbox clicked")
				end)
			end,
		},
	}
end

return M