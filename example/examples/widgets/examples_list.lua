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
			widget_class = require("example.examples.widgets.hover_hint.hover_hint_example"),
		},
		{
			name_id = "ui_example_widget_properties_panel",
			information_text_id = "ui_example_widget_properties_panel_description",
			template = "properties_panel",
			root = "properties_panel/root",
			code_url = "example/examples/widgets/properties_panel/properties_panel.lua",
			widget_class = require("druid.widget.properties_panel.properties_panel"),
			on_create = function(instance, output_list)
				---@cast instance druid.widget.properties_panel

				instance:add_button(function(button)
					button:set_text_button("Button")
					button.button.on_click:subscribe(function()
						print("Button clicked")
					end)
				end)

				instance:add_checkbox(function(checkbox)
					--print("Checkbox clicked", value)
					checkbox:set_text_property("Checkbox")
					checkbox.on_change_value:subscribe(function(value)
						print("Checkbox clicked", value)
					end)
					checkbox:set_value(false)
				end)

				instance:add_input(function(input)
					input:set_text_property("Input")
					input:set_text_value("Initial")
					input:on_change(function(text)
						print("Input changed", text)
					end)
				end)

				instance:add_left_right_selector(function(selector)
					selector:set_template("Arrows Number")
					selector.on_change_value:subscribe(function(value)
						print("Left Right Selector changed", value)
					end)
					selector:set_number_type(0, 42, true, 1)
					selector:set_value(0)
				end)

				instance:add_left_right_selector(function(selector)
					selector:set_template("Arrows Array")
					selector.on_change_value:subscribe(function(value)
						print("Left Right Array value", value)
					end)
					selector:set_array_type({"Zero", "One", "Two", "Three", "Four", "Five"}, false, 1)
					selector:set_value("Zero")
				end)

				instance:add_slider(function(slider)
					slider:set_text_property("Slider")
					slider:set_value(0.5)
					slider:on_change(function(value)
						print("Slider changed", value)
					end)
				end)

				instance:add_text(function(text)
					text:set_text_property("Text")
					text:set_text_value("Hello, World!")
				end)
			end,
		},
		{
			name_id = "ui_example_widget_property_button",
			information_text_id = "ui_example_widget_property_button_description",
			template = "property_button",
			root = "property_button/root",
			code_url = "example/components/properties_panel/properties/property_button.lua",
			widget_class = require("example.components.properties_panel.properties.property_button"),
			on_create = function(instance, output_list)
				---@cast instance property_button
				instance.button.on_click:subscribe(function()
					output_list:add_log_text("Button clicked")
				end)
			end,
		},
		{
			name_id = "ui_example_widget_property_input",
			information_text_id = "ui_example_widget_property_input_description",
			template = "property_input",
			root = "property_input/root",
			code_url = "druid/widget/properties_panel/properties/property_input.lua",
			widget_class = require("druid.widget.properties_panel.properties.property_input"),
		},
		{
			name_id = "ui_example_widget_property_slider",
			information_text_id = "ui_example_widget_property_slider_description",
			template = "property_slider",
			root = "property_slider/root",
			code_url = "example/components/properties_panel/properties/property_slider.lua",
			widget_class = require("example.components.properties_panel.properties.property_slider"),
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
			widget_class = require("example.components.properties_panel.properties.property_checkbox"),
			on_create = function(instance, output_list)
				---@cast instance property_checkbox
				instance.button.on_click:subscribe(function()
					output_list:add_log_text("Checkbox clicked")
				end)
			end,
		},
		{
			name_id = "ui_example_widget_memory_panel",
			information_text_id = "ui_example_widget_memory_panel_description",
			template = "memory_panel",
			root = "memory_panel/root",
			code_url = "druid.widget.memory_panel.memory_panel.lua",
			widget_class = require("druid.widget.memory_panel.memory_panel"),
			on_create = function(instance, output_list)
				---@cast instance druid.widget.memory_panel
				print("Memory panel created")
			end,
		},
		{
			name_id = "ui_example_widget_fps_panel",
			information_text_id = "ui_example_widget_fps_panel_description",
			template = "fps_panel",
			root = "fps_panel/root",
			code_url = "druid.widget.fps_panel.fps_panel.lua",
			widget_class = require("druid.widget.fps_panel.fps_panel"),
			on_create = function(instance, output_list)
				---@cast instance druid.widget.fps_panel
				print("FPS panel created")
			end,
		},
		{
			name_id = "ui_example_widget_mini_graph",
			information_text_id = "ui_example_widget_mini_graph_description",
			template = "mini_graph",
			root = "mini_graph/root",
			code_url = "druid.widget.mini_graph.mini_graph.lua",
			widget_class = require("druid.widget.mini_graph.mini_graph"),
			on_create = function(instance, output_list)
				---@cast instance druid.widget.mini_graph
				instance:set_samples(50)
			end,
			properties_control = function(instance, properties_panel)
				---@cast instance druid.widget.mini_graph
				properties_panel:add_slider("value", 0.5, function(value)
					-- Remap to -1, 2
					value = value * 3 - 1
					for index = 1, 50 do
						-- Take value each 0.1 step, the higher value at argument value
						local x = index * (1 / 50)
						local distance = math.abs(x - value)
						local line_v = 1 - distance^2

						instance:set_line_value(index, line_v)
					end
				end)
			end,
		},
		{
			name_id = "ui_example_widget_tiling_node",
			information_text_id = "ui_example_widget_tiling_node_description",
			template = "example_tiling_node",
			root = "example_tiling_node/root",
			code_url = "example/examples/widgets/tiling_node/example_tiling_node.lua",
			widget_class = require("example.examples.widgets.tiling_node.example_tiling_node"),
		}
	}
end

return M
