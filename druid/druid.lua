-- Copyright (c) 2021 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Druid UI Component Framework.
-- # Overview #
--
-- Druid - powerful Defold component UI library. Use basic and extended
-- Druid components or make your own game-specific components to make
-- amazing GUI in your games.
--
-- To start use Druid, check the Basic Usage below.
--
-- # Tech Info #
--
-- - Each Druid keeps the self context from constructor to pass it into each Druid callback
--
-- See next: @{DruidInstance}
--
-- @usage
-- local druid = require("druid.druid")
--
-- local function button_callback(self)
--     print("Button was clicked!")
-- end
--
-- function init(self)
--     self.druid = druid.new(self)
--     self.druid:new_button("button_node_name", button_callback)
-- end
--
-- function final(self)
--     self.druid:final()
-- end
--
-- function update(self, dt)
--     self.druid:update(dt)
-- end
--
-- function on_message(self, message_id, message, sender)
--     self.druid:on_message(message_id, message, sender)
-- end
--
-- function on_input(self, action_id, action)
--     return self.druid:on_input(action_id, action)
-- end
--
-- @module Druid

local const = require("druid.const")
local base_component = require("druid.component")
local settings = require("druid.system.settings")
local druid_instance = require("druid.system.druid_instance")

local default_style = require("druid.styles.default.style")

local M = {}

local _instances = {}

local function get_druid_instances()
	for i = #_instances, 1, -1 do
		if _instances[i]._deleted then
			table.remove(_instances, i)
		end
	end

	return _instances
end


--- Register new external Druid component.
--
-- You can register your own components to create it with druid:new_{name} function
-- For example, you can register your own component "my_component" and create it with druid:new_my_component(...)
-- @function druid.register
-- @tparam string name module name
-- @tparam table module lua table with component
-- @usage
-- local my_component = require("path.to.my.component")
-- druid.register("my_component", my_component)
-- ...
-- local druid = druid.new(self)
-- local component_instance = self.druid:new_my_component(...)
function M.register(name, module)
	-- TODO: Find better solution to creating elements?
	-- Current way is very implicit
	druid_instance["new_" .. name] = function(self, ...)
		return druid_instance.new(self, module, ...)
	end
end


--- Create new Druid instance to create GUI components.
-- @function druid.new
-- @tparam table context Druid context. Usually it is *self* of *gui_script. It passes into all Druid callbacks
-- @tparam[opt] table style Druid style table to override style params for this Druid instance
-- @treturn druid_instance Druid instance @{DruidInstance}
-- @usage
-- local druid = require("druid.druid")
--
-- function init(self)
--    self.druid = druid.new(self)
-- end
function M.new(context, style)
	if settings.default_style == nil then
		M.set_default_style(default_style)
	end

	local new_instance = druid_instance(context, style)
	table.insert(_instances, new_instance)
	return new_instance
end


--- Set your own default style for all Druid instances.
--
-- To create your own style file, copy the default style file and change it.
-- Register new style before your Druid instances creation.
-- @function druid.set_default_style
-- @tparam table style Druid style module
-- @usage
-- local my_style = require("path.to.my.style")
-- druid.set_default_style(my_style)
function M.set_default_style(style)
	settings.default_style = style or {}
end


--- Set text function for LangText component.
--
-- Druid locale component will call this function to get translated text. After set_text_funtion
-- all existing locale component will be updated
-- @function druid.set_text_function
-- @tparam function callback Get localized text function
-- @usage
-- druid.set_text_function(function(text_id)
--    return lang_data[text_id] -- Replace with your real function
-- end)
function M.set_text_function(callback)
	settings.get_text = callback or const.EMPTY_FUNCTION
	M.on_language_change()
end


--- Set Druid sound function to play UI sounds if used.
--
-- Set function to play sound by sound_id. It used in Button click and play "click" sound.
-- Also can be used by play sound in your custom components (see default Druid style file for example)
-- @function druid.set_sound_function
-- @tparam function callback Sound play callback
-- @usage
-- druid.set_sound_function(function(sound_id)
--     sound.play(sound_id) -- Replace with your real function
-- end)
function M.set_sound_function(callback)
	settings.play_sound = callback or const.EMPTY_FUNCTION
end


--- Set window callback to enable *on_focus_gain* and *on_focus_lost* functions.
--
-- Used to trigger on_focus_lost and on_focus_gain in Druid components
-- @function druid.on_window_callback
-- @tparam string event Event param from window listener
-- @usage
-- window.set_listener(function(_, event)
--    druid.on_window_callback(event)
-- end)
function M.on_window_callback(event)
	local instances = get_druid_instances()

	if event == window.WINDOW_EVENT_FOCUS_LOST then
		for i = 1, #instances do
			msg.post(instances[i].url, base_component.ON_FOCUS_LOST)
		end
	end

	if event == window.WINDOW_EVENT_FOCUS_GAINED then
		for i = 1, #instances do
			msg.post(instances[i].url, base_component.ON_FOCUS_GAINED)
		end
	end

	if event == window.WINDOW_EVENT_RESIZED then
		for i = 1, #instances do
			msg.post(instances[i].url, base_component.ON_WINDOW_RESIZED)
		end
	end
end


--- Call this on game language change.
--
-- This function will update all LangText components
-- @function druid.on_language_change
-- @usage
-- druid.on_language_change()
function M.on_language_change()
	local instances = get_druid_instances()

	for i = 1, #instances do
		msg.post(instances[i].url, base_component.ON_LANGUAGE_CHANGE)
	end
end


return M
