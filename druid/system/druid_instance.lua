--- Druid main class. Create instance of this
-- to start creating components
-- @module druid_instance
-- @see druid.button
-- @see druid.blocker
-- @see druid.back_handler
-- @see druid.text
-- @see druid.locale
-- @see druid.timer
-- @see druid.progress
-- @see druid.grid
-- @see druid.scroll
-- @see druid.slider
-- @see druid.checkbox
-- @see druid.checkbox_group
-- @see druid.radio_group

local const = require("druid.const")
local druid_input = require("druid.helper.druid_input")
local settings = require("druid.system.settings")
local class = require("druid.system.middleclass")

local button = require("druid.base.button")
local blocker = require("druid.base.blocker")
local back_handler = require("druid.base.back_handler")
local text = require("druid.base.text")
local locale = require("druid.base.locale")
local timer = require("druid.base.timer")
local progress = require("druid.base.progress")
local grid = require("druid.base.grid")
local scroll = require("druid.base.scroll")
local slider = require("druid.base.slider")
local checkbox = require("druid.base.checkbox")
local checkbox_group = require("druid.base.checkbox_group")
local radio_group = require("druid.base.radio_group")
-- local input - require("druid.base.input")
-- local infinity_scroll = require("druid.base.infinity_scroll")
local progress_rich = require("druid.rich.progress_rich")

-- @classmod Druid
local Druid = class("druid.druid_instance")


local function input_init(self)
	-- TODO: To custom settings
	if not settings.auto_focus_gain then
		return
	end

	if not self.input_inited then
		self.input_inited = true
		druid_input.focus()
	end
end


-- Create the component itself
local function create(self, instance_class)
	local instance = instance_class()
	instance:setup_component(self._context, self._style)

	self.components[const.ALL] = self.components[const.ALL] or {}
	table.insert(self.components[const.ALL], instance)

	local register_to = instance:get_interests()
	if register_to then
		for i = 1, #register_to do
			local interest = register_to[i]
			if not self.components[interest] then
				self.components[interest] = {}
			end
			table.insert(self.components[interest], instance)

			if const.UI_INPUT[interest] then
				input_init(self)
			end
		end
	end

	return instance
end


local function notify_input_on_swipe(self)
	if self.components[const.ON_INPUT] then
		local len = #self.components[const.ON_INPUT]
		for i = len, 1, -1 do
			local comp = self.components[const.ON_INPUT][i]
			if comp.on_swipe then
				comp:on_swipe()
			end
		end
	end
end


local function match_event(action_id, events)
	if type(events) == const.TABLE then
		for i = 1, #events do
			if action_id == events[i] then
				return true
			end
		end
	else
		return action_id == events
	end
end


--- Druid class constructor
-- @function druid:initialize
-- @tparam context table Druid context. Usually it is self of script
-- @tparam style table Druid style module
function Druid.initialize(self, context, style)
	self._context = context
	self._style = style or settings.default_style
	self.components = {}
end


--- Create new druid component
-- @function druid:create
-- @tparam Component component Component module
-- @tparam args ... Other component params to pass it to component:init function
function Druid.create(self, component, ...)
	local instance = create(self, component)

	if instance.init then
		instance:init(...)
	end

	return instance
end


--- Remove component from druid instance.
-- Component `on_remove` function will be invoked, if exist.
-- @function druid:remove
-- @tparam Component component Component instance
function Druid.remove(self, component)
	local all_components = self.components[const.ALL]
	for i = #all_components, 1, -1 do
		if all_components[i] == component then
			if component.on_remove then
				component:on_remove()
			end
			table.remove(self, i)
		end
	end

	local interests = component:get_interests()
	if interests then
		for i = 1, #interests do
			local interest = interests[i]
			local components = self.components[interest]
			for j = #components, 1, -1 do
				if components[j] == component then
					table.remove(components, j)
				end
			end
		end
	end
end


--- Druid update function
-- @function druid:update
-- @tparam number dt Delta time
function Druid.update(self, dt)
	local components = self.components[const.ON_UPDATE]
	if components then
		for i = 1, #components do
			components[i]:update(dt)
		end
	end
end


