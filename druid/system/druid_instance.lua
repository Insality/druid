-- Copyright (c) 2021 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Druid Instance which you use for component creation.
--
-- # Component List #
--
-- For a list of all available components, please refer to the "See Also" section.
--
-- <b># Notes #</b>
--
-- Please review the following API pages:
--
-- @{Helper} - A useful set of functions for working with GUI nodes, such as centering nodes, get GUI scale ratio, etc
--
-- @{DruidEvent} - The core event system in Druid. Learn how to subscribe to any event in every Druid component.
--
-- @{BaseComponent} - The parent class of all Druid components. You can find all default component methods there.
--
-- # Tech Info #
--
-- • To use Druid, you need to create a Druid instance first. This instance is used to spawn components.
--
-- • When using Druid components, provide the node name as a string argument directly. Avoid calling gui.get_node() before passing it to the component. Because Druid can get nodes from template and cloned gui nodes.
--
-- • All Druid and component methods are called using the colon operator (e.g., self.druid:new_button()).
-- @usage
-- local druid = require("druid.druid")
--
-- local function close_window(self)
--     print("Yeah! You closed the game!")
-- end
--
-- function init(self)
--     self.druid = druid.new(self)
--
--     -- Call all druid instance function with ":" syntax:
--     local text = self.druid:new_text("text_header", "Hello Druid!")
--     local button = self.druid:new_button("button_close", close_window)
--
--     -- You not need to save component reference if not need it
--     self.druid:new_back_handler(close_window)
-- end
--
-- @module DruidInstance
-- @alias druid_instance
-- @see BackHandler
-- @see Blocker
-- @see Button
-- @see Checkbox
-- @see CheckboxGroup
-- @see DataList
-- @see Drag
-- @see DynamicGrid
-- @see Hotkey
-- @see Hover
-- @see Input
-- @see LangText
-- @see Layout
-- @see Progress
-- @see RadioGroup
-- @see RichInput
-- @see RichText
-- @see Scroll
-- @see Slider
-- @see StaticGrid
-- @see Swipe
-- @see Text
-- @see Timer

local helper = require("druid.helper")
local class = require("druid.system.middleclass")
local settings = require("druid.system.settings")
local base_component = require("druid.component")

local drag = require("druid.base.drag")
local text = require("druid.base.text")
local hover = require("druid.base.hover")
local scroll = require("druid.base.scroll")
local button = require("druid.base.button")
local blocker = require("druid.base.blocker")
local static_grid = require("druid.base.static_grid")
local back_handler = require("druid.base.back_handler")

-- To use this components, you should register them first
-- local input = require("druid.extended.input")
-- local swipe = require("druid.extended.swipe")
-- local slider = require("druid.extended.slider")
-- local checkbox = require("druid.extended.checkbox")
-- local progress = require("druid.extended.progress")
-- local data_list = require("druid.extended.data_list")
-- local lang_text = require("druid.extended.lang_text")
-- local timer_component = require("druid.extended.timer")
-- local radio_group = require("druid.extended.radio_group")
-- local dynamic_grid = require("druid.extended.dynamic_grid")
-- local checkbox_group = require("druid.extended.checkbox_group")

local DruidInstance = class("druid.druid_instance")

local PATH_OBJ = "."
local MSG_ADD_FOCUS = hash("acquire_input_focus")
local MSG_REMOVE_FOCUS = hash("release_input_focus")
local IS_NO_AUTO_INPUT = sys.get_config_int("druid.no_auto_input", 0) == 1

local function set_input_state(self, is_input_inited)
	if IS_NO_AUTO_INPUT or (self.input_inited == is_input_inited) then
		return
	end

	self.input_inited = is_input_inited
	if is_input_inited then
		msg.post(PATH_OBJ, MSG_ADD_FOCUS)
	else
		msg.post(PATH_OBJ, MSG_REMOVE_FOCUS)
	end
end


