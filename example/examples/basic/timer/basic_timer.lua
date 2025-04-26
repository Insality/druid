local event = require("event.event")

---@class examples.basic_timer: druid.widget
---@field root node
---@field text druid.text
local M = {}

function M:init()
	self.root = self:get_node("root")
	self.timer = self.druid:new_timer("text")

	local time = 5
	self.timer:set_interval(time, 0)
	self.timer.on_timer_end:subscribe(function()
		time = time + 5
		self.timer:set_interval(time, 0)
		self.on_cycle_end:trigger()
	end)

	self.on_cycle_end = event.create()
end


---@param output_log output_list
function M:on_example_created(output_log)
	self.on_cycle_end:subscribe(function()
		output_log:add_log_text("Timer Cycle End")
	end)
end


return M
