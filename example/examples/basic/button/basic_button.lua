local component = require("druid.component")

---@class basic_button: druid.base_component
---@field druid druid.instance
---@field button druid.button
local M = component.create("basic_button")

---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.button = self.druid:new_button("button/root", function()
		print("Button pressed")
	end)
end


return M