-- The a and b - two Druid components
-- @local
local function sort_input_comparator(a, b)
	local a_priority = a:get_input_priority()
	local b_priority = b:get_input_priority()

	if a_priority ~= b_priority then
		return a_priority < b_priority
	end

	return a:get_uid() < b:get_uid()
end


local function sort_input_stack(self)
	local input_components = self.components_interest[base_component.ON_INPUT]
	if not input_components then
		return
	end

	table.sort(input_components, sort_input_comparator)
end


-- Create the Druid component instance
local function create(self, instance_class)
	local instance = instance_class()
	instance:setup_component(self, self._context, self._style, instance_class)

	table.insert(self.components_all, instance)

	local register_to = instance:__get_interests()
	for i = 1, #register_to do
		local interest = register_to[i]
		table.insert(self.components_interest[interest], instance)
	end

	return instance
end


-- Before processing any input check if we need to update input stack
local function check_sort_input_stack(self, components)
	if not components or #components == 0 then
		return
	end

	local is_need_sort_input_stack = false

	for i = #components, 1, -1 do
		local component = components[i]
		if component:_is_input_priority_changed() then
			is_need_sort_input_stack = true
			component:_reset_input_priority_changed()
		end
	end

	if is_need_sort_input_stack then
		sort_input_stack(self)
	end
end


--- Check whitelists and blacklists for input components
local function can_use_input_component(self, component)
	local can_by_whitelist = true
	local can_by_blacklist = true

	if self._input_whitelist and #self._input_whitelist > 0 then
		can_by_whitelist = not not helper.contains(self._input_whitelist, component)
	end

	if self._input_blacklist and #self._input_blacklist > 0 then
		can_by_blacklist = not helper.contains(self._input_blacklist, component)
	end

	return can_by_blacklist and can_by_whitelist
end


local function process_input(self, action_id, action, components)
	local is_input_consumed = false

	if #components == 0 then
		return false
	end

	for i = #components, 1, -1 do
		local component = components[i]
		local meta = component._meta
		if meta.input_enabled and can_use_input_component(self, component) then
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


local function schedule_late_init(self)
	if self._late_init_timer_id then
		return
	end

	self._late_init_timer_id = timer.delay(0, false, function()
		self._late_init_timer_id = nil
		self:late_init()
	end)
end


--- Druid class constructor
-- @tparam DruidInstance self
-- @tparam table context Druid context. Usually it is self of gui script
-- @tparam table style Druid style table
-- @local
function DruidInstance.initialize(self, context, style)
	self._context = context
	self._style = style or settings.default_style
	self._deleted = false
	self._is_late_remove_enabled = false
	self._late_remove = {}
	self._is_debug = false
	self.url = msg.url()

	self._input_blacklist = nil
	self._input_whitelist = nil

	self.components_all = {}
	self.components_interest = {}
	for i = 1, #base_component.ALL_INTERESTS do
		self.components_interest[base_component.ALL_INTERESTS[i]] = {}
	end
end


--- Create new component.
-- @tparam DruidInstance self
-- @tparam Component component Component module
-- @tparam args ... Other component params to pass it to component:init function
function DruidInstance.new(self, component, ...)
	local instance = create(self, component)

	if instance.init then
		instance:init(...)
	end
	if instance.on_late_init or (not self.input_inited and instance.on_input) then
		schedule_late_init(self)
	end

	return instance
end


--- Call this in gui_script final function.
-- @tparam DruidInstance self
function DruidInstance.final(self)
	local components = self.components_all

	for i = #components, 1, -1 do
		if components[i].on_remove then
			components[i]:on_remove()
		end
	end

	self._deleted = true

	set_input_state(self, false)
end


--- Remove created component from Druid instance.
--
-- Component `on_remove` function will be invoked, if exist.
-- @tparam DruidInstance self
-- @tparam Component component Component instance
function DruidInstance.remove(self, component)
	if self._is_late_remove_enabled then
		table.insert(self._late_remove, component)
		return
	end

	-- Recursive remove all children of component
	local children = component._meta.children
	for i = #children, 1, -1 do
		self:remove(children[i])
		local parent = children[i]:get_parent_component()
		if parent then
			parent:__remove_children(children[i])
		end
		children[i] = nil
	end

	local all_components = self.components_all
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
		local components = self.components_interest[interest]
		for j = #components, 1, -1 do
			if components[j] == component then
				table.remove(components, j)
			end
		end
	end
