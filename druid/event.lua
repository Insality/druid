--- Lua event small library

local class = require("druid.system.middleclass")

local M = class("druid.event")


function M.initialize(self)
	self._callbacks = {}
end


function M.subscribe(self, callback)
	assert(type(callback) == "function", "Callback should be function")

	table.insert(self._callbacks, callback)
end


function M.unsubscribe(self, callback)
	for i = 1, #self._callbacks do
		if self._callbacks[i] == callback then
			table.remove(self._callbacks, i)
			return
		end
	end
end


function M.trigger(self, ...)
	for i = 1, #self._callbacks do
		self._callbacks[i](...)
	end
end


return M
