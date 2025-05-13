local const = require("druid.const")
local helper = require("druid.helper")

---@class druid.component.meta
---@field template string
---@field context table
---@field nodes table<hash, node>|nil
---@field style table|nil
---@field druid druid.instance
---@field input_enabled boolean
---@field children table
---@field parent druid.component|nil
---@field instance_class table

---@class druid.component.component
---@field name string
---@field input_priority number
---@field default_input_priority number
---@field _is_input_priority_changed boolean
---@field _uid number

---@class druid.component
---@field druid druid.instance Druid instance to create inner components
---@field init fun(self:druid.component, ...)|nil Called when component is created
---@field update fun(self:druid.component, dt:number)|nil Called every frame
---@field on_remove fun(self:druid.component)|nil Called when component is removed
---@field on_input fun(self:druid.component, action_id:hash, action:table)|nil Called when input event is triggered
---@field on_input_interrupt fun(self:druid.component, action_id:hash, action:table)|nil Called when input event is consumed before
---@field on_message fun(self:druid.component, message_id:hash, message:table, sender:url)|nil Called when message is received
---@field on_late_init fun(self:druid.component)|nil Called before update once time after GUI init
---@field on_focus_lost fun(self:druid.component)|nil Called when app lost focus
---@field on_focus_gained fun(self:druid.component)|nil Called when app gained focus
---@field on_style_change fun(self:druid.component, style: table)|nil Called when style is changed
---@field on_layout_change fun(self:druid.component)|nil Called when GUI layout is changed
---@field on_window_resized fun(self:druid.component)|nil Called when window is resized
---@field on_language_change fun(self:druid.component)|nil Called when language is changed
---@field private _component druid.component.component
---@field private _meta druid.component.meta
local M = {}


local uid = 0
---@private
function M.create_uid()
	uid = uid + 1
	return uid
end


---Set component style. Pass nil to clear style
---@generic T
---@param self T
---@param druid_style table|nil
---@return T self The component itself for chaining
function M:set_style(druid_style)
	---@cast self druid.component

	self._meta.style = druid_style or {}
	local component_style = self._meta.style[self._component.name] or {}

	if self.on_style_change then
		self:on_style_change(component_style)
	end

	return self
end


---Set component template name. Pass nil to clear template.
---This template id used to access nodes inside the template on GUI scene.
---Parent template will be added automatically if exist.
---@generic T
---@param self T
---@param template string|nil
---@return T self The component itself for chaining
function M:set_template(template)
	---@cast self druid.component

	template = template or ""

	local parent = self:get_parent_component()
	if parent then
		local parent_template = parent:get_template()
		if parent_template and #parent_template > 0 then
			if #template > 0 then
				template = "/" .. template
			end
			template = parent_template .. template
		end
	end

	if template ~= "" then
		self._meta.template = template
	else
		self._meta.template = nil
	end

	return self
end


---Get full template name.
---@return string
function M:get_template()
	return self._meta.template
end