end


--- Druid late update function called after initialization and before the regular update step
-- This function is used to check the GUI state and perform actions after all components and nodes have been created.
-- An example use case is performing an auto stencil check in the GUI hierarchy for input components.
-- @tparam DruidInstance self
-- @local
function DruidInstance.late_init(self)
	local late_init_components = self.components_interest[base_component.ON_LATE_INIT]
	while late_init_components[1] do
		late_init_components[1]:on_late_init()
		table.remove(late_init_components, 1)
	end

	if not self.input_inited and #self.components_interest[base_component.ON_INPUT] > 0 then
		-- Input init on late init step, to be sure it goes after user go acquire input
		set_input_state(self, true)
	end
end


--- Call this in gui_script update function.
--
-- Used for: scroll, progress, timer components
-- @tparam DruidInstance self
-- @tparam number dt Delta time
function DruidInstance.update(self, dt)
	self._is_late_remove_enabled = true

	local components = self.components_interest[base_component.ON_UPDATE]
	for i = 1, #components do
		components[i]:update(dt)
	end

	self._is_late_remove_enabled = false
	self:_clear_late_remove()
end


--- Call this in gui_script on_input function.
--
-- Used for almost all components
-- @tparam DruidInstance self
-- @tparam hash action_id Action_id from on_input
-- @tparam table action Action from on_input
-- @treturn bool The boolean value is input was consumed
function DruidInstance.on_input(self, action_id, action)
	self._is_late_remove_enabled = true

	local components = self.components_interest[base_component.ON_INPUT]
	check_sort_input_stack(self, components)
	local is_input_consumed = process_input(self, action_id, action, components)

	self._is_late_remove_enabled = false
	self:_clear_late_remove()

	return is_input_consumed
end


--- Call this in gui_script on_message function.
--
-- Used for special actions. See SPECIFIC_UI_MESSAGES table
-- @tparam DruidInstance self
-- @tparam hash message_id Message_id from on_message
-- @tparam table message Message from on_message
-- @tparam hash sender Sender from on_message
function DruidInstance.on_message(self, message_id, message, sender)
	local specific_ui_message = base_component.SPECIFIC_UI_MESSAGES[message_id]

	if specific_ui_message == base_component.ON_MESSAGE_INPUT then
		-- ON_MESSAGE_INPUT is special message, need to perform additional logic
		local components = self.components_interest[base_component.ON_MESSAGE_INPUT]
		if components then
			for i = 1, #components do
				local component = components[i]
				if can_use_input_component(self, component) then
					component[specific_ui_message](component, hash(message.node_id), message)
				end
			end
		end
	elseif specific_ui_message then
		-- Resend special message to all components with the related interest
		local components = self.components_interest[specific_ui_message]
		if components then
			for i = 1, #components do
				local component = components[i]
				component[specific_ui_message](component, message, sender)
			end
		end
	else
		-- Resend message to all components with on_message interest
		local components = self.components_interest[base_component.ON_MESSAGE]
		for i = 1, #components do
			components[i]:on_message(message_id, message, sender)
		end
	end
end


--- Calls the on_focus_lost function in all related components
-- This one called by on_window_callback by global window listener
-- @tparam DruidInstance self
-- @local
function DruidInstance.on_focus_lost(self)
	local components = self.components_interest[base_component.ON_FOCUS_LOST]
	for i = 1, #components do
		components[i]:on_focus_lost()
	end
end


--- Calls the on_focus_gained function in all related components
-- This one called by on_window_callback by global window listener
-- @tparam DruidInstance self
-- @local
function DruidInstance.on_focus_gained(self)
	local components = self.components_interest[base_component.ON_FOCUS_GAINED]
	for i = 1, #components do
		components[i]:on_focus_gained()
	end
