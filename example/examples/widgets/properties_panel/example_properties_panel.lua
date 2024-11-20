local properties_panel = require("druid.widget.properties_panel.properties_panel")

---@class widget.example_properties_panel: druid.widget
local M = {}


function M:init()
	self.properties_panel = self.druid:new_widget(properties_panel, "properties_panel")

	self.properties_panel:add_button("Button", function()
		print("Button clicked")
	end)

	self.properties_panel:add_checkbox("Checkbox", false, function(value)
		print("Checkbox clicked", value)
	end)

	self.properties_panel:add_input("Input", "Initial", function(value)
		print("Input value", value)
	end)

	self.properties_panel:add_left_right_selector("Arrows Number", 0, function(value)
		print("Left Right Number value", value)
	end):set_number_type(0, 42, true, 1)

	self.properties_panel:add_left_right_selector("Arrows Array", "Zero", function(value)
		print("Left Right Array value", value)
	end):set_array_type({"Zero", "One", "Two", "Three", "Four", "Five"}, false, 1)

	self.properties_panel:add_slider("Slider", 0.5, function(value)
		print("Slider value", value)
	end)

	self.properties_panel:add_text("Text", "Some text")
end


return M