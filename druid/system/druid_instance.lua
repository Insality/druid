-- Hello, Defolder! Wish you a good day!

local events = require("event.events")
local const = require("druid.const")
local helper = require("druid.helper")
local settings = require("druid.system.settings")
local druid_component = require("druid.component")

---The Druid Factory used to create components
---@class druid.instance
---@field package input_inited boolean Used to check if input is initialized
---@field package components_all druid.component[] All created components
---@field package components_interest table<string, druid.component[]> All components sorted by interest
---@field package _context table Druid context, usually a self of gui script
---@field package _style table Druid style table
---@field package _late_init_timer_id number Timer id for late init
---@field package _late_remove druid.component[] Components to be removed on late update
---@field package _is_late_remove_enabled boolean Used to check if components should be removed on late update
---@field package _input_blacklist druid.component[]|nil Components that should not receive input
---@field package _input_whitelist druid.component[]|nil Components that should receive input
local M = {}

local IS_NO_AUTO_INPUT = sys.get_config_int("druid.no_auto_input", 0) == 1
local INTERESTS_CACHE = {} -- Cache interests per component class in runtime
local DRUID_INSTANCE_METATABLE = { __index = M }

local function set_input_state(self, is_input_inited)
	if IS_NO_AUTO_INPUT or (self.input_inited == is_input_inited) then
		return
	end

	self.input_inited = is_input_inited
	msg.post(".", is_input_inited and "acquire_input_focus" or "release_input_focus")
end


---@private
---@param component_a druid.component
---@param component_b druid.component
---@return boolean
local function sort_input_comparator(component_a, component_b)
	local a_priority = component_a:get_input_priority()
	local b_priority = component_b:get_input_priority()

	if a_priority ~= b_priority then
		return a_priority < b_priority
	end

	return component_a:get_uid() < component_b:get_uid()
end


local function sort_input_stack(self)
	local input_components = self.components_interest[const.ON_INPUT]
	if not input_components then
		return
	end

	table.sort(input_components, sort_input_comparator)
end


---Get current component interests
---@param instance druid.component
---@return table interest_list List of component interests
local function get_component_interests(instance)
	---@diagnostic disable-next-line: invisible
	local instance_class = instance._meta.instance_class
	if INTERESTS_CACHE[instance_class] then
		return INTERESTS_CACHE[instance_class]
	end

	local interests = {}
	for index = 1, #const.ALL_INTERESTS do
		local interest = const.ALL_INTERESTS[index]
		if instance[interest] and type(instance[interest]) == "function" then
			table.insert(interests, interest)
		end
	end

	INTERESTS_CACHE[instance_class] = interests
	return INTERESTS_CACHE[instance_class]
end


---@private
---@param self druid.instance
---@param instance druid.component
local function register_interests(self, instance)
	table.insert(self.components_all, instance)
	local interest_list = get_component_interests(instance)
	for i = 1, #interest_list do
		local interest = interest_list[i]
		table.insert(self.components_interest[interest], instance)
	end
end


---Create the Druid component instance
---@param self druid.instance
---@param instance_class druid.component
---@return druid.component
local function create(self, instance_class)
	local instance = instance_class()
	instance:setup_component(self, self:get_context(), self:get_style(), instance_class)
	register_interests(self, instance)

	return instance
end


---@private
---@param self druid.instance
---@param widget_class druid.widget
---@return druid.widget
local function create_widget(self, widget_class)
	local instance = druid_component.create_widget(self, widget_class, self:get_context())
	register_interests(self, instance)

	return instance
end


---Before processing any input check if we need to update input stack
---@param self druid.instance
---@param components table[]
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


---Check whitelists and blacklists for input components
---@param component druid.component The component to check
---@return boolean is_can_use True if component can be processed on input step
function M:_can_use_input_component(component)
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


local function schedule_late_init(self)
	if self._late_init_timer_id then
		return
	end

	self._late_init_timer_id = timer.delay(0, false, function()
		self._late_init_timer_id = nil
		self:late_init()
	end)
end


