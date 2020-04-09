--- Druid main class. Create instance of this
-- to start creating components
-- @module druid_instance
-- @see druid.button
-- @see druid.blocker
-- @see druid.back_handler
-- @see druid.input
-- @see druid.text
-- @see druid.lang_text
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
local hover = require("druid.base.hover")
local text = require("druid.base.text")
local lang_text = require("druid.base.lang_text")
local timer = require("druid.base.timer")
local progress = require("druid.base.progress")
local grid = require("druid.base.grid")
local scroll = require("druid.base.scroll")
local slider = require("druid.base.slider")
local checkbox = require("druid.base.checkbox")
local checkbox_group = require("druid.base.checkbox_group")
local radio_group = require("druid.base.radio_group")
local input = require("druid.base.input")
-- local infinity_scroll = require("druid.base.infinity_scroll")

-- @classmod Druid
local Druid = class("druid.druid_instance")


local function input_init(self)
	if sys.get_config("druid.no_auto_input") == "1" then
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


local function process_input(action_id, action, components, is_input_consumed)
	if not components then
		return is_input_consumed
	end

	for i = #components, 1, -1 do
		local component = components[i]

		if not is_input_consumed then
			is_input_consumed = component:on_input(action_id, action)
		else
			if component.on_input_interrupt then
				component:on_input_interrupt()
			end
		end
	end

	return is_input_consumed
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


--- Call on final function on gui_script. It will call on_remove
-- on all druid components
-- @function druid:final
function Druid.final(self)
	local components = self.components[const.ALL]

	for i = #components, 1, -1 do
		if components[i].on_remove then
			components[i]:on_remove()
		end
	end
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
	local is_input_consumed = false

	is_input_consumed = process_input(action_id, action,
		self.components[const.ON_INPUT_HIGH], is_input_consumed)

	is_input_consumed = process_input(action_id, action,
		self.components[const.ON_INPUT], is_input_consumed)

	return is_input_consumed
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
		local components = self.components[const.ON_MESSAGE]
		if components then
			for i = 1, #components do
				components[i]:on_message(message_id, message, sender)
			end
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


--- Create hover basic component
-- @function druid:new_hover
-- @tparam args ... hover init args
-- @treturn Component hover component
function Druid.new_hover(self, ...)
	return Druid.create(self, hover, ...)
end


--- Create text basic component
-- @function druid:new_text
-- @tparam args ... text init args
-- @treturn Component text component
function Druid.new_text(self, ...)
	return Druid.create(self, text, ...)
end


--- Create lang_text basic component
-- @function druid:new_lang_text
-- @tparam args ... lang_text init args
-- @treturn Component lang_text component
function Druid.new_lang_text(self, ...)
	return Druid.create(self, lang_text, ...)
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


--- Create input basic component
-- @function druid:new_input
-- @tparam args ... input init args
-- @treturn Component input component
function Druid.new_input(self, ...)
	return Druid.create(self, input, ...)
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


return Druid
