local event = require("event.event")
local events = require("event.events")
local settings = require("druid.system.settings")
local druid_instance = require("druid.system.druid_instance")

local default_style = require("druid.styles.default.style")


---Entry point for Druid UI Framework.
---Create a new Druid instance and adjust the Druid settings here.
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

	return druid_instance.create_druid_instance(context, style)
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


---@type table<userdata, {path: string, fragment: string, new_widget: event}[]>
local REGISTERED_GUI_WIDGETS = {}

---Set a widget to the current game object. The game object can acquire the widget by calling `bindings.get_widget`
---It wraps with events only top level functions cross-context, so you will have no access to nested widgets functions
---@param widget druid.widget
---@return druid.widget
local function wrap_widget(widget)
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

	return wrapped_widget
end


---Create a widget from the binded Druid GUI instance.
---The widget will be created and all widget functions can be called from Game Object contexts.
---This allow use only `druid_widget.gui_script` for GUI files and call this widget functions from Game Object script file.
---Widget class here is a your lua file for the GUI scene (a widgets in Druid)
---		msg.url(nil, nil, "gui_widget") -- current game object
---		msg.url(nil, object_url, "gui_widget") -- other game object
---@generic T: druid.widget
---@param widget_class T The class of the widget to return
---@param gui_url url GUI url
---@return T? widget The new created widget,
function M.get_widget(widget_class, gui_url)
	gui_url = gui_url or msg.url()
	local registered_druids = REGISTERED_GUI_WIDGETS[gui_url.socket]
	if not registered_druids then
		return nil
	end

	for index = 1, #registered_druids do
		local druid = registered_druids[index]
		if druid.fragment == gui_url.fragment and druid.path == gui_url.path then
			return druid.new_widget:trigger(widget_class)
		end
	end

	return nil
end


---Bind a Druid GUI instance to the current game object.
---This instance now can produce widgets from `druid.get_widget()` function.
---Only one widget can be set per game object.
---@param druid druid.instance The druid instance to register
function M.register_druid_as_widget(druid)
	local gui_url = msg.url()
	REGISTERED_GUI_WIDGETS[gui_url.socket] = REGISTERED_GUI_WIDGETS[gui_url.socket] or {}
	table.insert(REGISTERED_GUI_WIDGETS[gui_url.socket], {
		path = gui_url.path,
		fragment = gui_url.fragment,
		new_widget = event.create(function(widget_class)
			return wrap_widget(druid:new_widget(widget_class))
		end),
	})
end


---Should be called on final, where druid instance is destroyed.
function M.unregister_druid_as_widget()
	local gui_url = msg.url()
	local socket = gui_url.socket
	local path = gui_url.path
	local fragment = gui_url.fragment

	for index = 1, #REGISTERED_GUI_WIDGETS[socket] do
		local gui = REGISTERED_GUI_WIDGETS[socket][index]
		if gui.path == path and gui.fragment == fragment then
			table.remove(REGISTERED_GUI_WIDGETS[socket], index)
			break
		end
	end

	if #REGISTERED_GUI_WIDGETS[socket] == 0 then
		REGISTERED_GUI_WIDGETS[socket] = nil
	end
end


return M
