local component = require("druid.component")

---@class basic_button_double_click: druid.base_component
---@field druid druid_instance
---@field button druid.button
local M = component.create("basic_button_double_click")

---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.button = self.druid:new_button("button/root", function()
		print("Click")
	end)

	self.button.on_double_click:subscribe(function()
		print("Double click")
	end)
end


return M
