local event = require("event.event")
local events = require("event.events")
local settings = require("druid.system.settings")
local druid_instance = require("druid.system.druid_instance")

local default_style = require("druid.styles.default.style")

---Entry point for Druid UI Framework. Create a new Druid instance and adjust the settings.
---@class druid
local M = {}


---Create a new Druid instance for creating GUI components.
---@param context table The Druid context. Usually, this is the self of the gui_script. It is passed into all Druid callbacks.
---@param style table|nil The Druid style table to override style parameters for this Druid instance.
---@return druid.instance druid_instance The new Druid instance
function M.new(context, style)
	if settings.default_style == nil then
		M.set_default_style(default_style)
	end

	local new_instance = setmetatable({}, { __index = druid_instance })
	new_instance:initialize(context, style)

	return new_instance
end


---Register a new external Druid component.
---Register component just makes the druid:new_{name} function.
---For example, if you register a component called "my_component", you can create it using druid:new_my_component(...).
---This can be useful if you have your own "basic" components that you don't want to require in every file.
---The default way to create component is `druid_instance:new(component_class, ...)`.
---@param name string Module name
---@param module table Lua table with component
function M.register(name, module)
	druid_instance["new_" .. name] = function(self, ...)
		return druid_instance.new(self, module, ...)
	end
end


---Set the default style for all Druid instances.
---@param style table Default style
function M.set_default_style(style)
	settings.default_style = style or {}
end


---Set the text function for the LangText component.
---@param callback fun(text_id: string): string Get localized text function
function M.set_text_function(callback)
	settings.get_text = callback or function() end
	M.on_language_change()
end


---Set the sound function to able components to play sounds.
---@param callback fun(sound_id: string) Sound play callback
function M.set_sound_function(callback)
	settings.play_sound = callback or function() end
end


---Subscribe Druid to the window listener. It will override your previous
---window listener, so if you have one, you should call M.on_window_callback manually.
function M.init_window_listener()
	window.set_listener(function(_, window_event)
		events.trigger("druid.window_event", window_event)
	end)
end


---Set the window callback to enable Druid window events.
---@param window_event constant Event param from window listener
function M.on_window_callback(window_event)
	events.trigger("druid.window_event", window_event)
end


---Call this function when the game language changes.
---It will notify all Druid instances to update the lang text components.
function M.on_language_change()
	events.trigger("druid.language_change")
end


local WRAPPED_WIDGETS = {}

---Set a widget to the current game object. The game object can acquire the widget by calling `bindings.get_widget`
---It wraps with events only top level functions cross-context, so you will have no access to nested widgets functions
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


---@param object_url string|userdata|url|nil Root object, if nil current object will be used
---@return druid.widget|nil
function M.get_widget(object_url)
	object_url = object_url or msg.url()
	if object_url then
		object_url = msg.url(object_url --[[@as string]])
	end

	local socket_widgets = WRAPPED_WIDGETS[object_url.socket]
	if not socket_widgets then
		return nil
	end

	return socket_widgets[object_url.path]
end


return M
