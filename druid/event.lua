--- Lua event small library
-- @module DruidEvent
-- @alias druid_event

local class = require("druid.system.middleclass")

local DruidEvent = class("druid.event")


--- Event constructur
-- @tparam DruidEvent self
-- @tparam function initial_callback Subscribe the callback on new event, if callback exist
function DruidEvent.initialize(self, initial_callback)
	self._callbacks = {}

	if initial_callback then
		self:subscribe(initial_callback)
	end
end


--- Subscribe callback on event
-- @tparam DruidEvent self
-- @tparam function callback Callback itself
function DruidEvent.subscribe(self, callback)
	assert(type(self) == "table", "You should subscribe to event with : syntax")
	assert(type(callback) == "function", "Callback should be function")

	table.insert(self._callbacks, callback)

	return callback
end


--- Unsubscribe callback on event
-- @tparam DruidEvent self
-- @tparam function callback Callback itself
function DruidEvent.unsubscribe(self, callback)
	for i = 1, #self._callbacks do
		if self._callbacks[i] == callback then
			table.remove(self._callbacks, i)
			return
		end
	end
end


--- Return true, if event have at lease one handler
-- @tparam DruidEvent self
-- @treturn bool True if event have handlers
function DruidEvent.is_exist(self)
	return #self._callbacks > 0
end


--- Clear the all event handlers
-- @tparam DruidEvent self
function DruidEvent.clear(self)
	self._callbacks = {}
end


--- Trigger the event and call all subscribed callbacks
-- @tparam DruidEvent self
-- @tparam any ... All event params
function DruidEvent.trigger(self, ...)
	for i = 1, #self._callbacks do
		self._callbacks[i](...)
	end
end


return DruidEvent
