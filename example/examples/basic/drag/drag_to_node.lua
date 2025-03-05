local component = require("druid.component")

---@class drag_to_node: druid.component
---@field druid druid.instance
local M = component.create("drag_to_node")


---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)
	self.zone = self:get_node("zone")
	self.counter = 0
	self.text_counter = self:get_node("text_counter")
	gui.set_text(self.text_counter, self.counter)

	-- Init drag and move the drag node on drag callback
	self.drag = self.druid:new_drag("drag/root", self.on_drag)
	self.drag.on_drag_end:subscribe(self.on_drag_end)

	-- Save start position for animation
	self.start_position = gui.get_position(self.drag.node)
end


function M:on_drag(dx, dy, x, y, touch)
	local position_x = gui.get(self.drag.node, "position.x")
	local position_y = gui.get(self.drag.node, "position.y")
	gui.set(self.drag.node, "position.x", position_x + dx)
	gui.set(self.drag.node, "position.y", position_y + dy)

	local is_pick_zone = gui.pick_node(self.zone, touch.x, touch.y)
	self:on_hover_pick_zone(is_pick_zone)
end


function M:on_drag_end(x, y, touch)
	gui.animate(self.drag.node, "position", self.start_position, gui.EASING_OUTBACK, 0.3)

	local is_pick_zone = gui.pick_node(self.zone, touch.x, touch.y)
	if is_pick_zone then
		self.counter = self.counter + 1
		gui.set_text(self.text_counter, self.counter)
		self:on_drop_to_zone()
	end
	self:on_hover_pick_zone(false)
end


function M:on_hover_pick_zone(is_pick_zone)
	local target_alpha = is_pick_zone and 1.5 or 1
	gui.animate(self.zone, "color.w", target_alpha, gui.EASING_OUTSINE, 0.3)
end


function M:on_drop_to_zone()
	gui.set_scale(self.zone, vmath.vector3(1.2))
	gui.animate(self.zone, "scale", vmath.vector3(1), gui.EASING_OUTBACK, 0.3)
end


return M
