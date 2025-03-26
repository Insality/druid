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

return M
