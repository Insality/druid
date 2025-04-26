---@class examples.basic_back_handler: druid.widget
local M = {}

function M:init()
	self.druid:new_back_handler(self.on_back)
end


function M:on_back()
	local node = self:get_node("text")
	gui.animate(node, gui.PROP_SCALE, vmath.vector3(1.2), gui.EASING_OUTELASTIC, 0.5, 0, function()
		gui.animate(node, gui.PROP_SCALE, vmath.vector3(1), gui.EASING_OUTELASTIC, 0.5)
	end)
end


return M
