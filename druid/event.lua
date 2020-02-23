--- Lua event small library
-- @module druid_event

local class = require("druid.system.middleclass")

-- @class DruidEvent
local M = class("druid.event")


function M.initialize(self)
	self._callbacks = {}
end


--- Subscribe callback on event
-- @function event:subscribe
-- @tparam function callback Callback itself
function M.subscribe(self, callback)
	assert(type(self) == "table", "You should subscribe to event with : syntax")
	assert(type(callback) == "function", "Callback should be function")

	table.insert(self._callbacks, callback)
end


--- Unsubscribe callback on event
-- @function event:unsubscribe
-- @tparam function callback Callback itself
function M.unsubscribe(self, callback)
	for i = 1, #self._callbacks do
		if self._callbacks[i] == callback then
			table.remove(self._callbacks, i)
			return
		end
	end
end


--- Trigger the event and call all subscribed callbacks
-- @function event:trigger
-- @param ... All event params
function M.trigger(self, ...)
	for i = 1, #self._callbacks do
		self._callbacks[i](...)
	end
end


return M