---Druid class constructor which used to create Druid components
---@param context table Druid context. Usually it is self of gui script
---@param style table? Druid style table
---@return druid.instance instance The new Druid instance
function M.create_druid_instance(context, style)
	local self = setmetatable({}, DRUID_INSTANCE_METATABLE)

	self._context = context
	self._style = style or settings.default_style
	self._is_late_remove_enabled = false
	self._late_remove = {}

	self._input_blacklist = nil
	self._input_whitelist = nil

	self.components_all = {}
	self.components_interest = {}
	for i = 1, #const.ALL_INTERESTS do
		self.components_interest[const.ALL_INTERESTS[i]] = {}
	end

	events.subscribe("druid.window_event", self.on_window_event, self)
	events.subscribe("druid.language_change", self.on_language_change, self)

	return self
end


---Create new Druid component instance
---@generic T: druid.component
---@param component T The component class to create
---@vararg any Additional arguments to pass to the component's init function
---@return T instance The new ready to use component
function M:new(component, ...)
	local instance = create(self, component)

	if instance.init then
		instance:init(...)
	end

	if instance.on_late_init or (not self.input_inited and instance.on_input) then
		schedule_late_init(self)
	end

	return instance
end


---Call this in gui_script final function.
function M:final()
	local components = self.components_all

	for i = #components, 1, -1 do
		if components[i].on_remove then
			components[i]:on_remove()
		end
	end

	set_input_state(self, false)

	events.unsubscribe("druid.window_event", self.on_window_event, self)
	events.unsubscribe("druid.language_change", self.on_language_change, self)
end


---Remove created component from Druid instance.
---
---Component `on_remove` function will be invoked, if exist.
---@generic T: druid.component
---@param component T Component instance
---@return boolean is_removed True if component was removed
function M:remove(component)
	if self._is_late_remove_enabled then
		table.insert(self._late_remove, component)
		return false
	end

	-- Recursive remove all children of component
	local children = component._meta.children
	for i = #children, 1, -1 do
		self:remove(children[i])
		children[i] = nil
	end

	local parent = component:get_parent_component()
	if parent then
		parent:__remove_child(component)
	end

	local is_removed = false

	local all_components = self.components_all
	for i = #all_components, 1, -1 do
		if all_components[i] == component then
			if component.on_remove then
				component:on_remove()
			end
			table.remove(all_components, i)
			is_removed = true
		end
	end

	local interest_list = get_component_interests(component)
	for i = 1, #interest_list do
		local interest = interest_list[i]
		local components = self.components_interest[interest]
		for j = #components, 1, -1 do
			if components[j] == component then
				table.remove(components, j)
			end
		end
	end

	return is_removed
end


---Get a context of Druid instance (usually a self of gui script)
---@package
---@return any context The Druid context
function M:get_context()
	return self._context
end


---Get a style of Druid instance
---@package
---@return table style The Druid style table
function M:get_style()
	return self._style
end


---Druid late update function called after initialization and before the regular update step.
---This function is used to check the GUI state and perform actions after all components and nodes have been created.
---An example use case is performing an auto stencil check in the GUI hierarchy for input components.
---@private
function M:late_init()
	local late_init_components = self.components_interest[const.ON_LATE_INIT]
	while late_init_components[1] do
		late_init_components[1]:on_late_init()
		table.remove(late_init_components, 1)
	end

	if not self.input_inited and #self.components_interest[const.ON_INPUT] > 0 then
		-- Input init on late init step, to be sure it goes after user go acquire input
		set_input_state(self, true)
	end
end


---Call this in gui_script update function.
---@param dt number Delta time
function M:update(dt)
	self._is_late_remove_enabled = true

	local components = self.components_interest[const.ON_UPDATE]
	for i = 1, #components do
		components[i]:update(dt)
	end

	self._is_late_remove_enabled = false
	self:_clear_late_remove()
end


