---@class examples.basic_button: druid.widget
---@field button druid.button
local M = {}

function M:init()
	self.button = self.druid:new_button("button/root", function()
		print("Button pressed")
	end)
end

return M