--- Druid on_input function
-- @function druid:on_input
-- @tparam hash action_id Action_id from on_input
-- @tparam table action Action from on_input
function Druid.on_input(self, action_id, action)
	-- TODO: расписать отличия ON_SWIPE и ON_INPUT
	-- Почему-то некоторые используют ON_SWIPE, а логичнее ON_INPUT? (blocker, slider)
	local components = self.components[const.ON_SWIPE]
	if components then
		local result
		for i = #components, 1, -1 do
			local v = components[i]
			result = result or v:on_input(action_id, action)
		end
		if result then
			notify_input_on_swipe(self)
			return true
		end
	end

	components = self.components[const.ON_INPUT]
	if components then
		for i = #components, 1, -1 do
			local v = components[i]
			if match_event(action_id, v.event) and v:on_input(action_id, action) then
				return true
			end
		end
		return false
	end

	return false
end


--- Druid on_message function
-- @function druid:on_message
-- @tparam hash message_id Message_id from on_message
-- @tparam table message Message from on_message
-- @tparam hash sender Sender from on_message
function Druid.on_message(self, message_id, message, sender)
	local specific_ui_message = const.SPECIFIC_UI_MESSAGES[message_id]
	if specific_ui_message then
		local components = self.components[message_id]
		if components then
			for i = 1, #components do
				local component = components[i]
				component[specific_ui_message](component, message, sender)
			end
		end
	else
		local components = self.components[const.ON_MESSAGE] or const.EMPTY_TABLE
		for i = 1, #components do
			components[i]:on_message(message_id, message, sender)
		end
	end
end


--- Create button basic component
-- @function druid:new_button
-- @tparam args ... button init args
-- @treturn Component button component
function Druid.new_button(self, ...)
	return Druid.create(self, button, ...)
end


--- Create blocker basic component
-- @function druid:new_blocker
-- @tparam args ... blocker init args
-- @treturn Component blocker component
function Druid.new_blocker(self, ...)
	return Druid.create(self, blocker, ...)
end


--- Create back_handler basic component
-- @function druid:new_back_handler
-- @tparam args ... back_handler init args
-- @treturn Component back_handler component
function Druid.new_back_handler(self, ...)
	return Druid.create(self, back_handler, ...)
end


--- Create text basic component
-- @function druid:new_text
-- @tparam args ... text init args
-- @treturn Component text component
function Druid.new_text(self, ...)
	return Druid.create(self, text, ...)
end


--- Create locale basic component
-- @function druid:new_locale
-- @tparam args ... locale init args
-- @treturn Component locale component
function Druid.new_locale(self, ...)
	return Druid.create(self, locale, ...)
end


--- Create timer basic component
-- @function druid:new_timer
-- @tparam args ... timer init args
-- @treturn Component timer component
function Druid.new_timer(self, ...)
	return Druid.create(self, timer, ...)
end


--- Create progress basic component
-- @function druid:new_progress
-- @tparam args ... progress init args
-- @treturn Component progress component
function Druid.new_progress(self, ...)
	return Druid.create(self, progress, ...)
end


--- Create grid basic component
-- @function druid:new_grid
-- @tparam args ... grid init args
-- @treturn Component grid component
function Druid.new_grid(self, ...)
	return Druid.create(self, grid, ...)
end


--- Create scroll basic component
-- @function druid:new_scroll
-- @tparam args ... scroll init args
-- @treturn Component scroll component
function Druid.new_scroll(self, ...)
	return Druid.create(self, scroll, ...)
end


--- Create slider basic component
-- @function druid:new_slider
-- @tparam args ... slider init args
-- @treturn Component slider component
function Druid.new_slider(self, ...)
	return Druid.create(self, slider, ...)
end


--- Create checkbox basic component
-- @function druid:new_checkbox
-- @tparam args ... checkbox init args
-- @treturn Component checkbox component
function Druid.new_checkbox(self, ...)
	return Druid.create(self, checkbox, ...)
end


--- Create checkbox_group basic component
-- @function druid:new_checkbox_group
-- @tparam args ... checkbox_group init args
-- @treturn Component checkbox_group component
function Druid.new_checkbox_group(self, ...)
	return Druid.create(self, checkbox_group, ...)
end


--- Create radio_group basic component
-- @function druid:new_radio_group
-- @tparam args ... radio_group init args
-- @treturn Component radio_group component
function Druid.new_radio_group(self, ...)
	return Druid.create(self, radio_group, ...)
end


--- Create progress_rich basic component
-- @function druid:new_progress_rich
-- @tparam args ... progress_rich init args
-- @treturn Component progress_rich component
function Druid.new_progress_rich(self, ...)
	return Druid.create(self, progress_rich, ...)
end


return Druid