end


--- Calls the on_language_change function in all related components
-- This one called by global druid.on_language_change, but can be
-- call manualy to update all translations
-- @tparam DruidInstance self
-- @local
function DruidInstance.on_language_change(self)
	local components = self.components_interest[base_component.ON_LANGUAGE_CHANGE]
	for i = 1, #components do
		components[i]:on_language_change()
	end
end


--- Set whitelist components for input processing.
--
-- If whitelist is not empty and component not contains in this list,
-- component will be not processed on input step
-- @tparam DruidInstance self
-- @tparam[opt=nil] table|Component whitelist_components The array of component to whitelist
-- @treturn self @{DruidInstance}
function DruidInstance.set_whitelist(self, whitelist_components)
	if whitelist_components and whitelist_components.isInstanceOf then
		whitelist_components = { whitelist_components }
	end

	for i = 1, #whitelist_components do
		helper.add_array(whitelist_components, whitelist_components[i]:get_childrens())
	end

	self._input_whitelist = whitelist_components

	return self
end


--- Set blacklist components for input processing.
--
-- If blacklist is not empty and component contains in this list,
-- component will be not processed on input step
-- @tparam DruidInstance self @{DruidInstance}
-- @tparam[opt=nil] table|Component blacklist_components The array of component to blacklist
-- @treturn self @{DruidInstance}
function DruidInstance.set_blacklist(self, blacklist_components)
	if blacklist_components and blacklist_components.isInstanceOf then
		blacklist_components = { blacklist_components }
	end

	for i = 1, #blacklist_components do
		helper.add_array(blacklist_components, blacklist_components[i]:get_childrens())
	end

	self._input_blacklist = blacklist_components

	return self
end


--- Set debug mode for current Druid instance. It's enable debug log messages
-- @tparam DruidInstance self @{DruidInstance}
-- @tparam bool is_debug
-- @treturn self @{DruidInstance}
-- @local
function DruidInstance.set_debug(self, is_debug)
	self._is_debug = is_debug
	return self
end


--- Log message, if is_debug mode is enabled
-- @tparam DruidInstance self @{DruidInstance}
-- @tparam string message
-- @tparam[opt] table context
-- @local
function DruidInstance.log_message(self, message, context)
	if not self._is_debug then
		return
	end

	print("[Druid]:", message, helper.table_to_string(context))
end


--- Remove all components on late remove step
-- @tparam DruidInstance self @{DruidInstance}
-- @local
function DruidInstance._clear_late_remove(self)
	if #self._late_remove == 0 then
		return
	end

	for i = 1, #self._late_remove do
		self:remove(self._late_remove[i])
	end
	self._late_remove = {}
end


--- Create @{Button} component
-- @tparam DruidInstance self
-- @tparam node node GUI node
-- @tparam function callback Button callback
-- @tparam[opt] table params Button callback params
-- @tparam[opt] node anim_node Button anim node (node, if not provided)
-- @treturn Button @{Button} component
function DruidInstance.new_button(self, node, callback, params, anim_node)
	return DruidInstance.new(self, button, node, callback, params, anim_node)
end


--- Create @{Blocker} component
-- @tparam DruidInstance self
-- @tparam node node Gui node
-- @treturn Blocker @{Blocker} component
function DruidInstance.new_blocker(self, node)
	return DruidInstance.new(self, blocker, node)
end


--- Create @{BackHandler} component
-- @tparam DruidInstance self
-- @tparam callback callback On back button
-- @tparam[opt] any params Callback argument
-- @treturn BackHandler @{BackHandler} component
function DruidInstance.new_back_handler(self, callback, params)
	return DruidInstance.new(self, back_handler, callback, params)
end


--- Create @{Hover} component
-- @tparam DruidInstance self
-- @tparam node node Gui node
-- @tparam function on_hover_callback Hover callback
-- @treturn Hover @{Hover} component
function DruidInstance.new_hover(self, node, on_hover_callback)
	return DruidInstance.new(self, hover, node, on_hover_callback)
