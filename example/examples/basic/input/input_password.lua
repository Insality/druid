local component = require("druid.component")

---@class input_password: druid.component
---@field druid druid.instance
---@field root node
local M = component.create("input_password")


---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.root = self:get_node("root")
	self.input = self.druid:new_input("input/root", "input/text", gui.KEYBOARD_TYPE_PASSWORD)
	self.input:set_text("")

	self.input.on_input_unselect:subscribe(function(_, text)
		print(text)
	end)
end


return M
