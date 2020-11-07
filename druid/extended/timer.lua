--- Component to handle GUI timers.
-- Timer updating by game delta time. If game is not focused -
-- timer will be not updated.
-- @module Timer
-- @within BaseComponent
-- @alias druid.timer

--- On timer tick. Fire every second callback(self, value)
-- @tfield druid_event on_tick

--- On timer change enabled state callback(self, is_enabled)
-- @tfield druid_event on_set_enabled

--- On timer end callback
-- @tfield druid_event on_timer_end(self, Timer)

--- Trigger node
-- @tfield node node

--- Initial timer value
-- @tfield number from

--- Target timer value
-- @tfield number target

--- Current timer value
-- @tfield number value


local Event = require("druid.event")
local formats = require("druid.helper.formats")
local helper = require("druid.helper")
local component = require("druid.component")

local Timer = component.create("timer", { component.ON_UPDATE })


--- Component init function
-- @tparam Timer self
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

--- Set text to text field
-- @tparam Timer self
-- @tparam number set_to Value in seconds
function Timer.set_to(self, set_to)
	self.last_value = set_to
	gui.set_text(self.node, formats.second_string_min(set_to))
end


--- Called when update
-- @tparam Timer self
-- @tparam bool is_on Timer enable state
function Timer.set_state(self, is_on)
	self.is_on = is_on

	self.on_set_enabled:trigger(self:get_context(), is_on)
end


--- Set time interval
-- @tparam Timer self
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
