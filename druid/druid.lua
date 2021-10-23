-- Copyright (c) 2021 Maxim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Druid UI Library.
-- Powerful Defold component based UI library. Use standart
-- components or make your own game-specific components to
-- make amazing GUI in your games.
--
-- Contains the several basic components and examples
-- to how to do your custom complex components to
-- separate UI game logic to small files
--
--    require("druid.druid")
--    function init(self)
--        self.druid = druid.new(self)
--    end
--
-- @module druid

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


--- Register external druid component.
-- After register you can create the component with
-- druid_instance:new_{name}. For example `druid:new_button(...)`
-- @function druid:register
-- @tparam string name module name
-- @tparam table module lua table with component
function M.register(name, module)
	-- TODO: Find better solution to creating elements?
	-- Current way is very implicit
	druid_instance["new_" .. name] = function(self, ...)
		return druid_instance.new(self, module, ...)
	end
end


--- Create Druid instance.
-- @function druid.new
-- @tparam table context Druid context. Usually it is self of script
-- @tparam[opt] table style Druid style module
-- @treturn druid_instance Druid instance
function M.new(context, style)
	if settings.default_style == nil then
		M.set_default_style(default_style)
	end

	local new_instance = druid_instance(context, style)
	table.insert(_instances, new_instance)
	return new_instance
end


--- Set new default style.
-- @function druid.set_default_style
-- @tparam table style Druid style module
function M.set_default_style(style)
	settings.default_style = style or {}
end


--- Set text function
-- Druid locale component will call this function
-- to get translated text. After set_text_funtion
-- all existing locale component will be updated
-- @function druid.set_text_function
-- @tparam function callback Get localized text function
function M.set_text_function(callback)
	settings.get_text = callback or const.EMPTY_FUNCTION
	M.on_language_change()
end


--- Set sound function.
-- Component will call this function to
-- play sound by sound_id
-- @function druid.set_sound_function
-- @tparam function callback Sound play callback
function M.set_sound_function(callback)
	settings.play_sound = callback or const.EMPTY_FUNCTION
end


--- Callback on global window event.
-- Used to trigger on_focus_lost and on_focus_gain
-- @function druid.on_window_callback
-- @tparam string event Event param from window listener
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
end


--- Callback on global layout change event.
-- @function druid.on_layout_change
function M.on_layout_change()
	local instances = get_druid_instances()

	for i = 1, #instances do
		msg.post(instances[i].url, base_component.ON_LAYOUT_CHANGE)
	end
end


--- Callback on global language change event.
-- Use to update all lang texts
-- @function druid.on_language_change
function M.on_language_change()
	local instances = get_druid_instances()

	for i = 1, #instances do
		msg.post(instances[i].url, base_component.ON_LANGUAGE_CHANGE)
	end
end


return M
