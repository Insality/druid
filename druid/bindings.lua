local event = require("event.event")

local M = {}
local WRAPPED_WIDGETS = {}

---Set a widget to the current game object. The game object can acquire the widget by calling `bindings.get_widget`
---It wraps with events only top level functions cross-context, so no access to nested widgets functions
---@param widget druid.widget
function M.set_widget(widget)
	local object = msg.url()
	object.fragment = nil

	-- Make a copy of the widget with all functions wrapped in events
	-- It makes available to call gui functions from game objects
	local wrapped_widget = setmetatable({}, { __index = widget })
	local parent_table = getmetatable(widget).__index

	-- Go through all functions and wrap them in events
	for key, value in pairs(parent_table) do
		if type(value) == "function" then
			wrapped_widget[key] = event.create(function(_, ...)
				return value(widget, ...)
			end)
		end
	end

	WRAPPED_WIDGETS[object.socket] = WRAPPED_WIDGETS[object.socket] or {}
	WRAPPED_WIDGETS[object.socket][object.path] = wrapped_widget
end


---@param object_url string|userdata|url @root object
---@return druid.widget|nil
function M.get_widget(object_url)
	assert(object_url, "You must provide an object_url")

	object_url = msg.url(object_url --[[@as string]])

	local socket_widgets = WRAPPED_WIDGETS[object_url.socket]
	if not socket_widgets then
		return nil
	end

	return socket_widgets[object_url.path]
end


return M
