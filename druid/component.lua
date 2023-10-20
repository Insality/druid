-- Copyright (c) 2021 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Basic class for all Druid components.
-- To create you custom component, use static function `component.create`
-- @usage
-- -- Create your component:
-- local component = require("druid.component")
--
-- local AwesomeComponent = component.create("awesome_component")
--
-- function AwesomeComponent:init(template, nodes)
--     self:set_template(template)
--     self:set_nodes(nodes)
--     self.druid = self:get_druid()
-- end
--
-- return AwesomeComponent
-- @module BaseComponent
-- @alias druid.base_component

local const = require("druid.const")
local class = require("druid.system.middleclass")
local helper = require("druid.helper")

local BaseComponent = class("druid.component")

local INTERESTS = {} -- Cache interests per component class in runtime
local IS_AUTO_TEMPLATE = not (sys.get_config("druid.no_auto_template") == "1")

-- Component Interests
BaseComponent.ON_INPUT = const.ON_INPUT
BaseComponent.ON_UPDATE = const.ON_UPDATE
BaseComponent.ON_MESSAGE = const.ON_MESSAGE
BaseComponent.ON_LATE_INIT = const.ON_LATE_INIT
BaseComponent.ON_FOCUS_LOST = const.ON_FOCUS_LOST
BaseComponent.ON_FOCUS_GAINED = const.ON_FOCUS_GAINED
BaseComponent.ON_LAYOUT_CHANGE = const.ON_LAYOUT_CHANGE
BaseComponent.ON_MESSAGE_INPUT = const.ON_MESSAGE_INPUT
BaseComponent.ON_WINDOW_RESIZED = const.ON_WINDOW_RESIZED
BaseComponent.ON_LANGUAGE_CHANGE = const.ON_LANGUAGE_CHANGE

BaseComponent.ALL_INTERESTS = {
	BaseComponent.ON_INPUT,
	BaseComponent.ON_UPDATE,
	BaseComponent.ON_MESSAGE,
	BaseComponent.ON_LATE_INIT,
	BaseComponent.ON_FOCUS_LOST,
	BaseComponent.ON_FOCUS_GAINED,
	BaseComponent.ON_LAYOUT_CHANGE,
	BaseComponent.ON_MESSAGE_INPUT,
	BaseComponent.ON_WINDOW_RESIZED,
	BaseComponent.ON_LANGUAGE_CHANGE,
}

-- Mapping from on_message method to specific method name
BaseComponent.SPECIFIC_UI_MESSAGES = {
	[hash("layout_changed")] = BaseComponent.ON_LAYOUT_CHANGE, -- The message_id from Defold
	[hash(BaseComponent.ON_FOCUS_LOST)] = BaseComponent.ON_FOCUS_LOST,
	[hash(BaseComponent.ON_FOCUS_GAINED)] = BaseComponent.ON_FOCUS_GAINED,
	[hash(BaseComponent.ON_WINDOW_RESIZED)] = BaseComponent.ON_WINDOW_RESIZED,
	[hash(BaseComponent.ON_MESSAGE_INPUT)] = BaseComponent.ON_MESSAGE_INPUT,
	[hash(BaseComponent.ON_LANGUAGE_CHANGE)] = BaseComponent.ON_LANGUAGE_CHANGE,
}


local uid = 0
function BaseComponent.create_uid()
	uid = uid + 1
	return uid
end


--- Set current component style table.
--
-- Invoke `on_style_change` on component, if exist. Component should handle
-- their style changing and store all style params
-- @tparam BaseComponent self @{BaseComponent}
-- @tparam table|nil druid_style Druid style module
-- @treturn BaseComponent @{BaseComponent}
function BaseComponent.set_style(self, druid_style)
	self._meta.style = druid_style or {}
	local component_style = self._meta.style[self._component.name] or {}

	if self.on_style_change then
		self:on_style_change(component_style)
	end

	return self
end


--- Set component template name.
--
-- Use on all your custom components with GUI layouts used as templates.
-- It will check parent template name to build full template name in self:get_node()
-- @tparam BaseComponent self @{BaseComponent}
-- @tparam string template BaseComponent template name
-- @treturn BaseComponent @{BaseComponent}
function BaseComponent.set_template(self, template)
	template = template or ""

	local parent = self:get_parent_component()
	if parent and IS_AUTO_TEMPLATE then
		local parent_template = parent:get_template()
		if #parent_template > 0 then
			if #template > 0 then
				template = "/" .. template
			end
			template = parent_template .. template
		end
	end

	self._meta.template = template
	return self
end


--- Get current component template name.
-- @tparam BaseComponent self @{BaseComponent}
-- @treturn string Component full template name
function BaseComponent.get_template(self)
	return self._meta.template
end


