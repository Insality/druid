local component = require("druid.component")

---@class hover: druid.base_component
---@field druid druid.instance
---@field hover druid.hover
---@field hover_pressed druid.hover
local M = component.create("hover")

---Color: #E6DF9F
local HOVERED_COLOR = vmath.vector4(230/255, 223/255, 159/255, 1.0)

---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	-- Default hover callback is `on_hover`, designed for mobile devices
	-- It's only hover if touch action is above the node
	self.hover_default = self.druid:new_hover("button_mobile_hover/root", self.on_hover)

	-- If you wan't to use mouse hover, you can use `on_mouse_hover` callback
	-- It's checks the `action_id` == nil (mouse events)
	self.hover = self.druid:new_hover("button_mouse_hover/root", nil, self.on_hover)

	self.default_color = gui.get_color(self.hover.node)
end


function M:on_hover(is_hover, hover_instance)
	gui.animate(hover_instance.node, "color", is_hover and HOVERED_COLOR or self.default_color, gui.EASING_LINEAR, 0.2)
end


return M
