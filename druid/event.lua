-- Copyright (c) 2021 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Druid lua event library
-- @module DruidEvent
-- @alias druid.event

local class = require("druid.system.middleclass")

local DruidEvent = class("druid.event")


--- Event constructur
-- @tparam DruidEvent self @{DruidEvent}
-- @tparam function initial_callback Subscribe the callback on new event, if callback exist
function DruidEvent.initialize(self, initial_callback)
	self._callbacks = nil -- initialize later

	if initial_callback then
		self:subscribe(initial_callback)
	end
end


--- Subscribe callback on event
-- @tparam DruidEvent self @{DruidEvent}
-- @tparam function callback Callback itself
-- @tparam table context Additional context as first param to callback call
function DruidEvent.subscribe(self, callback, context)
	assert(type(self) == "table", "You should subscribe to event with : syntax")
	assert(type(callback) == "function", "Callback should be function")

	self._callbacks = self._callbacks or {}
	table.insert(self._callbacks, {
		callback = callback,
		context = context
	})

	return callback
end


--- Unsubscribe callback on event
-- @tparam DruidEvent self @{DruidEvent}
-- @tparam function callback Callback itself
-- @tparam table context Additional context as first param to callback call
function DruidEvent.unsubscribe(self, callback, context)
	if not self._callbacks then
		return
	end

	for index, callback_info in ipairs(self._callbacks) do
		if callback_info.callback == callback and callback_info.context == context then
			table.remove(self._callbacks, index)
			return
		end
	end
end


--- Return true, if event have at lease one handler
-- @tparam DruidEvent self @{DruidEvent}
-- @treturn bool True if event have handlers
function DruidEvent.is_exist(self)
	if not self._callbacks then
		return false
	end
	return #self._callbacks > 0
end


--- Clear the all event handlers
-- @tparam DruidEvent self @{DruidEvent}
function DruidEvent.clear(self)
	self._callbacks = nil
end


--- Trigger the event and call all subscribed callbacks
-- @tparam DruidEvent self @{DruidEvent}
-- @tparam any ... All event params
function DruidEvent.trigger(self, ...)
	if not self._callbacks then
		return false
	end

	for index, callback_info in ipairs(self._callbacks) do
		if callback_info.context then
			callback_info.callback(callback_info.context, ...)
		else
			callback_info.callback(...)
		end
	end
end


return DruidEvent