--- Set current component nodes.
-- Use if your component nodes was cloned with `gui.clone_tree` and you got the node tree.
-- @tparam BaseComponent self @{BaseComponent}
-- @tparam table nodes BaseComponent nodes table
-- @treturn BaseComponent @{BaseComponent}
-- @usage
-- local nodes = gui.clone_tree(self.prefab)
-- ... In your component:
-- self:set_nodes(nodes)
function BaseComponent.set_nodes(self, nodes)
	self._meta.nodes = nodes

	-- When we use gui.clone_tree in inner template (template inside other template)
	-- this nodes have no id. We have table: hash(correct_id) : hash("")
	-- It's wrong and we use this hack to fix this
	if nodes then
		for id, node in pairs(nodes) do
			gui.set_id(node, id)
		end
	end

	return self
end


--- Context used as first arg in all Druid events
--
-- Context is usually self of gui_script.
-- @tparam BaseComponent self @{BaseComponent}
-- @treturn table BaseComponent context
function BaseComponent.get_context(self)
	return self._meta.context
end


--- Increase input priority in input stack
-- @tparam BaseComponent self @{BaseComponent}
-- @local
function BaseComponent.increase_input_priority(self)
	helper.deprecated("The component:increase_input_priority is deprecated. Please use component:set_input_priority(druid_const.PRIORITY_INPUT_MAX) instead")
end


--- Get component node by name.
--
-- If component has nodes, node_or_name should be string
-- It autopick node by template name or from nodes by gui.clone_tree
-- if they was setup via component:set_nodes, component:set_template.
-- If node is not found, the exception will fired
-- @tparam BaseComponent self @{BaseComponent}
-- @tparam string|node node_or_name Node name or node itself
-- @treturn node Gui node
function BaseComponent.get_node(self, node_or_name)
	if type(node_or_name) ~= "string" then
		-- Assume it's already node from gui.get_node
		return node_or_name
	end

	local template_name = self:get_template()
	local nodes = self:__get_nodes()

	if #template_name > 0 then
		template_name = template_name .. "/"
	end

	local node
	if nodes then
		node = nodes[template_name .. node_or_name]
	else
		node = gui.get_node(template_name .. node_or_name)
	end

	if not node then
		assert(node, "No component with name: " .. (template_name or "") .. (node_or_name or ""))
	end

	return node
end


--- Get Druid instance for inner component creation.
-- @tparam BaseComponent self @{BaseComponent}
-- @treturn DruidInstance Druid instance with component context
function BaseComponent.get_druid(self)
	local context = { _context = self }
	return setmetatable(context, { __index = self._meta.druid })
end


--- Return component name
-- @tparam BaseComponent self @{BaseComponent}
-- @treturn string The component name
function BaseComponent.get_name(self)
	return self._component.name .. BaseComponent.create_uid()
end


--- Return parent component name
-- @tparam BaseComponent self @{BaseComponent}
-- @treturn string|nil The parent component name if exist or bil
function BaseComponent.get_parent_name(self)
	local parent = self:get_parent_component()
	return parent and parent:get_name()
end


--- Return component input priority
-- @tparam BaseComponent self @{BaseComponent}
-- @treturn number The component input priority
function BaseComponent.get_input_priority(self)
	return self._component.input_priority
end


--- Set component input priority
--
-- Default value: 10
-- @tparam BaseComponent self @{BaseComponent}
-- @tparam number value The new input priority value
-- @tparam boolean|nil is_temporary If true, the reset input priority will return to previous value
-- @treturn number The component input priority
function BaseComponent.set_input_priority(self, value, is_temporary)
	assert(value)

	if self._component.input_priority == value then
		return self
	end

	self._component.input_priority = value
	self._component._is_input_priority_changed = true

	if not is_temporary then
		self._component.default_input_priority = value
	end

	local children = self:get_childrens()
	for i = 1, #children do
		children[i]:set_input_priority(value, is_temporary)
	end

	return self
end


--- Reset component input priority to default value
-- @tparam BaseComponent self @{BaseComponent}
-- @treturn number The component input priority
function BaseComponent.reset_input_priority(self)
	self:set_input_priority(self._component.default_input_priority)
	return self
end


--- Return component UID.
--
-- UID generated in component creation order.
-- @tparam BaseComponent self @{BaseComponent}
-- @treturn number The component uid
function BaseComponent.get_uid(self)
	return self._component._uid
end


--- Set component input state. By default it enabled
--
-- If input is disabled, the component will not receive input events
-- @tparam BaseComponent self @{BaseComponent}
-- @tparam boolean|nil state The component input state
-- @treturn BaseComponent BaseComponent itself
function BaseComponent.set_input_enabled(self, state)
	self._meta.input_enabled = state

	for index = 1, #self._meta.children do
		self._meta.children[index]:set_input_enabled(state)
	end

	return self
end


--- Return the parent component if exist
-- @tparam BaseComponent self @{BaseComponent}
-- @treturn BaseComponent|nil The druid component instance or nil
function BaseComponent.get_parent_component(self)
	return self._meta.parent
end


