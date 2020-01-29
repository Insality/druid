local const = require("druid.const")

local M = {}
local instance = {}


function instance.get_style(self)
	if not self._meta.style then
		return const.EMPTY_TABLE
	end

	return self._meta.style[self._component.name] or const.EMPTY_TABLE
end


function instance.set_style(self, component_style)
	self._meta.style = component_style
end


function instance.set_template(self, template)
	self._meta.template = template
end


function instance.set_nodes(self, nodes)
	self._meta.nodes = nodes
end


function instance.get_context(self, context)
	return self._meta.context
end


function instance.set_context(self, context)
	self._meta.context = context
end


function instance.get_druid(self)
	local context = { _context = self }
	return setmetatable(context, { __index = self:get_context().druid })
end


function instance.setup_component(self, context, style)
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


function M.new(name, interest)
	local mt = {
		_component = {
			name = name,
			interest = interest
		}
	}
	local component = setmetatable(mt, { __index = instance })

	return component
end


return M