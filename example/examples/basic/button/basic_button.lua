---@class examples.basic_button: druid.widget
---@field button druid.button
local M = {}

function M:init()
	self.button = self.druid:new_button("button/root", function()
		print("Button pressed")
	end)
end


---@param output_log output_list
function M:on_example_created(output_log)
	self.button.on_click:subscribe(function()
		output_log:add_log_text("Button Clicked")
	end)
end


---@param properties_panel properties_panel
function M:properties_control(properties_panel)
	local checkbox = properties_panel:add_checkbox("ui_enabled", false, function(value)
		self.button:set_enabled(value)
	end)
	checkbox:set_value(true)
end


return M
