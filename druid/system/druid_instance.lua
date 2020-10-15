--- Instance of Druid. Make one instance per gui_script with next code:
--
--    local druid = require("druid.druid")
--    function init(self)
--        self.druid = druid.new(self)
--        local button = self.druid:new_button(...)
--    end
--
-- Learn Druid instance function here
-- @module DruidInstance
-- @alias druid_instance
-- @see Button
-- @see Blocker
-- @see BackHandler
-- @see Input
-- @see Text
-- @see LangText
-- @see Timer
-- @see Progress
-- @see StaticGrid
-- @see DynamicGrid
-- @see Scroll
-- @see Slider
-- @see Checkbox
-- @see CheckboxGroup
-- @see RadioGroup
-- @see Swipe
-- @see Drag
-- @see Hover

local const = require("druid.const")
local helper = require("druid.helper")
local druid_input = require("druid.helper.druid_input")
local settings = require("druid.system.settings")
local class = require("druid.system.middleclass")

local back_handler = require("druid.base.back_handler")
local blocker = require("druid.base.blocker")
local button = require("druid.base.button")
local drag = require("druid.base.drag")
local hover = require("druid.base.hover")
local scroll = require("druid.base.scroll")
local static_grid = require("druid.base.static_grid")
local swipe = require("druid.base.swipe")
local text = require("druid.base.text")

local checkbox = require("druid.extended.checkbox")
local checkbox_group = require("druid.extended.checkbox_group")
local dynamic_grid = require("druid.extended.dynamic_grid")
local input = require("druid.extended.input")
local lang_text = require("druid.extended.lang_text")
local progress = require("druid.extended.progress")
local radio_group = require("druid.extended.radio_group")
local slider = require("druid.extended.slider")
local timer = require("druid.extended.timer")


local DruidInstance = class("druid.druid_instance")


local function input_init(self)
	if sys.get_config("druid.no_auto_input") == "1" then
		return
	end

	if not self.input_inited then
		self.input_inited = true
		druid_input.focus()
	end
end


local function input_release(self)
	if sys.get_config("druid.no_auto_input") == "1" then
		return
	end

	if self.input_inited then
		self.input_inited = false
		druid_input.remove()
	end
end


-- Create the component itself
local function create(self, instance_class)
	local instance = instance_class()
	instance:setup_component(self, self._context, self._style)

	table.insert(self.components[const.ALL], instance)

	local register_to = instance:__get_interests()
	for i = 1, #register_to do
		local interest = register_to[i]
		table.insert(self.components[interest], instance)

		if const.UI_INPUT[interest] then
			input_init(self)
		end
	end

	return instance
end


local function process_input(action_id, action, components, is_input_consumed)
	if #components == 0 then
		return is_input_consumed
	end

	for i = #components, 1, -1 do
		local component = components[i]
		-- Process increased input priority first
		local meta = component._meta
		if meta.input_enabled and meta.increased_input_priority then
			if not is_input_consumed then
				is_input_consumed = component:on_input(action_id, action)
			else
				if component.on_input_interrupt then
					component:on_input_interrupt()
				end
			end
		end
	end

	for i = #components, 1, -1 do
		local component = components[i]
		-- Process usual input priority next
		local meta = component._meta
		if meta.input_enabled and not meta.increased_input_priority then
			if not is_input_consumed then
				is_input_consumed = component:on_input(action_id, action)
			else
				if component.on_input_interrupt then
					component:on_input_interrupt()
				end
			end
		end
	end

	return is_input_consumed
end


--- Druid class constructor
-- @tparam DruidInstance self
-- @tparam table context Druid context. Usually it is self of script
-- @tparam table style Druid style module
function DruidInstance.initialize(self, context, style)
	self._context = context
	self._style = style or settings.default_style
	self._deleted = false
	self._is_input_processing = false
	self._late_remove = {}
	self.url = msg.url()

	self.components = {}
	for i = 1, #const.ALL_INTERESTS do
		self.components[const.ALL_INTERESTS[i]] = {}
	end
end


--- Create new druid component
-- @tparam DruidInstance self
-- @tparam Component component Component module
-- @tparam args ... Other component params to pass it to component:init function
function DruidInstance.create(self, component, ...)
	local instance = create(self, component)

	if instance.init then
		instance:init(...)
	end

	return instance
end


