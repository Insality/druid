---@class examples.basic_button_double_click: druid.widget
---@field button druid.button
local M = {}

function M:init()
	self.button = self.druid:new_button("button/root", function()
		print("Click")
	end)

	self.button.on_double_click:subscribe(function()
		print("Double click")
	end)
end


---@param output_log output_list
function M:on_example_created(output_log)
	self.button.on_click:subscribe(function()
		output_log:add_log_text("Clicked")
	end)
	self.button.on_double_click:subscribe(function()
		output_log:add_log_text("Double Clicked")
	end)
end


return M
