local component = require("druid.component")

---@class examples.basic_back_handler: druid.component
---@field druid druid.instance
local M = component.create("basic_back_handler")


---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)
	self.druid:new_back_handler(self.on_back)
end


function M:on_back()
	local node = self:get_node("text")
	gui.animate(node, gui.PROP_SCALE, vmath.vector3(1.2), gui.EASING_OUTELASTIC, 0.5, 0, function()
		gui.animate(node, gui.PROP_SCALE, vmath.vector3(1), gui.EASING_OUTELASTIC, 0.5)
	end)
end


return M
