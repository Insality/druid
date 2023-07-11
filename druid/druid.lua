-- Copyright (c) 2021 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Druid UI Component Framework.
-- <b># Overview #</b>
--
-- Druid - powerful Defold component UI library. Use basic and extended
-- Druid components or make your own game-specific components to make
-- amazing GUI in your games.
--
-- To start using Druid, please refer to the Basic Usage section below.
--
-- <b># Notes #</b>
--
-- • Each Druid instance maintains the self context from the constructor and passes it to each Druid callback.
--
-- See next: @{DruidInstance}
--
-- @usage
-- local druid = require("druid.druid")
--
-- local function on_play(self)
--     print("Gonna play!")
-- end
--
-- function init(self)
--     self.druid = druid.new(self)
--     self.druid:new_button("button_play", on_play)
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


--- Register a new external Druid component.
--
-- You can register your own components to make new alias: the druid:new_{name} function.
-- For example, if you want to register a component called "my_component", you can create it using druid:new_my_component(...).
-- This can be useful if you have your own "basic" components that you don't want to re-create each time.
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
	druid_instance["new_" .. name] = function(self, ...)
		return druid_instance.new(self, module, ...)
	end
end


--- Create a new Druid instance for creating GUI components.
--
-- @function druid.new
-- @tparam table context The Druid context. Usually, this is the self of the gui_script. It is passed into all Druid callbacks.
-- @tparam[opt] table style The Druid style table to override style parameters for this Druid instance.
-- @treturn druid_instance The Druid instance @{DruidInstance}.
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
-- To create your own style file, copy the default style file and make changes to it.
-- Register the new style before creating your Druid instances.
-- @function druid.set_default_style
-- @tparam table style Druid style module
-- @usage
-- local my_style = require("path.to.my.style")
-- druid.set_default_style(my_style)
function M.set_default_style(style)
	settings.default_style = style or {}
end


--- Set the text function for the LangText component.
--
-- The Druid locale component will call this function to get translated text.
-- After setting the text function, all existing locale components will be updated.
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


--- Set the Druid sound function to play UI sounds if used.
--
-- Set a function to play a sound given a sound_id. This function is used for button clicks to play the "click" sound.
-- It can also be used to play sounds in your custom components (see the default Druid style file for an example).
-- @function druid.set_sound_function
-- @tparam function callback Sound play callback
-- @usage
-- druid.set_sound_function(function(sound_id)
--     sound.play(sound_id) -- Replace with your real function
-- end)
function M.set_sound_function(callback)
	settings.play_sound = callback or const.EMPTY_FUNCTION
end


--- Set the window callback to enable on_focus_gain and on_focus_lost functions.
--
-- This is used to trigger the on_focus_lost and on_focus_gain functions in Druid components.
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


--- Call this function when the game language changes.
--
-- This function will translate all current LangText components.
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
