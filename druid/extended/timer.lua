local event = require("event.event")
local helper = require("druid.helper")
local component = require("druid.component")

---@class druid.timer: druid.base_component
---@field on_tick event
---@field on_set_enabled event
---@field on_timer_end event
---@field style table
---@field node node
---@field from number
---@field target number
---@field value number
---@field is_on boolean|nil
local M = component.create("timer")


local function second_string_min(sec)
	local mins = math.floor(sec / 60)
	local seconds = math.floor(sec - mins * 60)
	return string.format("%.2d:%.2d", mins, seconds)
end


---The Timer constructor
---@param node node Gui text node
---@param seconds_from number|nil Start timer value in seconds
---@param seconds_to number|nil End timer value in seconds
---@param callback function|nil Function on timer end
function M:init(node, seconds_from, seconds_to, callback)
	self.node = self:get_node(node)
	seconds_to = math.max(seconds_to or 0, 0)

	self.on_tick = event.create()
	self.on_set_enabled = event.create()
	self.on_timer_end = event.create(callback)

	if seconds_from then
		seconds_from = math.max(seconds_from, 0)
		self:set_to(seconds_from)
		self:set_interval(seconds_from, seconds_to)

		if seconds_to - seconds_from == 0 then
			self:set_state(false)
			self.on_timer_end:trigger(self:get_context(), self)
		end
	end

	return self
end


function M:update(dt)
	if not self.is_on then
		return
	end

	self.temp = self.temp + dt
	local dist = math.min(1, math.abs(self.value - self.target))

	if self.temp > dist then
		self.temp = self.temp - dist
		self.value = helper.step(self.value, self.target, 1)
		self:set_to(self.value)

		self.on_tick:trigger(self:get_context(), self.value)

		if self.value == self.target then
			self:set_state(false)
			self.on_timer_end:trigger(self:get_context(), self)
		end
	end
end


function M:on_layout_change()
	self:set_to(self.last_value)
end


---@param set_to number Value in seconds
---@return druid.timer self
function M:set_to(set_to)
	self.last_value = set_to
	gui.set_text(self.node, second_string_min(set_to))

	return self
end


---@param is_on boolean|nil Timer enable state
---@return druid.timer self
function M:set_state(is_on)
	self.is_on = is_on
	self.on_set_enabled:trigger(self:get_context(), is_on)

	return self
end


---@param from number Start time in seconds
---@param to number Target time in seconds
---@return druid.timer self
function M:set_interval(from, to)
	self.from = from
	self.value = from
	self.temp = 0
	self.target = to
	self:set_state(true)
	self:set_to(from)

	return self
end


return M
