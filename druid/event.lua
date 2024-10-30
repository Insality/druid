---@class druid.event
local M = {}

M.COUNTER = 0

-- Forward declaration
local EVENT_METATABLE

-- Local versions
local pcall = pcall
local tinsert = table.insert
local tremove = table.remove

--- Return new event instance
---@param callback fun()|nil Subscribe the callback on new event, if callback exist
---@param callback_context any|nil Additional context as first param to callback call
---@return druid.event
---@nodiscard
function M.create(callback, callback_context)
	local instance = setmetatable({}, EVENT_METATABLE)

	if callback then
		instance:subscribe(callback, callback_context)
	end

	M.COUNTER = M.COUNTER + 1
	return instance
end


--- Check is event subscribed.
---@param callback fun() Callback itself
---@param callback_context any|nil Additional context as first param to callback call
-- @treturn boolean, number|nil @Is event subscribed, return index of callback in event as second param
function M:is_subscribed(callback, callback_context)
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


---Subscribe callback on event
---@param callback fun() Callback itself
---@param callback_context any|nil Additional context as first param to callback call, usually it's self
---@return boolean
function M:subscribe(callback, callback_context)
	assert(type(self) == "table", "You should subscribe to event with : syntax")
	assert(callback, "A function must be passed to subscribe to an event")

	if self:is_subscribed(callback, callback_context) then
		return false
	end

	tinsert(self, { callback, callback_context })
	return true
end


---Unsubscribe callback on event
---@param callback fun() Callback itself
---@param callback_context any|nil Additional context as first param to callback call
---@return boolean
function M:unsubscribe(callback, callback_context)
	assert(callback, "A function must be passed to subscribe to an event")

	local _, event_index = self:is_subscribed(callback, callback_context)
	if not event_index then
		return false
	end

	tremove(self, event_index)
	return true
end


---Return true, if event have at lease one handler
---@return boolean
function M:is_exist()
	return #self > 0
end


---Return true, if event not have handler
---@return boolean True if event not have handlers
function M:is_empty()
	return #self == 0
end


---Clear the all event handlers
function M:clear()
	for index = #self, 1, -1 do
		self[index] = nil
	end
end


--- Trigger the event and call all subscribed callbacks
---@param ... any All event params
---@return any result Last returned value from subscribers
function M:trigger(...)
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


---@param callback table Callback data {function, context}
---@param ... any All event params
---@return any result Result of the callback
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
