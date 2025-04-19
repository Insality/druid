local properties_panel = require("druid.widget.properties_panel.properties_panel")

---@class druid.widget.example_properties_panel: druid.widget
local M = {}


function M:init()
	self.properties_panel = self.druid:new_widget(properties_panel, "properties_panel")

	self.properties_panel:add_button(function(button)
		button:set_text_button("Button")
		button.button.on_click:subscribe(function()
			print("Button clicked")
		end)
	end)

	self.properties_panel:add_checkbox(function(checkbox)
		--print("Checkbox clicked", value)
		checkbox:set_text_property("Checkbox")
		checkbox.on_change_value:subscribe(function(value)
			print("Checkbox clicked", value)
		end)
		checkbox:set_value(false)
	end)

	self.properties_panel:add_input(function(input)
		input:set_text_property("Input")
		input:set_text_value("Initial")
		input:on_change(function(text)
			print("Input changed", text)
		end)
	end)

	self.properties_panel:add_left_right_selector(function(selector)
		selector:set_template("Arrows Number")
		selector.on_change_value:subscribe(function(value)
			print("Left Right Selector changed", value)
		end)
		selector:set_number_type(0, 42, true, 1)
		selector:set_value(0)
	end)

	self.properties_panel:add_left_right_selector(function(selector)
		selector:set_template("Arrows Array")
		selector.on_change_value:subscribe(function(value)
			print("Left Right Array value", value)
		end)
		selector:set_array_type({"Zero", "One", "Two", "Three", "Four", "Five"}, false, 1)
		selector:set_value("Zero")
	end)

	self.properties_panel:add_slider(function(slider)
		slider:set_text_property("Slider")
		slider:set_value(0.5)
		slider:on_change(function(value)
			print("Slider changed", value)
		end)
	end)

	self.properties_panel:add_text(function(text)
		text:set_text_property("Text")
		text:set_text_value("Hello, World!")
	end)
end


return M