end


--- Create @{Text} component
-- @tparam DruidInstance self
-- @tparam node node Gui text node
-- @tparam[opt] string value Initial text. Default value is node text from GUI scene.
-- @tparam[opt] bool no_adjust If true, text will be not auto-adjust size
-- @treturn Text @{Text} component
function DruidInstance.new_text(self, node, value, no_adjust)
	return DruidInstance.new(self, text, node, value, no_adjust)
end


--- Create @{StaticGrid} component
-- Deprecated
-- @tparam DruidInstance self
-- @tparam node parent The gui node parent, where items will be placed
-- @tparam node element Element prefab. Need to get it size
-- @tparam[opt=1] number in_row How many nodes in row can be placed
-- @treturn StaticGrid @{StaticGrid} component
-- @local
function DruidInstance.new_grid(self, parent, element, in_row)
	helper.deprecated("The druid:new_grid is deprecated. Please use druid:new_static_grid instead")
	return DruidInstance.new(self, static_grid, parent, element, in_row)
end


--- Create @{StaticGrid} component
-- @tparam DruidInstance self
-- @tparam node parent The gui node parent, where items will be placed
-- @tparam node element Element prefab. Need to get it size
-- @tparam[opt=1] number in_row How many nodes in row can be placed
-- @treturn StaticGrid @{StaticGrid} component
function DruidInstance.new_static_grid(self, parent, element, in_row)
	return DruidInstance.new(self, static_grid, parent, element, in_row)
end


--- Create @{Scroll} component
-- @tparam DruidInstance self
-- @tparam node view_node GUI view scroll node
-- @tparam node content_node GUI content scroll node
-- @treturn Scroll @{Scroll} component
function DruidInstance.new_scroll(self, view_node, content_node)
	return DruidInstance.new(self, scroll, view_node, content_node)
end


--- Create @{Drag} component
-- @tparam DruidInstance self
-- @tparam node node GUI node to detect dragging
-- @tparam function on_drag_callback Callback for on_drag_event(self, dx, dy)
-- @treturn Drag @{Drag} component
function DruidInstance.new_drag(self, node, on_drag_callback)
	return DruidInstance.new(self, drag, node, on_drag_callback)
end


--- Create @{Swipe} component
-- @tparam DruidInstance self
-- @tparam node node Gui node
-- @tparam function on_swipe_callback Swipe callback for on_swipe_end event
-- @treturn Swipe @{Swipe} component
function DruidInstance.new_swipe(self, node, on_swipe_callback)
	return helper.require_component_message("swipe")
end


--- Create @{DynamicGrid} component
-- @tparam DruidInstance self
-- @tparam node parent The gui node parent, where items will be placed
-- @treturn DynamicGrid @{DynamicGrid} component
function DruidInstance.new_dynamic_grid(self, parent)
	return helper.require_component_message("dynamic_grid")
end


--- Create @{LangText} component
-- @tparam DruidInstance self
-- @tparam node node The text node
-- @tparam string locale_id Default locale id
-- @tparam bool no_adjust If true, will not correct text size
-- @treturn LangText @{LangText} component
function DruidInstance.new_lang_text(self, node, locale_id, no_adjust)
	return helper.require_component_message("lang_text")
end


--- Create @{Slider} component
-- @tparam DruidInstance self
-- @tparam node node Gui pin node
-- @tparam vector3 end_pos The end position of slider
-- @tparam[opt] function callback On slider change callback
-- @treturn Slider @{Slider} component
function DruidInstance.new_slider(self, node, end_pos, callback)
	return helper.require_component_message("slider")
end


--- Create @{Checkbox} component
-- @tparam DruidInstance self
-- @tparam node node Gui node
-- @tparam function callback Checkbox callback
-- @tparam[opt=node] node click_node Trigger node, by default equals to node
-- @tparam[opt=false] boolean initial_state The initial state of checkbox, default - false
-- @treturn Checkbox @{Checkbox} component
function DruidInstance.new_checkbox(self, node, callback, click_node, initial_state)
	return helper.require_component_message("checkbox")
