local component = require("druid.component")

---@class basic_hotkey: druid.base_component
---@field druid druid_instance
---@field root node
---@field text druid.text
local M = component.create("basic_hotkey")


---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.root = self:get_node("root")
	self.hotkey = self.druid:new_hotkey({ "key_lshift", "key_x" }, self.on_hotkey)
end


function M:on_hotkey()
	gui.animate(self.root, gui.PROP_SCALE, vmath.vector3(1.2), gui.EASING_OUTELASTIC, 0.5, 0, function()
		gui.animate(self.root, gui.PROP_SCALE, vmath.vector3(1), gui.EASING_OUTELASTIC, 0.5)
	end)
end


return M
