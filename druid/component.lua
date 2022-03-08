-- Copyright (c) 2021 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Basic class for all Druid components.
-- To create you component, use `component.create`
-- @module BaseComponent
-- @alias druid.base_component

local const = require("druid.const")
local class = require("druid.system.middleclass")
local helper = require("druid.helper")


local BaseComponent = class("druid.component")


--- Component Interests
BaseComponent.ON_INPUT = const.ON_INPUT
BaseComponent.ON_UPDATE = const.ON_UPDATE
BaseComponent.ON_MESSAGE = const.ON_MESSAGE
BaseComponent.ON_LATE_INIT = const.ON_LATE_INIT
BaseComponent.ON_FOCUS_LOST = const.ON_FOCUS_LOST
BaseComponent.ON_FOCUS_GAINED = const.ON_FOCUS_GAINED
BaseComponent.ON_LAYOUT_CHANGE = const.ON_LAYOUT_CHANGE
BaseComponent.ON_MESSAGE_INPUT = const.ON_MESSAGE_INPUT
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
	BaseComponent.ON_LANGUAGE_CHANGE,
}


-- Mapping from on_message method to specific method name
BaseComponent.SPECIFIC_UI_MESSAGES = {
	[hash("layout_changed")] = BaseComponent.ON_LAYOUT_CHANGE, -- The message_id from Defold
	[hash(BaseComponent.ON_FOCUS_LOST)] = BaseComponent.ON_FOCUS_LOST,
	[hash(BaseComponent.ON_FOCUS_GAINED)] = BaseComponent.ON_FOCUS_GAINED,
	[hash(BaseComponent.ON_MESSAGE_INPUT)] = BaseComponent.ON_MESSAGE_INPUT,
	[hash(BaseComponent.ON_LANGUAGE_CHANGE)] = BaseComponent.ON_LANGUAGE_CHANGE,
}


local uid = 0
function BaseComponent.static.get_uid()
	uid = uid + 1
	return uid
end


--- Set current component style table (protected).
-- Invoke `on_style_change` on component, if exist. BaseComponent should handle
-- their style changing and store all style params
-- @tparam BaseComponent self
-- @tparam table druid_style Druid style module
function BaseComponent.set_style(self, druid_style)
	self._meta.style = druid_style or const.EMPTY_TABLE
	local component_style = self._meta.style[self._component.name] or const.EMPTY_TABLE

	if self.on_style_change then
		self:on_style_change(component_style)
	end
end


--- Set current component template name (protected)
-- @tparam BaseComponent self
-- @tparam string template BaseComponent template name
function BaseComponent.set_template(self, template)
	self._meta.template = template
end


--- Set current component nodes (protected)
-- @tparam BaseComponent self
-- @tparam table nodes BaseComponent nodes table
function BaseComponent.set_nodes(self, nodes)
	self._meta.nodes = nodes
end


--- Get current component context (protected)
-- @tparam BaseComponent self
-- @treturn table BaseComponent context
function BaseComponent.get_context(self)
	return self._meta.context
end


--- Increase input priority in current input stack
-- @tparam BaseComponent self
-- @local
function BaseComponent.increase_input_priority(self)
	helper.deprecated("The component:increase_input_priority is deprecated. Please use component:set_input_priority(druid_const.PRIORITY_INPUT_MAX) instead")
end



--- Get node for component by name.
-- If component has nodes, node_or_name should be string
-- It auto pick node by template name or from nodes by clone_tree
-- if they was setup via component:set_nodes, component:set_template
-- @tparam BaseComponent self
-- @tparam string|node node_or_name Node name or node itself
-- @treturn node Gui node
function BaseComponent.get_node(self, node_or_name)
	local template_name = self:__get_template() or const.EMPTY_STRING
	local nodes = self:__get_nodes()

	if template_name ~= const.EMPTY_STRING then
		template_name = template_name .. "/"
	end

	local node_type = type(node_or_name)
	if nodes then
		assert(node_type == const.STRING, "You should pass node name instead of node")
		return nodes[template_name .. node_or_name]
	else
		if node_type == const.STRING then
			return gui.get_node(template_name .. node_or_name)
		else
			-- Assume it's already node from gui.get_node
			return node_or_name
		end
	end
end


--- Return druid with context of calling component (protected).
-- Use it to create component inside of other components.
-- @tparam BaseComponent self
-- @treturn Druid Druid instance with component context
function BaseComponent.get_druid(self)
	local context = { _context = self }
	return setmetatable(context, { __index = self._meta.druid })
end


--- Return component name
-- @tparam BaseComponent self
-- @treturn string The component name
function BaseComponent.get_name(self)
	return self._component.name
end


--- Return component input priority
-- @tparam BaseComponent self
-- @treturn number The component input priority
function BaseComponent.get_input_priority(self)
	return self._component.input_priority
end


--- Set component input priority
-- @tparam BaseComponent self
-- @tparam number value The new input priority value
-- @treturn number The component input priority
function BaseComponent.set_input_priority(self, value)
	assert(value)

	if self._component.input_priority ~= value then
		self._component.input_priority = value
		self._component._is_input_priority_changed = true

		local children = self:get_childrens()
		for i = 1, #children do
			children[i]:set_input_priority(value)
		end
	end

	return self
end


