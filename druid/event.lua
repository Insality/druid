-- Copyright (c) 2021 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Druid Event Module
--
-- The Event module provides a simple class for handling callbacks. It is used in many Druid components.
--
-- You can subscribe to an event using the `:subscribe` method and unsubscribe using the `:unsubscribe` method.
-- @module DruidEvent
-- @alias druid.event

local M = {}
M.COUNTER = 0

-- Forward declaration
local EVENT_METATABLE

-- Local versions
local pcall = pcall
local tinsert = table.insert
local tremove = table.remove

--- DruidEvent constructor
-- @tparam function|nil callback Subscribe the callback on new event, if callback exist
-- @tparam any|nil callback_context Additional context as first param to callback call
-- @usage
-- local Event = require("druid.event")
-- ...
-- local event = Event(callback)
function M.create(callback, callback_context)
	local instance = setmetatable({}, EVENT_METATABLE)

	if callback then
		instance:subscribe(callback, callback_context)
	end

	M.COUNTER = M.COUNTER + 1
	return instance
end


--- Check is event subscribed.
-- @tparam DruidEvent self @{DruidEvent}
-- @tparam function callback Callback itself
-- @tparam any|nil callback_context Additional context as first param to callback call
-- @treturn boolean, number|nil @Is event subscribed, return index of callback in event as second param
function M.is_subscribed(self, callback, callback_context)
	if #self == 0 then
		return false, nil
	end

	for index = 1, #self do
		local cb = self[index]
		if cb[1] == callback and cb[2] == callback_context then
			return true, index
		end
	end

	return false, nil
end


--- Subscribe callback on event
-- @tparam DruidEvent self @{DruidEvent}
-- @tparam function callback Callback itself
-- @tparam any|nil callback_context Additional context as first param to callback call, usually it's self
-- @treturn boolean True if callback was subscribed
-- @usage
-- local function on_long_callback(self)
--     print("Long click!")
-- end
-- ...
-- local button = self.druid:new_button("button", callback)
-- button.on_long_click:subscribe(on_long_callback, self)
function M.subscribe(self, callback, callback_context)
	assert(type(self) == "table", "You should subscribe to event with : syntax")
	assert(callback, "A function must be passed to subscribe to an event")

	if self:is_subscribed(callback, callback_context) then
		return false
	end

	tinsert(self, { callback, callback_context })
	return true
end


--- Unsubscribe callback on event
-- @tparam DruidEvent self @{DruidEvent}
-- @tparam function callback Callback itself
-- @tparam any|nil callback_context Additional context as first param to callback call
-- @usage
-- local function on_long_callback(self)
--     print("Long click!")
-- end
-- ...
-- button.on_long_click:unsubscribe(on_long_callback, self)
function M.unsubscribe(self, callback, callback_context)
	assert(callback, "A function must be passed to subscribe to an event")

	local _, event_index = self:is_subscribed(callback, callback_context)
	if not event_index then
		return false
	end

	tremove(self, event_index)
	return true
end


--- Return true, if event have at lease one handler
-- @tparam DruidEvent self @{DruidEvent}
-- @treturn boolean True if event have handlers
-- @usage
-- local is_long_click_handler_exists = button.on_long_click:is_exist()
function M.is_exist(self)
	return #self > 0
end


--- Return true, if event not have handler
--- @tparam DruidEvent self @{DruidEvent}
--- @treturn boolean True if event not have handlers
--- @usage
--- local is_long_click_handler_not_exists = button.on_long_click:is_empty()
function M:is_empty()
	return #self == 0
end


--- Clear the all event handlers
-- @tparam DruidEvent self @{DruidEvent}
-- @usage
-- button.on_long_click:clear()
function M.clear(self)
	for index = #self, 1, -1 do
		self[index] = nil
	end
end


--- Trigger the event and call all subscribed callbacks
-- @tparam DruidEvent self @{DruidEvent}
-- @tparam any ... All event params
-- @usage
-- local Event = require("druid.event")
-- ...
-- local event = Event()
-- event:trigger("Param1", "Param2")
function M.trigger(self, ...)
	if #self == 0 then
		return
	end

	local result = nil

	local call_callback = self.call_callback
	for index = 1, #self do
		result = call_callback(self, self[index], ...)
	end

	return result
end


-- @tparam table callback Callback data {function, context}
-- @tparam any ... All event params
-- @treturn any Result of the callback
-- @local
function M:call_callback(callback, ...)
	local event_callback = callback[1]
	local event_callback_context = callback[2]

	-- Call callback
	local ok, result_or_error
	if event_callback_context then
		ok, result_or_error = pcall(event_callback, event_callback_context, ...)
	else
		ok, result_or_error = pcall(event_callback, ...)
	end

	-- Handle errors
	if not ok then
		local caller_info = debug.getinfo(2)
		pprint("An error occurred during event processing", {
			trigger = caller_info.short_src .. ":" .. caller_info.currentline,
			error = result_or_error,
		})
		pprint("Traceback", debug.traceback())
		return nil
	end

	return result_or_error
end

-- Construct event metatable
EVENT_METATABLE = {
	__index = M,
	__call = M.trigger,
}

return setmetatable(M, {
	__call = function(_, callback)
		return M.create(callback)
	end,
})
