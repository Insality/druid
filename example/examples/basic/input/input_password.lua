---@class examples.input_password: druid.widget
---@field root node
---@field input druid.input
local M = {}


function M:init()
	self.root = self:get_node("root")
	self.input = self.druid:new_input("input/root", "input/text", gui.KEYBOARD_TYPE_PASSWORD)
	self.input:set_text("")

	self.input.on_input_unselect:subscribe(function(_, text)
		print(text)
	end)
end


return M