--- Reset component input priority to default value
-- @tparam BaseComponent self
-- @treturn number The component input priority
function BaseComponent.reset_input_priority(self)
	self:set_input_priority(self._component.default_input_priority)
	return self
end


--- Return component uid (protected).
--- UID generated in component creation order
-- @tparam BaseComponent self
-- @treturn number The component uid
function BaseComponent.get_uid(self)
	return self._component._uid
end


--- Set component input state. By default it enabled
-- You can disable any input of component by this function
-- @tparam BaseComponent self
-- @tparam bool state The component input state
-- @treturn BaseComponent BaseComponent itself
function BaseComponent.set_input_enabled(self, state)
	self._meta.input_enabled = state

	for index = 1, #self._meta.children do
		self._meta.children[index]:set_input_enabled(state)
	end

	return self
end


--- Return the parent for current component (protected)
-- @tparam BaseComponent self
-- @treturn BaseComponent|nil The druid component instance or nil
function BaseComponent.get_parent_component(self)
	local context = self:get_context()

	if context.isInstanceOf and context:isInstanceOf(BaseComponent) then
		return context
	end

	return nil
end


--- Setup component context and his style table
-- @tparam BaseComponent self
-- @tparam table druid_instance The parent druid instance
-- @tparam table context Druid context. Usually it is self of script
-- @tparam table style Druid style module
-- @treturn component BaseComponent itself
-- @local
function BaseComponent.setup_component(self, druid_instance, context, style)
	self._meta = {
		template = nil,
		context = nil,
		nodes = nil,
		style = nil,
		druid = druid_instance,
		input_enabled = true,
		children = {}
	}

	self:__set_context(context)
	self:set_style(style)

	local parent = self:get_parent_component()
	if parent then
		parent:__add_children(self)
	end

	return self
end


--- Basic constructor of component. It will call automaticaly
-- by `BaseComponent.static.create`
-- @tparam BaseComponent self
-- @tparam string name BaseComponent name
-- @tparam[opt=DEFAULT] number input_priority The input priority. The bigger number processed first
-- @local
function BaseComponent.initialize(self, name, input_priority)
	self._component = {
		name = name,
		input_priority = input_priority or const.PRIORITY_INPUT,
		default_input_priority = input_priority or const.PRIORITY_INPUT,
		_is_input_priority_changed = true, -- Default true for sort once time after GUI init
		_uid = BaseComponent.get_uid()
	}
end


--- Return true, if input priority was changed
-- @tparam BaseComponent self
-- @local
function BaseComponent._is_input_priority_changed(self)
	return self._component._is_input_priority_changed
end


--- Reset is_input_priority_changed field
-- @tparam BaseComponent self
-- @local
function BaseComponent._reset_input_priority_changed(self)
	self._component._is_input_priority_changed = false
end


function BaseComponent.__tostring(self)
	return self._component.name
end


--- Set current component context
-- @tparam BaseComponent self
-- @tparam table context Druid context. Usually it is self of script
-- @local
function BaseComponent.__set_context(self, context)
	self._meta.context = context
end


--- Get current component interests
-- @tparam BaseComponent self
-- @treturn table List of component interests
-- @local
function BaseComponent.__get_interests(self)
	local interests = {}
	for index = 1, #BaseComponent.ALL_INTERESTS do
		local interest = BaseComponent.ALL_INTERESTS[index]
		if self[interest] and type(self[interest]) == "function" then
			table.insert(interests, interest)
		end
	end

	return interests
end


--- Get current component template name
-- @tparam BaseComponent self
-- @treturn string BaseComponent template name
-- @local
function BaseComponent.__get_template(self)
	return self._meta.template
end


--- Get current component nodes
-- @tparam BaseComponent self
-- @treturn table BaseComponent nodes table
-- @local
function BaseComponent.__get_nodes(self)
	return self._meta.nodes
end


--- Add child to component children list
-- @tparam BaseComponent self
-- @tparam component children The druid component instance
-- @local
function BaseComponent.__add_children(self, children)
	table.insert(self._meta.children, children)
end


--- Remove child from component children list
-- @tparam BaseComponent self
-- @tparam component children The druid component instance
-- @local
function BaseComponent.__remove_children(self, children)
	for i = #self._meta.children, 1, -1 do
		if self._meta.children[i] == children then
			table.remove(self._meta.children, i)
		end
	end
end


--- Return all children components, recursive (protected)
-- @tparam BaseComponent self
-- @treturn table Array of childrens if the Druid component instance
function BaseComponent.get_childrens(self)
	local childrens = {}

	for i = 1, #self._meta.children do
		local children = self._meta.children[i]

		table.insert(childrens, children)
		local recursive_childrens = children:get_childrens()
		for j = 1, #recursive_childrens do
			table.insert(childrens, recursive_childrens[j])
		end
	end

	return childrens
end


--- Create new component. It will inheritance from basic
-- druid component.
-- @tparam string name BaseComponent name
-- @tparam[opt=DEFAULT] number input_priority The input priority. The bigger number processed first
-- @local
function BaseComponent.static.create(name, input_priority)
	-- Yea, inheritance here
	local new_class = class(name, BaseComponent)

	new_class.initialize = function(self)
		BaseComponent.initialize(self, name, input_priority)
	end

	return new_class
end


return BaseComponent
