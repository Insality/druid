--- General component class
--@class component

local const = require("druid.const")
local class = require("druid.system.middleclass")

local Component = class("druid.component")


function Component.setup_component(self, context, style)
	self._meta = {
		template = nil,
		context = nil,
		nodes = nil,
		style = nil,
	}

	self:set_context(context)
	self:set_style(style)

	return self
end


function Component.get_style(self)
	if not self._meta.style then
		return const.EMPTY_TABLE
	end

	return self._meta.style[self._component.name] or const.EMPTY_TABLE
end


function Component.set_style(self, druid_style)
	self._meta.style = druid_style
end


function Component.get_template(self)
	return self._meta.template
end


function Component.set_template(self, template)
	self._meta.template = template
end


function Component.get_nodes(self)
	return self._meta.nodes
end


function Component.set_nodes(self, nodes)
	self._meta.nodes = nodes
end


function Component.get_context(self, context)
	return self._meta.context
end


function Component.set_context(self, context)
	self._meta.context = context
end


function Component.get_interests(self)
	return self._component.interest
end


-- TODO: Определиться с get_node и node
-- get_node - берет ноду по ноде или строке
-- node - может брать ноду у компонента по схеме (если есть
-- template или таблица нод после gui.clone_tree)
function Component.get_node(self, node_or_name)
	local template_name = self:get_template() or const.EMPTY_STRING
	local nodes = self:get_nodes()

	if nodes then
		return nodes[template_name .. node_or_name]
	else
		if type(node_or_name) == const.STRING then
			return gui.get_node(template_name .. node_or_name)
		else
			return node_or_name
		end
	end
end


function Component.get_druid(self)
	local context = { _context = self }
	return setmetatable(context, { __index = self:get_context().druid })
end


function Component.initialize(self, name, interest)
	self._component = {
		name = name,
		interest = interest
	}
end


function Component.static.create(name, interest)
	-- Yea, inheritance here
	local new_class = class(name, Component)

	new_class.initialize = function(self)
		Component.initialize(self, name, interest)
	end

	return new_class
end


return Component
