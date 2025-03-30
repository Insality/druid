local event = require("event.event")
local helper = require("druid.helper")
local component = require("druid.component")

---Druid component to handle timer work on gui text node. Displays time in a formatted way.
---
---### Setup
---Create timer component with druid: `timer = druid:new_timer(text_node, from_seconds, to_seconds, callback)`
---
---### Notes
---- Timer fires callback when timer value equals to _to_seconds_
---- Timer will set text node with current timer value
---- Timer uses update function to handle time
---@class druid.timer: druid.component
---@field on_tick event fun(context, value) The event triggered when the timer ticks
---@field on_set_enabled event fun(context, is_on) The event triggered when the timer is enabled
---@field on_timer_end event fun(context) The event triggered when the timer ends
---@field node node The node to display the timer
---@field from number The start time of the timer
---@field target number The target time of the timer
---@field value number The current value of the timer
---@field is_on boolean|nil True if the timer is on
local M = component.create("timer")


---@param node node Gui text node
---@param seconds_from number|nil Start timer value in seconds
---@param seconds_to number|nil End timer value in seconds
---@param callback function|nil Function that triggers when timer value equals to seconds_to
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


---@private
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


---@private
function M:on_layout_change()
	self:set_to(self.last_value)
end


---Set the timer to a specific value
---@param set_to number Value in seconds
---@return druid.timer self Current timer instance
function M:set_to(set_to)
	self.last_value = set_to
	gui.set_text(self.node, self:_second_string_min(set_to))

	return self
end


---Set the timer to a specific value
---@param is_on boolean|nil Timer enable state
---@return druid.timer self Current timer instance
function M:set_state(is_on)
	self.is_on = is_on
	self.on_set_enabled:trigger(self:get_context(), is_on)

	return self
end


---Set the timer interval
---@param from number Start time in seconds
---@param to number Target time in seconds
---@return druid.timer self Current timer instance
function M:set_interval(from, to)
	self.from = from
	self.value = from
	self.temp = 0
	self.target = to
	self:set_state(true)
	self:set_to(from)

	return self
end


---@private
---@param sec number Seconds to convert
---@return string The formatted time string
function M:_second_string_min(sec)
	local mins = math.floor(sec / 60)
	local seconds = math.floor(sec - mins * 60)
	return string.format("%.2d:%.2d", mins, seconds)
end


return M
