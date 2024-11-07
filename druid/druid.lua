local const = require("druid.const")
local settings = require("druid.system.settings")
local base_component = require("druid.component")
local druid_instance = require("druid.system.druid_instance")

local default_style = require("druid.styles.default.style")

---@class druid
local M = {}
local druid_instances = {}


local function clean_deleted_druid_instances()
	for i = #druid_instances, 1, -1 do
		if druid_instances[i]._deleted then
			table.remove(druid_instances, i)
		end
	end
end


local function get_druid_instances()
	clean_deleted_druid_instances()
	return druid_instances
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


---Create a new Druid instance for creating GUI components.
---@param context table The Druid context. Usually, this is the self of the gui_script. It is passed into all Druid callbacks.
---@param style table|nil The Druid style table to override style parameters for this Druid instance.
---@return druid_instance druid_instance The new Druid instance
function M.new(context, style)
	clean_deleted_druid_instances()

	if settings.default_style == nil then
		M.set_default_style(default_style)
	end

	local new_instance = setmetatable({}, { __index = druid_instance })
	new_instance:initialize(context, style)

	table.insert(druid_instances, new_instance)
	return new_instance
end


---Set the default style for all Druid instances.
---@param style table Default style
function M.set_default_style(style)
	settings.default_style = style or {}
end


---Set the text function for the LangText component.
---@param callback fun(text_id: string): string Get localized text function
function M.set_text_function(callback)
	settings.get_text = callback or const.EMPTY_FUNCTION
	M.on_language_change()
end


---Set the sound function to able components to play sounds.
---@param callback fun(sound_id: string) Sound play callback
function M.set_sound_function(callback)
	settings.play_sound = callback or const.EMPTY_FUNCTION
end


---Set the window callback to enable Druid window events.
---@param event constant Event param from window listener
function M.on_window_callback(event)
	local instances = get_druid_instances()

	if event == window.WINDOW_EVENT_FOCUS_LOST then
		for i = 1, #instances do
			msg.post(instances[i].url, base_component.ON_FOCUS_LOST)
		end
	elseif event == window.WINDOW_EVENT_FOCUS_GAINED then
		for i = 1, #instances do
			msg.post(instances[i].url, base_component.ON_FOCUS_GAINED)
		end
	elseif event == window.WINDOW_EVENT_RESIZED then
		for i = 1, #instances do
			msg.post(instances[i].url, base_component.ON_WINDOW_RESIZED)
		end
	end
end


---Call this function when the game language changes.
---It will notify all Druid instances to update the lang text components.
function M.on_language_change()
	local instances = get_druid_instances()

	for i = 1, #instances do
		msg.post(instances[i].url, base_component.ON_LANGUAGE_CHANGE)
	end
end


return M