--- Call on final function on gui_script. It will call on_remove
-- on all druid components
-- @tparam DruidInstance self
function DruidInstance.final(self)
	local components = self.components[const.ALL]

	for i = #components, 1, -1 do
		if components[i].on_remove then
			components[i]:on_remove()
		end
	end

	self._deleted = true

	input_release(self)
end


--- Remove component from druid instance.
-- Component `on_remove` function will be invoked, if exist.
-- @tparam DruidInstance self
-- @tparam Component component Component instance
function DruidInstance.remove(self, component)
	if self._is_input_processing then
		table.insert(self._late_remove, component)
		return
	end

	-- Recursive remove all children of component
	local children = component._meta.children
	for i = #children, 1, -1do
		self:remove(children[i])
		local parent = children[i]:get_parent_component()
		if parent then
			parent:__remove_children(children[i])
		end
	end
	component._meta.children = {}

	local all_components = self.components[const.ALL]
	for i = #all_components, 1, -1 do
		if all_components[i] == component then
			if component.on_remove then
				component:on_remove()
			end
			table.remove(all_components, i)
		end
	end

	local interests = component:__get_interests()
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


--- Druid update function
-- @tparam DruidInstance self
-- @tparam number dt Delta time
function DruidInstance.update(self, dt)
	local components = self.components[const.ON_UPDATE]
	for i = 1, #components do
		components[i]:update(dt)
	end
end


--- Druid on_input function
-- @tparam DruidInstance self
-- @tparam hash action_id Action_id from on_input
-- @tparam table action Action from on_input
function DruidInstance.on_input(self, action_id, action)
	self._is_input_processing = true

	local is_input_consumed = false

	is_input_consumed = process_input(action_id, action,
		self.components[const.ON_INPUT_HIGH], is_input_consumed)

	is_input_consumed = process_input(action_id, action,
		self.components[const.ON_INPUT], is_input_consumed)

	self._is_input_processing = false

	if #self._late_remove > 0 then
		for i = 1, #self._late_remove do
			self:remove(self._late_remove[i])
		end
		self._late_remove = {}
	end

	return is_input_consumed
end


--- Druid on_message function
-- @tparam DruidInstance self
-- @tparam hash message_id Message_id from on_message
-- @tparam table message Message from on_message
-- @tparam hash sender Sender from on_message
function DruidInstance.on_message(self, message_id, message, sender)
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
		for i = 1, #components do
			components[i]:on_message(message_id, message, sender)
		end
	end
end


--- Druid on focus lost interest function.
-- This one called by on_window_callback by global window listener
-- @tparam DruidInstance self
function DruidInstance.on_focus_lost(self)
	local components = self.components[const.ON_FOCUS_LOST]
	for i = 1, #components do
		components[i]:on_focus_lost()
	end
end


--- Druid on focus gained interest function.
-- This one called by on_window_callback by global window listener
-- @tparam DruidInstance self
function DruidInstance.on_focus_gained(self)
	local components = self.components[const.ON_FOCUS_GAINED]
	for i = 1, #components do
		components[i]:on_focus_gained()
	end
end


--- Druid on layout change function.
-- Called on update gui layout
-- @tparam DruidInstance self
function DruidInstance.on_layout_change(self)
	local components = self.components[const.ON_LAYOUT_CHANGE]
	for i = 1, #components do
		components[i]:on_layout_change()
	end
end


--- Druid on language change.
-- This one called by global gruid.on_language_change, but can be
-- call manualy to update all translations
-- @function druid.on_language_change
function DruidInstance.on_language_change(self)
	local components = self.components[const.ON_LANGUAGE_CHANGE]
	for i = 1, #components do
		components[i]:on_language_change()
	end
end


--- Create button basic component
-- @tparam DruidInstance self
-- @tparam args ... button init args
-- @treturn Button button component
function DruidInstance.new_button(self, ...)
	return DruidInstance.create(self, button, ...)
end


--- Create blocker basic component
-- @tparam DruidInstance self
-- @tparam args ... blocker init args
-- @treturn Blocker blocker component
function DruidInstance.new_blocker(self, ...)
	return DruidInstance.create(self, blocker, ...)
end


--- Create back_handler basic component
-- @tparam DruidInstance self
-- @tparam args ... back_handler init args
-- @treturn BackHandler back_handler component
function DruidInstance.new_back_handler(self, ...)
	return DruidInstance.create(self, back_handler, ...)
end


