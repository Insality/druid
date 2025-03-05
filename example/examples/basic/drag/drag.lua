local component = require("druid.component")

---@class drag: druid.component
---@field druid druid.instance
local M = component.create("drag")


---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	-- Init drag and move the drag node on drag callback
	self.drag = self.druid:new_drag("drag/root", function(_, dx, dy)
		local position_x = gui.get(self.drag.node, "position.x")
		local position_y = gui.get(self.drag.node, "position.y")
		gui.set(self.drag.node, "position.x", position_x + dx)
		gui.set(self.drag.node, "position.y", position_y + dy)
	end)

	-- Save start position for animation
	self.start_position = gui.get_position(self.drag.node)
	self.drag.on_drag_end:subscribe(function()
		gui.animate(self.drag.node, "position", self.start_position, gui.EASING_OUTBACK, 0.3)
	end)
end


return M
