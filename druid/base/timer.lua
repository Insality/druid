--- Component to handle GUI timers
-- @module base.timer

local const = require("druid.const")
local formats = require("druid.helper.formats")
local helper = require("druid.helper")

local M = {}
M.interest = {
	const.ON_UPDATE
}

local empty = function() end


function M.init(self, node, seconds_from, seconds_to, callback)
	self.node = helper.get_node(node)
	seconds_from = math.max(seconds_from, 0)
	seconds_to = math.max(seconds_to or 0, 0)
	callback = callback or empty

	self:set_to(seconds_from)
	self:set_interval(seconds_from, seconds_to)
	self.callback = callback

	if seconds_to - seconds_from == 0 then
		self:set_state(false)
		self.callback(self.context, self)
	end
	return self
end


--- Set text to text field
-- @function timer:set_to
-- @tparam table self Component instance
-- @tparam number set_to Value in seconds
function M.set_to(self, set_to)
	self.last_value = set_to
	gui.set_text(self.node, formats.second_string_min(set_to))
end


--- Called when update
-- @function timer:set_state
-- @tparam table self Component instance
-- @tparam boolean is_on Timer enable state
function M.set_state(self, is_on)
	self.is_on = is_on
end


--- Set time interval
-- @function timer:set_interval
-- @tparam table self Component instance
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


function M.update(self, dt)
	if self.is_on then
		self.temp = self.temp + dt
		local dist = math.min(1, math.abs(self.value - self.target))

		if self.temp > dist then
			self.temp = self.temp - dist
			self.value = helper.step(self.value, self.target, 1)
			M.set_to(self, self.value)
			if self.value == self.target then
				self:set_state(false)
				self.callback(self.context, self)
			end
		end
	end
end


return M