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
-- @tparam table context Additional context as first param to callback call
function DruidEvent.subscribe(self, callback, context)
	assert(type(self) == "table", "You should subscribe to event with : syntax")
	assert(type(callback) == "function", "Callback should be function")

	table.insert(self._callbacks, {
		callback = callback,
		context = context
	})

	return callback
end


--- Unsubscribe callback on event
-- @tparam DruidEvent self
-- @tparam function callback Callback itself
-- @tparam table context Additional context as first param to callback call
function DruidEvent.unsubscribe(self, callback, context)
	for index, callback_info in ipairs(self._callbacks) do
		if callback_info.callback == callback and callback_info.context == context then
			table.remove(self._callbacks, index)
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
	for index, callback_info in ipairs(self._callbacks) do
		if callback_info.context then
			callback_info.callback(callback_info.context, ...)
		else
			callback_info.callback(...)
		end
	end
end


return DruidEvent
