-- Copyright (c) 2021 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Druid Event Module
--
-- The Event module provides a simple class for handling callbacks. It is used in many Druid components.
--
-- You can subscribe to an event using the `:subscribe` method and unsubscribe using the `:unsubscribe` method.
-- @module DruidEvent
-- @alias druid.event

local class = require("druid.system.middleclass")

local DruidEvent = class("druid.event")


--- DruidEvent constructor
-- @tparam DruidEvent self @{DruidEvent}
-- @tparam[opt] function initial_callback Subscribe the callback on new event, if callback exist
-- @usage
-- local Event = require("druid.event")
-- ...
-- local event = Event(initial_callback)
function DruidEvent.initialize(self, initial_callback)
	self._callbacks = nil -- initialize later

	if initial_callback then
		self:subscribe(initial_callback)
	end
end


--- Subscribe callback on event
-- @tparam DruidEvent self @{DruidEvent}
-- @tparam function callback Callback itself
-- @tparam[opt] any context Additional context as first param to callback call, usually it's self
-- @usage
-- local function on_long_callback(self)
--     print("Long click!")
-- end
-- ...
-- local button = self.druid:new_button("button", callback)
-- button.on_long_click:subscribe(on_long_callback, self)
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
-- @tparam[opt] any context Additional context as first param to callback call
-- @usage
-- local function on_long_callback(self)
--     print("Long click!")
-- end
-- ...
-- button.on_long_click:unsubscribe(on_long_callback, self)
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
-- @treturn boolean True if event have handlers
-- @usage
-- local is_long_click_handler_exists = button.on_long_click:is_exist()
function DruidEvent.is_exist(self)
	if not self._callbacks then
		return false
	end
	return #self._callbacks > 0
end


--- Clear the all event handlers
-- @tparam DruidEvent self @{DruidEvent}
-- @usage
-- button.on_long_click:clear()
function DruidEvent.clear(self)
	self._callbacks = nil
end


--- Trigger the event and call all subscribed callbacks
-- @tparam DruidEvent self @{DruidEvent}
-- @tparam any ... All event params
-- @usage
-- local Event = require("druid.event")
-- ...
-- local event = Event()
-- event:trigger("Param1", "Param2")
function DruidEvent.trigger(self, ...)
	if not self._callbacks then
		return false
	end

	for _, callback_info in ipairs(self._callbacks) do
		if callback_info.context then
			callback_info.callback(callback_info.context, ...)
		else
			callback_info.callback(...)
		end
	end
end


return DruidEvent
