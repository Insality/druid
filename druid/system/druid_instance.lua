---@diagnostic disable: invisible
-- Hello, Defolder! Wish you a good day!

local events = require("event.events")
local const = require("druid.const")
local settings = require("druid.system.settings")
local druid_component = require("druid.component")

---The input filter, applied to the Druid instance components or to the component subtree.
---Membership is the listed component plus any descendant, including ones created later.
---@class druid.instance.input_filter
---@field whitelist table<druid.component, boolean>|nil Components that should receive input (with descendants)
---@field blacklist table<druid.component, boolean>|nil Components that should not receive input (with descendants)

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
---@field package _input_filter druid.instance.input_filter|nil Input filter for all the instance components
---@field package _root druid.instance The root Druid instance, the inner ones are the proxies over it
---@field package _input_filters_count number Amount of the filter lists, set on the instance and on its components
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


---@param self druid.instance
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


---Check the component against the single input filter.
---A listed component matches itself and any of its descendants, so the membership is
---the walk over the parents chain. Descendants created later are matched as well
---@param filter druid.instance.input_filter|nil The filter to check
---@param component druid.component The component to check
---@return boolean is_filtered True if the component is filtered out by this filter
local function is_filtered(filter, component)
	if not filter then
		return false
	end

	local whitelist = filter.whitelist
	local blacklist = filter.blacklist
	if not whitelist and not blacklist then
		return false
	end

	-- Both lists are checked in the single walk. The blacklist wins, so it returns at once,
	-- while the whitelist hit still has to look for the blacklist in the rest of the chain
	local is_allowed = not whitelist
	local current = component
	while current do
		if blacklist and blacklist[current] == true then
			return true
		end

		if whitelist and whitelist[current] == true then
			if not blacklist then
				return false
			end

			is_allowed = true
		end

		current = current._meta.parent
	end

	return not is_allowed
end


---Assign the filter list and keep the instance filters counter in sync.
---The counter is the fast path check on the input step, see `_can_use_input_component`
---@param root druid.instance The root Druid instance
---@param filter druid.instance.input_filter The filter to change
---@param key string The filter list key: "whitelist" or "blacklist"
---@param map table<druid.component, boolean>|nil The new filter list or nil to clear it
local function set_filter_list(root, filter, key, map)
	local previous = filter[key]
	if previous == nil and map ~= nil then
		root._input_filters_count = root._input_filters_count + 1
	elseif previous ~= nil and map == nil then
		root._input_filters_count = root._input_filters_count - 1
	end

	filter[key] = map
end


---Check the input filters for the component: the instance one and the ones from its parents
---@param component druid.component The component to check
---@return boolean is_can_use True if component can be processed on input step
function M:_can_use_input_component(component)
	-- Nothing is filtered at all in the most of the cases, so skip the parents walk
	if self._input_filters_count == 0 then
		return true
	end

	if is_filtered(self._input_filter, component) then
		return false
	end

	-- The filter, set from a component, is applied to its subtree, so check the parents.
	-- The walk starts from the parent, so the filter owner is not affected by its own filter
	local parent = component._meta.parent
	while parent do
		if is_filtered(parent._meta.input_filter, component) then
			return false
		end

		parent = parent._meta.parent
	end

	return true
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

	self._root = self
	self._context = context
	self._style = style or settings.default_style
	self._is_late_remove_enabled = false
	self._late_remove = {}

	self._input_filter = nil
	self._input_filters_count = 0

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
	local instance = component()
	instance:setup_component(self, self:get_context(), self:get_style(), component)
	register_interests(self, instance)

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

	if is_removed then
		-- The component is gone, so its filters should not be counted anymore
		local component_filter = component._meta.input_filter
		if component_filter then
			local root = self._root
			set_filter_list(root, component_filter, "whitelist", nil)
			set_filter_list(root, component_filter, "blacklist", nil)
			component._meta.input_filter = nil
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


---Set a style of Druid instance. Pass nil to reset to the default style.
---The style is applied to the components created after this call, already created components keep their style.
---@param style table|nil The Druid style table
---@return druid.instance self The Druid instance itself for chaining
function M:set_style(style)
	self._style = style or settings.default_style

	return self
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
		-- Input init on late init step, to be sure it goes after user Game Objects acquire input
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
		local input_enabled = component._meta.input_enabled

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


---Make a hash set from the components list to check the input filter membership.
---Children are not copied in: membership walks the parent chain at input time,
---so components created later under a listed parent still match.
---@param components table|druid.component[]|nil The array of components, single component or nil
---@return table<druid.component, boolean>|nil map The components hash set or nil if the list is empty
local function make_filter_map(components)
	if components and components._component then
		components = { components }
	end

	if not components or #components == 0 then
		return nil
	end

	local map = {}
	for index = 1, #components do
		map[components[index]] = true
	end

	return map
end


---Get the input filter to fill, it will be created if it's not exist yet
---@param self druid.instance The Druid instance or the table from the `component:get_druid()`
---@return druid.instance.input_filter filter The instance filter or the component one
local function get_input_filter(self)
	if getmetatable(self) == DRUID_INSTANCE_METATABLE then
		self._input_filter = self._input_filter or {}
		return self._input_filter
	end

	local component_meta = self._context._meta
	component_meta.input_filter = component_meta.input_filter or {}
	return component_meta.input_filter
end


---Set whitelist components for input processing.
---If whitelist is not empty, only the listed components and their descendants
---receive input. Descendants created later still match, no need to call this again.
---
---The filter is scoped to the caller: on the `druid` instance it affects all components,
---on the `self.druid` inside a component it affects this component subtree only.
---The filter owner is not affected by its own filter, so a widget can restrict its children
---and keep its own `on_input` working.
---@param whitelist_components table|druid.component[]|nil The array of component to whitelist, nil to clear it
---@return druid.instance self The Druid instance
function M:set_whitelist(whitelist_components)
	local filter = get_input_filter(self)
	set_filter_list(self._root, filter, "whitelist", make_filter_map(whitelist_components))

	return self
end


---Set blacklist components for input processing.
---If blacklist is not empty, the listed components and their descendants
---are skipped on the input step. Descendants created later still match.
---
---The filter is scoped to the caller: on the `druid` instance it affects all components,
---on the `self.druid` inside a component it affects this component subtree only.
---The filter owner is not affected by its own filter: blacklist `{ self }` from the widget
---blocks every child, to block the widget itself set the filter from the outside.
---@param blacklist_components table|druid.component[]|nil The array of component to blacklist, nil to clear it
---@return druid.instance self The Druid instance
function M:set_blacklist(blacklist_components)
	local filter = get_input_filter(self)
	set_filter_list(self._root, filter, "blacklist", make_filter_map(blacklist_components))

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
	local instance = druid_component.create_widget(self, widget, self:get_context())
	register_interests(self, instance)

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