--- Create hover basic component
-- @tparam DruidInstance self
-- @tparam args ... hover init args
-- @treturn Hover hover component
function DruidInstance.new_hover(self, ...)
	return DruidInstance.create(self, hover, ...)
end


--- Create text basic component
-- @tparam DruidInstance self
-- @tparam args ... text init args
-- @treturn Tet text component
function DruidInstance.new_text(self, ...)
	return DruidInstance.create(self, text, ...)
end


--- Create grid basic component
-- Deprecated
-- @tparam DruidInstance self
-- @tparam args ... grid init args
-- @treturn StaticGrid grid component
function DruidInstance.new_grid(self, ...)
	helper.deprecated("The druid:new_grid is deprecated. Please use druid:new_static_grid instead")
	return DruidInstance.create(self, static_grid, ...)
end


--- Create static grid basic component
-- @tparam DruidInstance self
-- @tparam args ... grid init args
-- @treturn StaticGrid grid component
function DruidInstance.new_static_grid(self, ...)
	return DruidInstance.create(self, static_grid, ...)
end


--- Create scroll basic component
-- @tparam DruidInstance self
-- @tparam args ... scroll init args
-- @treturn Scroll scroll component
function DruidInstance.new_scroll(self, ...)
	return DruidInstance.create(self, scroll, ...)
end


--- Create swipe basic component
-- @tparam DruidInstance self
-- @tparam args ... swipe init args
-- @treturn Swipe swipe component
function DruidInstance.new_swipe(self, ...)
	return DruidInstance.create(self, swipe, ...)
end


--- Create drag basic component
-- @tparam DruidInstance self
-- @tparam args ... drag init args
-- @treturn Drag drag component
function DruidInstance.new_drag(self, ...)
	return DruidInstance.create(self, drag, ...)
end


--- Create dynamic grid component
-- @tparam DruidInstance self
-- @tparam args ... grid init args
-- @treturn DynamicGrid grid component
function DruidInstance.new_dynamic_grid(self, ...)
	-- return helper.extended_component("dynamic_grid")
	return DruidInstance.create(self, dynamic_grid, ...)
end


--- Create lang_text component
-- @tparam DruidInstance self
-- @tparam args ... lang_text init args
-- @treturn LangText lang_text component
function DruidInstance.new_lang_text(self, ...)
		-- return helper.extended_component("lang_text")
	return DruidInstance.create(self, lang_text, ...)
end


--- Create slider component
-- @tparam DruidInstance self
-- @tparam args ... slider init args
-- @treturn Slider slider component
function DruidInstance.new_slider(self, ...)
	-- return helper.extended_component("slider")
	return DruidInstance.create(self, slider, ...)
end


--- Create checkbox component
-- @tparam DruidInstance self
-- @tparam args ... checkbox init args
-- @treturn Checkbox checkbox component
function DruidInstance.new_checkbox(self, ...)
	-- return helper.extended_component("checkbox")
	return DruidInstance.create(self, checkbox, ...)
end


--- Create input component
-- @tparam DruidInstance self
-- @tparam args ... input init args
-- @treturn Input input component
function DruidInstance.new_input(self, ...)
	-- return helper.extended_component("input")
	return DruidInstance.create(self, input, ...)
end


--- Create checkbox_group component
-- @tparam DruidInstance self
-- @tparam args ... checkbox_group init args
-- @treturn CheckboxGroup checkbox_group component
function DruidInstance.new_checkbox_group(self, ...)
	-- return helper.extended_component("checkbox_group")
	return DruidInstance.create(self, checkbox_group, ...)
end


--- Create radio_group component
-- @tparam DruidInstance self
-- @tparam args ... radio_group init args
-- @treturn RadioGroup radio_group component
function DruidInstance.new_radio_group(self, ...)
	-- return helper.extended_component("radio_group")
	return DruidInstance.create(self, radio_group, ...)
end


--- Create timer component
-- @tparam DruidInstance self
-- @tparam args ... timer init args
-- @treturn Timer timer component
function DruidInstance.new_timer(self, ...)
	-- return helper.extended_component("timer")
	return DruidInstance.create(self, timer, ...)
end


--- Create progress component
-- @tparam DruidInstance self
-- @tparam args ... progress init args
-- @treturn Progress progress component
function DruidInstance.new_progress(self, ...)
	-- return helper.extended_component("progress")
	return DruidInstance.create(self, progress, ...)
end


return DruidInstance