--- Setup component context and his style table
-- @tparam BaseComponent self @{BaseComponent}
-- @tparam table druid_instance The parent druid instance
-- @tparam table context Druid context. Usually it is self of script
-- @tparam table style Druid style module
-- @tparam table instance_class The component instance class
-- @treturn component BaseComponent itself
-- @local
function BaseComponent.setup_component(self, druid_instance, context, style, instance_class)
	self._meta = {
		template = "",
		context = context,
		nodes = nil,
		style = nil,
		druid = druid_instance,
		input_enabled = true,
		children = {},
		parent = type(context) ~= "userdata" and context,
		instance_class = instance_class
	}

	self:set_style(style)
	self:set_template("")

	if self._meta.parent then
		self._meta.parent:__add_children(self)
	end

	return self
end


--- Basic constructor of component. It will call automaticaly
-- by `BaseComponent.create`
-- @tparam BaseComponent self @{BaseComponent}
-- @tparam string name BaseComponent name
-- @tparam number|nil input_priority The input priority. The bigger number processed first
-- @local
function BaseComponent.initialize(self, name, input_priority)
	self._component = {
		name = name,
		input_priority = input_priority or const.PRIORITY_INPUT,
		default_input_priority = input_priority or const.PRIORITY_INPUT,
		is_debug = false,
		_is_input_priority_changed = true, -- Default true for sort once time after GUI init
		_uid = BaseComponent.create_uid()
	}
end


--- Print log information if debug mode is enabled
-- @tparam BaseComponent self @{BaseComponent}
-- @tparam string message
-- @tparam table context
-- @local
function BaseComponent.log_message(self, message, context)
	if not self._component.is_debug then
		return
	end
	print("[" .. self:get_name() .. "]:", message, helper.table_to_string(context))
end


--- Set debug logs for component enabled or disabled
-- @tparam BaseComponent self @{BaseComponent}
-- @tparam boolean|nil is_debug
-- @local
function BaseComponent.set_debug(self, is_debug)
	self._component.is_debug = is_debug
end


--- Return true, if input priority was changed
-- @tparam BaseComponent self @{BaseComponent}
-- @local
function BaseComponent._is_input_priority_changed(self)
	return self._component._is_input_priority_changed
end


--- Reset is_input_priority_changed field
-- @tparam BaseComponent self @{BaseComponent}
-- @local
function BaseComponent._reset_input_priority_changed(self)
	self._component._is_input_priority_changed = false
end


function BaseComponent.__tostring(self)
	return self._component.name
end


--- Get current component interests
-- @tparam BaseComponent self @{BaseComponent}
-- @treturn table List of component interests
-- @local
function BaseComponent.__get_interests(self)
	local instance_class = self._meta.instance_class
	if INTERESTS[instance_class] then
		return INTERESTS[instance_class]
	end

	local interests = {}
	for index = 1, #BaseComponent.ALL_INTERESTS do
		local interest = BaseComponent.ALL_INTERESTS[index]
		if self[interest] and type(self[interest]) == "function" then
			table.insert(interests, interest)
		end
	end

	INTERESTS[instance_class] = interests
	return INTERESTS[instance_class]
end


--- Get current component nodes
-- @tparam BaseComponent self @{BaseComponent}
-- @treturn table BaseComponent nodes table
-- @local
function BaseComponent.__get_nodes(self)
	local nodes = self._meta.nodes
	local parent = self:get_parent_component()
	if parent then
		nodes = nodes or parent:__get_nodes()
	end
	return nodes
end


--- Add child to component children list
-- @tparam BaseComponent self @{BaseComponent}
-- @tparam component children The druid component instance
-- @local
function BaseComponent.__add_children(self, children)
	table.insert(self._meta.children, children)
end


--- Remove child from component children list
-- @tparam BaseComponent self @{BaseComponent}
-- @tparam component children The druid component instance
-- @local
function BaseComponent.__remove_children(self, children)
	for i = #self._meta.children, 1, -1 do
		if self._meta.children[i] == children then
			table.remove(self._meta.children, i)
		end
	end
end


--- Return all children components, recursive
-- @tparam BaseComponent self @{BaseComponent}
-- @treturn table Array of childrens if the Druid component instance
function BaseComponent.get_childrens(self)
	local childrens = {}

	for i = 1, #self._meta.children do
		local children = self._meta.children[i]

		table.insert(childrens, children)
		helper.add_array(childrens, children:get_childrens())
	end

	return childrens
end


--- Create new component. It will inheritance from basic Druid component.
-- @function BaseComponent.create
-- @tparam string name BaseComponent name
-- @tparam number|nil input_priority The input priority. The bigger number processed first
-- @local
function BaseComponent.create(name, input_priority)
	-- Yea, inheritance here
	local new_class = class(name, BaseComponent)

	new_class.initialize = function(self)
		BaseComponent.initialize(self, name, input_priority)
	end

	return new_class
end


return BaseComponent