end


--- Create @{Input} component
-- @tparam DruidInstance self
-- @tparam node click_node Button node to enabled input component
-- @tparam node text_node Text node what will be changed on user input
-- @tparam[opt] number keyboard_type Gui keyboard type for input field
-- @treturn Input @{Input} component
function DruidInstance.new_input(self, click_node, text_node, keyboard_type)
	return helper.require_component_message("input")
end


--- Create @{CheckboxGroup} component
-- @tparam DruidInstance self
-- @tparam node[] nodes Array of gui node
-- @tparam function callback Checkbox callback
-- @tparam[opt=node] node[] click_nodes Array of trigger nodes, by default equals to nodes
-- @treturn CheckboxGroup @{CheckboxGroup} component
function DruidInstance.new_checkbox_group(self, nodes, callback, click_nodes)
	return helper.require_component_message("checkbox_group")
end


--- Create @{DataList} component
-- @tparam DruidInstance self
-- @tparam Scroll druid_scroll The Scroll instance for Data List component
-- @tparam Grid druid_grid The Grid instance for Data List component
-- @tparam function create_function The create function callback(self, data, index, data_list). Function should return (node, [component])
-- @treturn DataList @{DataList} component
function DruidInstance.new_data_list(self, druid_scroll, druid_grid, create_function)
	return helper.require_component_message("data_list")
end


--- Create @{RadioGroup} component
-- @tparam DruidInstance self
-- @tparam node[] nodes Array of gui node
-- @tparam function callback Radio callback
-- @tparam[opt=node] node[] click_nodes Array of trigger nodes, by default equals to nodes
-- @treturn RadioGroup @{RadioGroup} component
function DruidInstance.new_radio_group(self, nodes, callback, click_nodes)
	return helper.require_component_message("radio_group")
end


--- Create @{Timer} component
-- @tparam DruidInstance self
-- @tparam node node Gui text node
-- @tparam number seconds_from Start timer value in seconds
-- @tparam[opt=0] number seconds_to End timer value in seconds
-- @tparam[opt] function callback Function on timer end
-- @treturn Timer @{Timer} component
function DruidInstance.new_timer(self, node, seconds_from, seconds_to, callback)
	return helper.require_component_message("timer")
end


--- Create @{Progress} component
-- @tparam DruidInstance self
-- @tparam string|node node Progress bar fill node or node name
-- @tparam string key Progress bar direction: const.SIDE.X or const.SIDE.Y
-- @tparam[opt=1] number init_value Initial value of progress bar
-- @treturn Progress @{Progress} component
function DruidInstance.new_progress(self, node, key, init_value)
	return helper.require_component_message("progress")
end


--- Create @{Layout} component
-- @tparam DruidInstance self
-- @tparam string|node node Layout node
-- @tparam string mode The layout mode
-- @treturn Layout @{Layout} component
function DruidInstance.new_layout(self, node, mode)
	return helper.require_component_message("layout")
end


--- Create @{Hotkey} component
-- @tparam DruidInstance self
-- @tparam string|string[] keys_array Keys for trigger action. Should contains one action key and any amount of modificator keys
-- @tparam function callback Button callback
-- @tparam[opt] value params Button callback params
-- @treturn Hotkey @{Hotkey} component
function DruidInstance.new_hotkey(self, keys_array, callback, params)
	return helper.require_component_message("hotkey")
end


--- Create @{RichText} component.
-- As a template please check rich_text.gui layout.
-- @tparam DruidInstance self
-- @tparam[opt] string template Template name if used
-- @tparam[opt] table nodes Nodes table from gui.clone_tree
-- @treturn RichText @{RichText} component
function DruidInstance.new_rich_text(self, template, nodes)
	return helper.require_component_message("rich_text", "custom")
end


return DruidInstance
