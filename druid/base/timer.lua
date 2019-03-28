local data = require("druid.data")
local formats = require("druid.helper.formats")
local helper = require("druid.helper.ui_helper")

local M = {}
M.interest = {
	data.LAYOUT_CHANGED,
	data.ON_UPDATE
}

local empty = function() end

function M.init(instance, seconds_from, seconds_to, callback)
	seconds_from = math.max(seconds_from, 0)
	seconds_to = math.max(seconds_to or 0, 0)
	callback = callback or empty

	instance:set_to(seconds_from)
	instance:set_interval(seconds_from, seconds_to)
	instance.callback = callback

	if seconds_to - seconds_from == 0 then
		instance:set_state(false)
		instance.callback(instance.parent.parent, instance)
	end
	return instance
end


--- Set text to text field
-- @param set_to - set value in seconds
function M.set_to(instance, set_to)
	instance.last_value = set_to
	gui.set_text(instance.node, formats.second_string_min(set_to))
end


--- Called when layout updated (rotate for example)
function M.on_layout_updated(instance)
	M.set_to(instance, instance.last_value)
end


--- Called when update
-- @param is_on - boolean is timer on
function M.set_state(instance, is_on)
	instance.is_on = is_on
end


--- Set time interval
-- @param from - "from" time in seconds
-- @param to - "to" time in seconds
function M.set_interval(instance, from, to)
	instance.from = from
	instance.value = from
	instance.temp = 0
	instance.target = to
	M.set_state(instance, true)
	M.set_to(instance, from)
end


--- Called when update
-- @param dt - delta time
function M.update(instance, dt)
	if instance.is_on then
		instance.temp = instance.temp + dt
		local dist = math.min(1, math.abs(instance.value - instance.target))

		if instance.temp > dist then
			instance.temp = instance.temp - dist
			instance.value = helper.step(instance.value, instance.target, 1)
			M.set_to(instance, instance.value)
			if instance.value == instance.target then
				instance:set_state(false)
				instance.callback(instance.parent.parent, instance)
			end
		end
	end
end


return M