---Call this in gui_script on_input function.
---@param action_id hash Action_id from on_input
---@param action table Action from on_input
---@return boolean is_input_consumed The boolean value is input was consumed
function M:on_input(action_id, action)
	self._is_late_remove_enabled = true

	local components = self.components_interest[const.ON_INPUT]
	check_sort_input_stack(self, components)

	local is_input_consumed = false

	for i = #components, 1, -1 do
		local component = components[i]
		local input_enabled = component:get_input_enabled()

		if input_enabled and self:_can_use_input_component(component) then
			if not is_input_consumed then
				is_input_consumed = component:on_input(action_id, action) or false
			else
				if component.on_input_interrupt then
					component:on_input_interrupt(action_id, action)
				end
			end
		end
	end

	self._is_late_remove_enabled = false
	self:_clear_late_remove()

	return is_input_consumed
end


---Call this in gui_script on_message function.
---@param message_id hash Message_id from on_message
---@param message table Message from on_message
---@param sender url Sender from on_message
function M:on_message(message_id, message, sender)
	if message_id == const.MSG_LAYOUT_CHANGED then
		-- Resend special message to all components with the related interest
		local components = self.components_interest[const.ON_LAYOUT_CHANGE]
		for i = 1, #components do
			components[i]:on_layout_change()
		end
	else
		-- Resend message to all components with on_message interest
		local components = self.components_interest[const.ON_MESSAGE]
		for i = 1, #components do
			components[i]:on_message(message_id, message, sender)
		end
	end
end


---Called when the window event occurs
---@param window_event number The window event
function M:on_window_event(window_event)
	if window_event == window.WINDOW_EVENT_FOCUS_LOST then
		local components = self.components_interest[const.ON_FOCUS_LOST]
		for i = 1, #components do
			components[i]:on_focus_lost()
		end
	elseif window_event == window.WINDOW_EVENT_FOCUS_GAINED then
		local components = self.components_interest[const.ON_FOCUS_GAINED]
		for i = 1, #components do
			components[i]:on_focus_gained()
		end
	elseif window_event == window.WINDOW_EVENT_RESIZED then
		local components = self.components_interest[const.ON_WINDOW_RESIZED]
		for i = 1, #components do
			components[i]:on_window_resized()
		end
	end
end


---Calls the on_language_change function in all related components
---This one called by global druid.on_language_change, but can be called manually to update all translations
---@private
function M:on_language_change()
	local components = self.components_interest[const.ON_LANGUAGE_CHANGE]
	for i = 1, #components do
		components[i]:on_language_change()
	end
end


---Set whitelist components for input processing.
---If whitelist is not empty and component not contains in this list,
---component will be not processed on the input step
---@param whitelist_components table|druid.component[] The array of component to whitelist
---@return druid.instance self The Druid instance
function M:set_whitelist(whitelist_components)
	if whitelist_components and whitelist_components._component then
		whitelist_components = { whitelist_components }
	end

	for i = 1, #whitelist_components do
		helper.add_array(whitelist_components, whitelist_components[i]:get_childrens())
	end

	self._input_whitelist = whitelist_components

	return self
end


---Set blacklist components for input processing.
---If blacklist is not empty and component is contained in this list,
---component will be not processed on the input step DruidInstance
---@param blacklist_components table|druid.component[] The array of component to blacklist
---@return druid.instance self The Druid instance
function M:set_blacklist(blacklist_components)
	if blacklist_components and blacklist_components._component then
		blacklist_components = { blacklist_components }
	end

	for i = 1, #blacklist_components do
		helper.add_array(blacklist_components, blacklist_components[i]:get_childrens())
	end

	self._input_blacklist = blacklist_components

	return self
end


---Remove all components on late remove step DruidInstance
---@private
function M:_clear_late_remove()
	if #self._late_remove == 0 then
		return
	end

	for i = 1, #self._late_remove do
		self:remove(self._late_remove[i])
	end
	self._late_remove = {}
end


---Create new Druid widget instance
---@generic T: druid.component
---@param widget T The widget class to create
---@param template string|nil The template name used by widget
---@param nodes table<hash, node>|node|string|nil The nodes table from gui.clone_tree or prefab node to use for clone or node id to clone
---@vararg any Additional arguments to pass to the widget's init function
---@return T widget The new ready to use widget
function M:new_widget(widget, template, nodes, ...)
	local instance = create_widget(self, widget)

	instance.druid = instance:get_druid(template, nodes)

	if instance.init then
		instance:init(...)
	end
	if instance.on_late_init or (not self.input_inited and instance.on_input) then
		schedule_late_init(self)
	end

	return instance
