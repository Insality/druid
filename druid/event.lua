--- Lua event small library
-- @module druid_event

local class = require("druid.system.middleclass")

-- @class DruidEvent
local Event = class("druid.event")


--- Event constructur
-- @function Event
-- @tparam function initial_callback Subscribe the callback on new event, if callback exist
function Event:initialize(initial_callback)
	self._callbacks = {}

	if initial_callback then
		self:subscribe(initial_callback)
	end
end


--- Subscribe callback on event
-- @function event:subscribe
-- @tparam function callback Callback itself
function Event:subscribe(callback)
	assert(type(self) == "table", "You should subscribe to event with : syntax")
	assert(type(callback) == "function", "Callback should be function")

	table.insert(self._callbacks, callback)

	return callback
end


--- Unsubscribe callback on event
-- @function event:unsubscribe
-- @tparam function callback Callback itself
function Event:unsubscribe(callback)
	for i = 1, #self._callbacks do
		if self._callbacks[i] == callback then
			table.remove(self._callbacks, i)
			return
		end
	end
end


--- Return true, if event have at lease one handler
-- @function event:is_exist
-- @treturn bool True if event have handlers
function Event:is_exist()
	return #self._callbacks > 0
end


--- Clear the all event handlers
-- @function event:clear
function Event:clear()
	self._callbacks = {}
end


--- Trigger the event and call all subscribed callbacks
-- @function event:trigger
-- @param ... All event params
function Event:trigger(...)
	for i = 1, #self._callbacks do
		self._callbacks[i](...)
	end
end


return Event
