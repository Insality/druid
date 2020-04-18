--- Basic class for all Druid components.
-- To create you component, use `component.create`
-- @module component

local const = require("druid.const")
local class = require("druid.system.middleclass")

-- @classmod Component
local Component = class("druid.component")


--- Get current component style table
-- @function component:get_style
-- @treturn table Component style table
function Component.get_style(self)
	if not self._meta.style then
		return const.EMPTY_TABLE
	end

	return self._meta.style[self._component.name] or const.EMPTY_TABLE
end


--- Set current component style table
-- @function component:set_style
-- @tparam table style Druid style module
function Component.set_style(self, druid_style)
	self._meta.style = druid_style
	self._style = self:get_style()
end


--- Get current component template name
-- @function component:get_template
-- @treturn string Component template name
function Component.get_template(self)
	return self._meta.template
end


--- Set current component template name
-- @function component:set_template
-- @tparam string template Component template name
function Component.set_template(self, template)
	self._meta.template = template
end


--- Get current component nodes
-- @function component:get_nodes
-- @treturn table Component nodes table
function Component.get_nodes(self)
	return self._meta.nodes
end


--- Set current component nodes
-- @function component:set_nodes
-- @tparam table nodes Component nodes table
function Component.set_nodes(self, nodes)
	self._meta.nodes = nodes
end


--- Get current component context
-- @function component:get_context
-- @treturn table Component context
function Component.get_context(self, context)
	return self._meta.context
end


--- Set current component context
-- @function component:set_context
-- @tparam table context Druid context. Usually it is self of script
function Component.set_context(self, context)
	self._meta.context = context
end


--- Get current component interests
-- @function component:get_interests
-- @treturn table List of component interests
function Component.get_interests(self)
	return self._component.interest
end


--- Increase input priority in current input stack
-- @function component:increase_input_priority
function Component.increase_input_priority(self)
	self._meta.increased_input_priority = true
end

--- Reset input priority in current input stack
-- @function component:reset_input_priority
function Component.reset_input_priority(self)
	self._meta.increased_input_priority = false
end


--- Get node for component by name.
-- If component has nodes, node_or_name should be string
-- It auto pick node by template name or from nodes by clone_tree
-- if they was setup via component:set_nodes, component:set_template
-- @function component:get_node
-- @tparam string|node node_or_name Node name or node itself
-- @treturn node Gui node
function Component.get_node(self, node_or_name)
	local template_name = self:get_template() or const.EMPTY_STRING
	local nodes = self:get_nodes()

	if template_name ~= const.EMPTY_STRING then
		template_name = template_name .. "/"
	end

	if nodes then
		assert(type(node_or_name) == "strings", "You should pass node name instead of node")
		return nodes[template_name .. node_or_name]
	else
		if type(node_or_name) == const.STRING then
			return gui.get_node(template_name .. node_or_name)
		else
			return node_or_name
		end
	end
end


--- Return druid with context of calling component.
-- Use it to create component inside of other components.
-- @function component:get_druid
-- @treturn Druid Druid instance with component context
function Component.get_druid(self)
	local context = { _context = self }
	return setmetatable(context, { __index = self:get_context().druid })
end


--- Setup component context and his style table
-- @function component:setup_component
-- @tparam context table Druid context. Usually it is self of script
-- @tparam style table Druid style module
-- @treturn Component Component itself
function Component.setup_component(self, context, style)
	self._meta = {
		template = nil,
		context = nil,
		nodes = nil,
		style = nil,
		increased_input_priority = false
	}

	self:set_context(context)
	self:set_style(style)

	return self
end


--- Basic constructor of component. It will call automaticaly
-- by `Component.static.create`
-- @function component:initialize
-- @tparam string name Component name
-- @tparam table interest List of component's interest
-- @local
function Component.initialize(self, name, interest)
	self._component = {
		name = name,
		interest = interest
	}
end


--- Create new component. It will inheritance from basic
-- druid component.
-- @function Component.create
-- @tparam string name Component name
-- @tparam table interest List of component's interest
function Component.static.create(name, interest)
	-- Yea, inheritance here
	local new_class = class(name, Component)

	new_class.initialize = function(self)
		Component.initialize(self, name, interest)
	end

	return new_class
end


return Component
