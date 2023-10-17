-- Copyright (c) 2021 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Component to handle GUI timers.
-- Timer updating by game delta time. If game is not focused -
-- timer will be not updated.
-- @module Timer
-- @within BaseComponent
-- @alias druid.timer

--- On timer tick. Fire every second callback(self, value)
-- @tfield DruidEvent on_tick @{DruidEvent}

--- On timer change enabled state callback(self, is_enabled)
-- @tfield DruidEvent on_set_enabled @{DruidEvent}

--- On timer end callback
-- @tfield DruidEvent on_timer_end(self, Timer) @{DruidEvent}

--- Trigger node
-- @tfield node node

--- Initial timer value
-- @tfield number from

--- Target timer value
-- @tfield number target

--- Current timer value
-- @tfield number value

---

local Event = require("druid.event")
local helper = require("druid.helper")
local component = require("druid.component")

local Timer = component.create("timer")


local function second_string_min(sec)
	local mins = math.floor(sec / 60)
	local seconds = math.floor(sec - mins * 60)
	return string.format("%.2d:%.2d", mins, seconds)
end


--- The @{Timer} constructor
-- @tparam Timer self @{Timer}
-- @tparam node node Gui text node
-- @tparam number seconds_from Start timer value in seconds
-- @tparam[opt=0] number seconds_to End timer value in seconds
-- @tparam[opt] function callback Function on timer end
function Timer.init(self, node, seconds_from, seconds_to, callback)
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


function Timer.update(self, dt)
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


function Timer.on_layout_change(self)
	self:set_to(self.last_value)
end


--- Set text to text field
-- @tparam Timer self @{Timer}
-- @tparam number set_to Value in seconds
function Timer.set_to(self, set_to)
	self.last_value = set_to
	gui.set_text(self.node, second_string_min(set_to))
end


--- Called when update
-- @tparam Timer self @{Timer}
-- @tparam boolean is_on Timer enable state
function Timer.set_state(self, is_on)
	self.is_on = is_on

	self.on_set_enabled:trigger(self:get_context(), is_on)
end


--- Set time interval
-- @tparam Timer self @{Timer}
-- @tparam number from Start time in seconds
-- @tparam number to Target time in seconds
function Timer.set_interval(self, from, to)
	self.from = from
	self.value = from
	self.temp = 0
	self.target = to
	self:set_state(true)
	self:set_to(from)
end


return Timer
