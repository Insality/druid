local component = require("druid.component")

---@class basic_swipe: druid.base_component
---@field druid druid.instance
local M = component.create("basic_swipe")

---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.swipe = self.druid:new_swipe("root", self.on_swipe) --[[@as druid.swipe]]

	self.text_hint = self:get_node("swipe_hint")
end


function M:on_swipe(swipe_side, dist, delta_time)
	print("Swipe side:", swipe_side, "Distance:", dist, "Time:", delta_time)

	if swipe_side == "up" then
		gui.animate(self.text_hint, gui.PROP_POSITION, vmath.vector3(0, 200, 0), gui.EASING_OUTBACK, 0.4)
	elseif swipe_side == "down" then
		gui.animate(self.text_hint, gui.PROP_POSITION, vmath.vector3(0, -200, 0), gui.EASING_OUTBACK, 0.4)
	elseif swipe_side == "left" then
		gui.animate(self.text_hint, gui.PROP_POSITION, vmath.vector3(-200, 0, 0), gui.EASING_OUTBACK, 0.4)
	elseif swipe_side == "right" then
		gui.animate(self.text_hint, gui.PROP_POSITION, vmath.vector3(200, 0, 0), gui.EASING_OUTBACK, 0.4)
	end
end


return M