---Set current component nodes, returned from `gui.clone_tree` function.
---@param nodes table<hash, node>|node|string|nil The nodes table from gui.clone_tree or prefab node to use for clone or node id to clone
---@return druid.component
function M:set_nodes(nodes)
	if type(nodes) == "string" then
		nodes = self:get_node(nodes)
	end
	if type(nodes) == "userdata" then
		nodes = gui.clone_tree(nodes) --[[@as table<hash, node>]]
	end

	-- When we use gui.clone_tree in inner template (template inside other template)
	-- this nodes have no id. We have table: hash(correct_id) : hash("") or hash("_nodeX"
	-- It's wrong and we use this hack to fix this
	if nodes then
		for id, node in pairs(nodes) do
			gui.set_id(node, id)
		end
	end

	self._meta.nodes = nodes

	return self
end


---Return current component context
---@return any context Usually it's self of script but can be any other Druid component
function M:get_context()
	return self._meta.context
end


---Get component node by node_id. Respect to current template and nodes.
---@param node_id string|node
---@return node
function M:get_node(node_id)
	return helper.get_node(node_id, self:get_template(), self:get_nodes())
end


---Get Druid instance for inner component creation.
---@param template string|nil
---@param nodes table<hash, node>|node|string|nil The nodes table from gui.clone_tree or prefab node to use for clone or node id to clone
---@return druid.instance
function M:get_druid(template, nodes)
	local druid_instance = setmetatable({
		_context = self
	}, { __index = self._meta.druid })

	if template then
		self:set_template(template)
	end

	if nodes then
		self:set_nodes(nodes)
	end

	return druid_instance
end


---Get component name
---@return string name The component name + uid
function M:get_name()
	return self._component.name .. M.create_uid()
end


---Get parent component name
---@return string|nil parent_name The parent component name if exist or nil
function M:get_parent_name()
	local parent = self:get_parent_component()
	return parent and parent:get_name()
end


---Get component input priority, the bigger number processed first. Default value: 10
---@return number
function M:get_input_priority()
	return self._component.input_priority
end


---Set component input priority, the bigger number processed first. Default value: 10
---@param value number
---@param is_temporary boolean|nil If true, the reset input priority will return to previous value
---@return druid.component self The component itself for chaining
function M:set_input_priority(value, is_temporary)
	assert(value)

	local component = self._component

	if component.input_priority == value then
		return self
	end

	component.input_priority = value
	component._is_input_priority_changed = true

	if not is_temporary then
		component.default_input_priority = value
	end

	local children = self:get_childrens()
	for i = 1, #children do
		children[i]:set_input_priority(value, is_temporary)
	end

	return self
end


---Reset component input priority to it's default value, that was set in `create` function or `set_input_priority`
---@return druid.component self The component itself for chaining
function M:reset_input_priority()
	self:set_input_priority(self._component.default_input_priority)
	return self
end


---Get component UID, unique identifier created in component creation order.
---@return number uid The component uid
function M:get_uid()
	return self._component._uid
end


---Set component input state. By default it's enabled.
---If input is disabled, the component will not receive input events.
---Recursive for all children components.
---@param state boolean
---@return druid.component self The component itself for chaining
function M:set_input_enabled(state)
	self._meta.input_enabled = state

	for index = 1, #self._meta.children do
		self._meta.children[index]:set_input_enabled(state)
	end

	return self
end


---Get component input state. By default it's enabled. Can be disabled by `set_input_enabled` function.
---@return boolean
function M:get_input_enabled()
	return self._meta.input_enabled
end


---Get parent component
---@return druid.component|nil parent_component The parent component if exist or nil
function M:get_parent_component()
	return self._meta.parent
end


---Setup component context and his style table
---@param druid_instance druid.instance The parent druid instance
---@param context table Druid context. Usually it is self of script
---@param style table Druid style module
---@param instance_class table The component instance class
---@return druid.component BaseComponent itself
---@private
function M:setup_component(druid_instance, context, style, instance_class)
	self._meta = {
		template = "",
		context = context,
		nodes = nil,
		style = nil,
		druid = druid_instance,
		input_enabled = true,
		children = {},
		parent = type(context) ~= "userdata" and context --[[@as druid.component]],
		instance_class = instance_class
	}

	self:set_style(style)
	self:set_template("")

	if self._meta.parent then
		self._meta.parent:__add_child(self)
	end

	return self
end


---Return true, if input priority was changed
---@private
function M:_is_input_priority_changed()
	return self._component._is_input_priority_changed
end


---Reset is_input_priority_changed field
---@private
function M:_reset_input_priority_changed()
	self._component._is_input_priority_changed = false
end


---Get current component nodes
---@return table<hash, node>|nil
function M:get_nodes()
	local nodes = self._meta.nodes
	local parent = self:get_parent_component()
	if parent then
		nodes = nodes or parent:get_nodes()
	end

	return nodes
end


---Add child to component children list
---@generic T: druid.component
---@param child T The druid component instance
---@return T self The component itself for chaining
---@private
function M:__add_child(child)
	table.insert(self._meta.children, child)

	return self
end


---Remove child from component children list
---@generic T: druid.component
---@param child T The druid component instance
---@return boolean true if child was removed
---@private
function M:__remove_child(child)
	for i = #self._meta.children, 1, -1 do
		if self._meta.children[i] == child then
			table.remove(self._meta.children, i)
			return true
		end
	end

	return false
end


---Return all children components, recursive
---@return table Array of childrens if the Druid component instance
function M:get_childrens()
	local childrens = {}

	for i = 1, #self._meta.children do
		local children = self._meta.children[i]

		table.insert(childrens, children)
		helper.add_array(childrens, children:get_childrens())
	end

	return childrens
end


---Сreate a new component class, which will inherit from the base Druid component.
---@param name string|nil The name of the component
---@param input_priority number|nil The input priority. The bigger number processed first. Default value: 10
---@return druid.component
function M.create(name, input_priority)
	local new_class = setmetatable({}, {
		__index = M,
		__call = function(cls, ...)
			local self = setmetatable({
				_component = {
					name = name or "Druid Component",
					input_priority = input_priority or const.PRIORITY_INPUT,
					default_input_priority = input_priority or const.PRIORITY_INPUT,
					_is_input_priority_changed = true, -- Default true for sort once time after GUI init
					_uid = M.create_uid()
				}
			}, {
				__index = cls
			})
			return self
		end
	})

	return new_class
end


local WIDGET_METATABLE = { __index = M }

---Create the Druid component instance
---@param self druid.instance
---@param widget_class druid.widget
---@param context table
---@return druid.widget
function M.create_widget(self, widget_class, context)
	local instance = setmetatable({}, {
		__index = setmetatable(widget_class, WIDGET_METATABLE)
	})

	instance._component = {
		_uid = M.create_uid(),
		name = "Druid Widget",
		input_priority = const.PRIORITY_INPUT,
		default_input_priority = const.PRIORITY_INPUT,
		_is_input_priority_changed = true, -- Default true for sort once time after GUI init
	}

	-- I'll hide a meta fields under metatable to hide this tables from pprint output
	-- cause it's leads to recursive pprint's from (druid = self)
	-- Wish this to be better, since it can reduce a memory usage
	instance._meta = setmetatable({}, { __index = {
		druid = self,
		template = "",
		nodes = nil,
		context = context,
		style = nil,
		input_enabled = true,
		children = {},
		parent = type(context) ~= "userdata" and context or nil,
		instance_class = widget_class
	}})

	-- Register
	if instance._meta.parent then
		instance._meta.parent:__add_child(instance)
	end

	---@cast instance druid.widget
	return instance
end


return M
