---@class examples.basic_swipe: druid.widget
---@field swipe druid.swipe
local M = {}


function M:init()
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


---@param output_log output_list
function M:on_example_created(output_log)
	self.swipe.on_swipe:subscribe(function(_, side, dist, delta_time)
		output_log:add_log_text("Swipe Side: " .. side)
	end)
end


return M
