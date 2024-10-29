local component = require("druid.component")

---@class component_name : druid.base_component
local M = component.create("component_name")


-- Component constructor. Template name and nodes are optional. Pass it if you use it in your component
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)
	self.root = self:get_node("root")

	self.button = self.druid:new_button("button", function() end)
end


return M
