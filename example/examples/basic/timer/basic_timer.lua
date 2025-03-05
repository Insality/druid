local event = require("event.event")

local component = require("druid.component")

---@class examples.basic_timer: druid.component
---@field druid druid.instance
---@field root node
---@field text druid.text
local M = component.create("basic_timer")


---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

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


return M