end


local button = require("druid.base.button")
---Create Button component
---@param node string|node The node_id or gui.get_node(node_id)
---@param callback function|event|nil Button callback
---@param params any|nil Button callback params
---@param anim_node node|string|nil Button anim node (node, if not provided)
---@return druid.button button The new button component
function M:new_button(node, callback, params, anim_node)
	return self:new(button, node, callback, params, anim_node)
end


local blocker = require("druid.base.blocker")
---Create Blocker component
---@param node string|node The node_id or gui.get_node(node_id)
---@return druid.blocker blocker The new blocker component
function M:new_blocker(node)
	return self:new(blocker, node)
end


local back_handler = require("druid.base.back_handler")
---Create BackHandler component
---@param callback function|event|nil The callback(self, custom_args) to call on back event
---@param params any|nil Callback argument
---@return druid.back_handler back_handler The new back handler component
function M:new_back_handler(callback, params)
	return self:new(back_handler, callback, params)
end


local hover = require("druid.base.hover")
---Create Hover component
---@param node string|node The node_id or gui.get_node(node_id)
---@param on_hover_callback function|nil Hover callback
---@param on_mouse_hover_callback function|nil Mouse hover callback
---@return druid.hover hover The new hover component
function M:new_hover(node, on_hover_callback, on_mouse_hover_callback)
	return self:new(hover, node, on_hover_callback, on_mouse_hover_callback)
end


local text = require("druid.base.text")
---Create Text component
---@param node string|node|druid.text The node_id or gui.get_node(node_id)
---@param value string|nil Initial text. Default value is node text from GUI scene.
---@param adjust_type string|nil Adjust type for text. By default is DOWNSCALE. Look const.TEXT_ADJUST for reference
---@return druid.text text The new text component
function M:new_text(node, value, adjust_type)
	return self:new(text, node, value, adjust_type)
end


local static_grid = require("druid.base.static_grid")
---Create Grid component
---@param parent_node string|node The node_id or gui.get_node(node_id). Parent of all Grid items.
---@param item string|node Item prefab. Required to get grid's item size. Can be adjusted separately.
---@param in_row number|nil How many nodes can be placed in a row
---@return druid.grid grid The new grid component
function M:new_grid(parent_node, item, in_row)
	return self:new(static_grid, parent_node, item, in_row)
end


local scroll = require("druid.base.scroll")
---Create Scroll component
---@param view_node string|node The node_id or gui.get_node(node_id). Will be used as user input node.
---@param content_node string|node The node_id or gui.get_node(node_id). Will be used as scrollable node inside view_node.
---@return druid.scroll scroll The new scroll component
function M:new_scroll(view_node, content_node)
	return self:new(scroll, view_node, content_node)
end


local drag = require("druid.base.drag")
---Create Drag component
---@param node string|node The node_id or gui.get_node(node_id). Will be used as user input node.
---@param on_drag_callback function|nil Callback for on_drag_event(self, dx, dy)
---@return druid.drag drag The new drag component
function M:new_drag(node, on_drag_callback)
	return self:new(drag, node, on_drag_callback)
end


local swipe = require("druid.extended.swipe")
---Create Swipe component
---@param node string|node The node_id or gui.get_node(node_id). Will be used as user input node.
---@param on_swipe_callback function|nil Swipe callback for on_swipe_end event
---@return druid.swipe swipe The new swipe component
function M:new_swipe(node, on_swipe_callback)
	return self:new(swipe, node, on_swipe_callback)
end


local lang_text = require("druid.extended.lang_text")
---Create LangText component
---@param node string|node The node_id or gui.get_node(node_id)
---@param locale_id string|nil Default locale id or text from node as default
---@param adjust_type string|nil Adjust type for text node. Default: "downscale"
---@return druid.lang_text lang_text The new lang text component
function M:new_lang_text(node, locale_id, adjust_type)
	return self:new(lang_text, node, locale_id, adjust_type)
