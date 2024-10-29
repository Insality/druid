local component = require("druid.component")

---@class basic_blocker: druid.base_component
---@field druid druid_instance
---@field root node
---@field blocker druid.blocker
local M = component.create("basic_blocker")


---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.root = self:get_node("root")

	self.button_root = self.druid:new_button(self.root, self.on_root_click)
	-- This blocker forbid input to all previous nodes in node zone
	self.blocker = self.druid:new_blocker("blocker")
	self.button = self.druid:new_button("button/root", self.on_button_click)
end


function M:on_root_click()
	print("Root click")
end


function M:on_button_click()
	print("Button click")
end


return M
