--- Basic class for all Druid components.
-- To create you component, use `component.create`
-- @module component

local const = require("druid.const")
local class = require("druid.system.middleclass")

-- @classmod Component
local Component = class("druid.component")


--- Set current component style table.
-- Invoke `on_style_change` on component, if exist. Component should handle
-- their style changing and store all style params
-- @function component:set_style
-- @tparam table style Druid style module
function Component:set_style(druid_style)
	self._meta.style = druid_style or const.EMPTY_TABLE
	local component_style = self._meta.style[self._component.name] or const.EMPTY_TABLE

	if self.on_style_change then
		self:on_style_change(component_style)
	end
end


--- Set current component template name
-- @function component:set_template
-- @tparam string template Component template name
function Component:set_template(template)
	self._meta.template = template
end


--- Set current component nodes
-- @function component:set_nodes
-- @tparam table nodes Component nodes table
function Component:set_nodes(nodes)
	self._meta.nodes = nodes
end


--- Get current component context
-- @function component:get_context
-- @treturn table Component context
function Component:get_context(context)
	return self._meta.context
end


--- Increase input priority in current input stack
-- @function component:increase_input_priority
function Component:increase_input_priority()
	self._meta.increased_input_priority = true
end


--- Reset input priority in current input stack
-- @function component:reset_input_priority
function Component:reset_input_priority()
	self._meta.increased_input_priority = false
end


--- Get node for component by name.
-- If component has nodes, node_or_name should be string
-- It auto pick node by template name or from nodes by clone_tree
-- if they was setup via component:set_nodes, component:set_template
-- @function component:get_node
-- @tparam string|node node_or_name Node name or node itself
-- @treturn node Gui node
function Component:get_node(node_or_name)
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


--- Return druid with context of calling component.
-- Use it to create component inside of other components.
-- @function component:get_druid
-- @treturn Druid Druid instance with component context
function Component:get_druid()
	local context = { _context = self }
	return setmetatable(context, { __index = self._meta.druid })
end


--- Return component name
-- @function component:get_name
-- @treturn string The component name
function Component:get_name()
	return self._component.name
end


--- Set component input state. By default it enabled
-- You can disable any input of component by this function
-- @function component:set_input_enabled
-- @tparam bool state The component input state
--	@treturn Component Component itself
function Component:set_input_enabled(state)
	self._meta.input_enabled = state

	for index = 1, #self._meta.children do
		self._meta.children[index]:set_input_enabled(state)
	end

	return self
end


--- Return the parent for current component
-- @function component:get_parent_component
-- @treturn Component|nil The druid component instance or nil
function Component:get_parent_component()
	local context = self:get_context()

	if context.isInstanceOf and context:isInstanceOf(Component) then
		return context
	end

	return nil
end


--- Setup component context and his style table
-- @function component:setup_component
-- @tparam druid_instance table The parent druid instance
-- @tparam context table Druid context. Usually it is self of script
-- @tparam style table Druid style module
-- @treturn component Component itself
function Component:setup_component(druid_instance, context, style)
	self._meta = {
		template = nil,
		context = nil,
		nodes = nil,
		style = nil,
		druid = druid_instance,
		increased_input_priority = false,
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
-- by `Component.static.create`
-- @function component:initialize
-- @tparam string name Component name
-- @tparam[opt={}] table interest List of component's interest
-- @local
function Component:initialize(name, interest)
	interest = interest or {}

	self._component = {
		name = name,
		interest = interest
	}
end


function Component:__tostring()
	return self._component.name
end


--- Set current component context
-- @function component:__set_context
-- @tparam table context Druid context. Usually it is self of script
function Component:__set_context(context)
	self._meta.context = context
end


--- Get current component interests
-- @function component:__get_interests
-- @treturn table List of component interests
function Component:__get_interests()
	return self._component.interest
end


--- Get current component template name
-- @function component:__get_template
-- @treturn string Component template name
function Component:__get_template()
	return self._meta.template
end


--- Get current component nodes
-- @function component:__get_nodes
-- @treturn table Component nodes table
function Component:__get_nodes()
	return self._meta.nodes
end


--- Add child to component children list
-- @function component:__add_children
-- @tparam component children The druid component instance
function Component:__add_children(children)
	table.insert(self._meta.children, children)
end


--- Remove child from component children list
-- @function component:__remove_children
-- @tparam component children The druid component instance
function Component:__remove_children(children)
	for i = #self._meta.children, 1, -1 do
		if self._meta.children[i] == children then
			table.remove(self._meta.children, i)
		end
	end
end


--- Create new component. It will inheritance from basic
-- druid component.
-- @function Component.create
-- @tparam string name Component name
-- @tparam[opt={}] table interest List of component's interest
function Component.static.create(name, interest)
	-- Yea, inheritance here
	local new_class = class(name, Component)

	new_class.initialize = function(self)
		Component.initialize(self, name, interest)
	end

	return new_class
end


return Component
