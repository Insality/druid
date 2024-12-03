local event = require("event.event")

---@class event.queue
local M = {}

local event_handlers = {}
local pending_callbacks = {}


---Request to handle a specified event and processes the queue of callbacks associated with it.
---If event has already been triggered, the callback will be executed immediately.
---If event not triggered yet, callback will be executed when event will be triggered.
---It triggered only once and then removed from the queue.
---@param event_name string The name of the event to trigger.
---@param callback fun() The callback function to execute upon triggering.
---@param ... any Additional arguments for the callback.
function M.request(event_name, callback, ...)
	pending_callbacks[event_name] = pending_callbacks[event_name] or {}
	table.insert(pending_callbacks[event_name], { event.create(callback), ... })

	M.process_pending_callbacks(event_name)
end


---Subscribes to a specified event and executes a callback when the event is triggered.
-- If the event has already been triggered, the callback will be executed immediately.
---@param event_name string The name of the event to subscribe to.
---@param callback fun() The function to call when the event is triggered.
function M.subscribe(event_name, callback)
	event_handlers[event_name] = event_handlers[event_name] or event.create()

	if event_handlers[event_name] then
		event_handlers[event_name]:subscribe(callback)
	end

	M.process_pending_callbacks(event_name)
end


---Unsubscribes a callback function from a specified event.
---@param event_name string The name of the event to unsubscribe from.
---@param callback fun() The function to remove from the event's subscription list.
function M.unsubscribe(event_name, callback)
	if event_handlers[event_name] then
		event_handlers[event_name]:unsubscribe(callback)
	end
end


---Processes the queue for a given event name, executing callbacks and handling results.
---Processed callbacks are removed from the queue.
---@param event_name string The name of the event for which to process the queue.
function M.process_pending_callbacks(event_name)
	local callbacks_to_process = pending_callbacks[event_name]
	local event_handler = event_handlers[event_name]

	if not callbacks_to_process or not event_handler then
		return
	end

	-- Loop through the queue in reverse to prevent index errors during removal
	for i = #callbacks_to_process, 1, -1 do
		local callback_entry = callbacks_to_process[i]
		-- Better to figure out how to make it without 2 unpacks, but ok for all our cases now
		local args = { unpack(callback_entry, 2) }

		-- Safely call the event handler and handle errors
		local success, result = pcall(event_handler.trigger, event_handler, unpack(args))

		if success and result then
			local callback_function = callback_entry[1]
			pcall(callback_function, result) -- Safely invoke the callback, catching any errors
			table.remove(callbacks_to_process, i) -- Remove the processed callback from the queue
		end
	end

	-- Clean up if the callback queue is empty
	if #callbacks_to_process == 0 then
		pending_callbacks[event_name] = nil
	end
end


return M