end


local slider = require("druid.extended.slider")
---Create Slider component
---@param pin_node string|node The node_id or gui.get_node(node_id).
---@param end_pos vector3 The end position of slider
---@param callback function|nil On slider change callback
---@return druid.slider slider The new slider component
function M:new_slider(pin_node, end_pos, callback)
	return self:new(slider, pin_node, end_pos, callback)
end


local input = require("druid.extended.input")
---Create Input component
---@param click_node string|node Button node to enable input component
---@param text_node string|node|druid.text Text node that will be changed on user input
---@param keyboard_type number|nil Gui keyboard type for input field
---@return druid.input input The new input component
function M:new_input(click_node, text_node, keyboard_type)
	return self:new(input, click_node, text_node, keyboard_type)
end


local data_list = require("druid.extended.data_list")
---Create DataList component
---@param druid_scroll druid.scroll The Scroll instance for Data List component
---@param druid_grid druid.grid The Grid instance for Data List component
---@param create_function function The create function callback(self, data, index, data_list). Function should return (node, [component])
---@return druid.data_list data_list The new data list component
function M:new_data_list(druid_scroll, druid_grid, create_function)
	return self:new(data_list, druid_scroll, druid_grid, create_function)
end


local timer_component = require("druid.extended.timer")
---Create Timer component
---@param node string|node Gui text node
---@param seconds_from number|nil Start timer value in seconds
---@param seconds_to number|nil End timer value in seconds
---@param callback function|nil Function on timer end
---@return druid.timer timer The new timer component
function M:new_timer(node, seconds_from, seconds_to, callback)
	return self:new(timer_component, node, seconds_from, seconds_to, callback)
end


local progress = require("druid.extended.progress")
---Create Progress component
---@param node string|node Progress bar fill node or node name
---@param key string Progress bar direction: "x" or "y"
---@param init_value number|nil Initial value of progress bar. Default: 1
---@return druid.progress progress The new progress component
function M:new_progress(node, key, init_value)
	return self:new(progress, node, key, init_value)
end


local layout = require("druid.extended.layout")
---Create Layout component
---@param node string|node The node_id or gui.get_node(node_id).
---@param mode string|nil vertical|horizontal|horizontal_wrap. Default: horizontal
---@return druid.layout layout The new layout component
function M:new_layout(node, mode)
	return self:new(layout, node, mode)
end


local container = require("druid.extended.container")
---Create Container component
---@param node string|node The node_id or gui.get_node(node_id).
---@param mode druid.container.mode|nil Layout mode. Default Fit or Stretch depends from node adjust mode from GUI scene
---@param callback fun(self: druid.container, size: vector3)|nil Callback on size changed
---@return druid.container container The new container component
function M:new_container(node, mode, callback)
	return self:new(container, node, mode, callback)
end


local hotkey = require("druid.extended.hotkey")
---Create Hotkey component
---@param keys_array string|string[] Keys for trigger action. Should contains one action key and any amount of modificator keys
---@param callback function|event|nil The callback function
---@param callback_argument any|nil The argument to pass into the callback function
---@return druid.hotkey hotkey The new hotkey component
function M:new_hotkey(keys_array, callback, callback_argument)
	return self:new(hotkey, keys_array, callback, callback_argument)
end


local rich_text = require("druid.custom.rich_text.rich_text")
---Create RichText component.
---@param text_node string|node The text node to make Rich Text
---@param value string|nil The initial text value. Default will be gui.get_text(text_node)
---@return druid.rich_text rich_text The new rich text component
function M:new_rich_text(text_node, value)
	return self:new(rich_text, text_node, value)
end


local rich_input = require("druid.custom.rich_input.rich_input")
---Create RichInput component.
---As a template please check rich_input.gui layout.
---@param template string The template string name
---@param nodes table|nil Nodes table from gui.clone_tree
---@return druid.rich_input rich_input The new rich input component
function M:new_rich_input(template, nodes)
	return self:new(rich_input, template, nodes)
end


return M
