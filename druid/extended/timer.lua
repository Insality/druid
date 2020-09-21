--- Component to handle GUI timers.
-- Timer updating by game delta time. If game is not focused -
-- timer will be not updated.
-- @module druid.timer

--- Component events
-- @table Events
-- @tfield druid_event on_tick On timer tick callback. Fire every second
-- @tfield druid_event on_set_enabled On timer change enabled state callback
-- @tfield druid_event on_timer_end On timer end callback

--- Component fields
-- @table Fields
-- @tfield node node Trigger node
-- @tfield number from Initial timer value
-- @tfield number target Target timer value
-- @tfield number value Current timer value

local Event = require("druid.event")
local const = require("druid.const")
local formats = require("druid.helper.formats")
local helper = require("druid.helper")
local component = require("druid.component")

local M = component.create("timer", { const.ON_UPDATE })


--- Component init function
-- @function timer:init
-- @tparam node node Gui text node
-- @tparam number seconds_from Start timer value in seconds
-- @tparam[opt=0] number seconds_to End timer value in seconds
-- @tparam[opt] function callback Function on timer end
function M.init(self, node, seconds_from, seconds_to, callback)
	self.node = self:get_node(node)
	seconds_from = math.max(seconds_from, 0)
	seconds_to = math.max(seconds_to or 0, 0)

	self.on_tick = Event()
	self.on_set_enabled = Event()
	self.on_timer_end = Event(callback)

	self:set_to(seconds_from)
	self:set_interval(seconds_from, seconds_to)

	if seconds_to - seconds_from == 0 then
		self:set_state(false)
		self.on_timer_end:trigger(self:get_context(), self)
	end

	return self
end


function M.update(self, dt)
	if not self.is_on then
		return
	end

	self.temp = self.temp + dt
	local dist = math.min(1, math.abs(self.value - self.target))

	if self.temp > dist then
		self.temp = self.temp - dist
		self.value = helper.step(self.value, self.target, 1)
		M.set_to(self, self.value)

		self.on_tick:trigger(self:get_context(), self.value)

		if self.value == self.target then
			self:set_state(false)
			self.on_timer_end:trigger(self:get_context(), self)
		end
	end
end

--- Set text to text field
-- @function timer:set_to
-- @tparam number set_to Value in seconds
function M.set_to(self, set_to)
	self.last_value = set_to
	gui.set_text(self.node, formats.second_string_min(set_to))
end


--- Called when update
-- @function timer:set_state
-- @tparam bool is_on Timer enable state
function M.set_state(self, is_on)
	self.is_on = is_on

	self.on_set_enabled:trigger(self:get_context(), is_on)
end


--- Set time interval
-- @function timer:set_interval
-- @tparam number from Start time in seconds
-- @tparam number to Target time in seconds
function M.set_interval(self, from, to)
	self.from = from
	self.value = from
	self.temp = 0
	self.target = to
	M.set_state(self, true)
	M.set_to(self, from)
end


return M