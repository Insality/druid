local const = require("druid.const")
local helper = require("druid.helper")

---@class druid.base_component.meta
---@field template string
---@field context table
---@field nodes table<hash, node>|nil
---@field style table|nil
---@field druid druid_instance
---@field input_enabled boolean
---@field children table
---@field parent druid.base_component|nil
---@field instance_class table

---@class druid.base_component.component
---@field name string
---@field input_priority number
---@field default_input_priority number
---@field _is_input_priority_changed boolean
---@field _uid number

---@class druid.base_component
---@field druid druid_instance Druid instance to create inner components
---@field init fun(self:druid.base_component, ...)|nil
---@field update fun(self:druid.base_component, dt:number)|nil
---@field on_remove fun(self:druid.base_component)|nil
---@field on_input fun(self:druid.base_component, action_id:number, action:table)|nil
---@field on_message fun(self:druid.base_component, message_id:hash, message:table, sender:userdata)|nil
---@field on_late_init fun(self:druid.base_component)|nil
---@field on_focus_lost fun(self:druid.base_component)|nil
---@field on_focus_gained fun(self:druid.base_component)|nil
---@field on_style_change fun(self:druid.base_component, style: table)|nil
---@field on_layout_change fun(self:druid.base_component)|nil
---@field on_window_resized fun(self:druid.base_component)|nil
---@field on_language_change fun(self:druid.base_component)|nil
---@field private _component druid.base_component.component
---@field private _meta druid.base_component.meta
local M = {}

local INTERESTS = {} -- Cache interests per component class in runtime


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
	---@cast self druid.base_component

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
	---@cast self druid.base_component

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
---@param nodes table<hash, node>
---@return druid.base_component
function M:set_nodes(nodes)
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
---@param nodes table<hash, node>|nil
---@return druid_instance
function M:get_druid(template, nodes)
	local context = { _context = self }
	local druid_instance = setmetatable(context, { __index = self._meta.druid })

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
---@return druid.base_component self The component itself for chaining
function M:set_input_priority(value, is_temporary)
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


---Reset component input priority to it's default value, that was set in `create` function or `set_input_priority`
---@return druid.base_component self The component itself for chaining
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
---@return druid.base_component self The component itself for chaining
function M:set_input_enabled(state)
	self._meta.input_enabled = state

	for index = 1, #self._meta.children do
		self._meta.children[index]:set_input_enabled(state)
	end

	return self
end


---Get parent component
---@return druid.base_component|nil parent The parent component if exist or nil
function M:get_parent_component()
	return self._meta.parent
end


--- Setup component context and his style table
---@param druid_instance table The parent druid instance
---@param context table Druid context. Usually it is self of script
---@param style table Druid style module
---@param instance_class table The component instance class
---@return druid.base_component BaseComponent itself
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
		parent = type(context) ~= "userdata" and context --[[@as druid.base_component]],
		instance_class = instance_class
	}

	self:set_style(style)
	self:set_template("")

	if self._meta.parent then
		self._meta.parent:__add_child(self)
	end

	return self
end


--- Return true, if input priority was changed
---@private
function M:_is_input_priority_changed()
	return self._component._is_input_priority_changed
end


--- Reset is_input_priority_changed field
---@private
function M:_reset_input_priority_changed()
	self._component._is_input_priority_changed = false
end


--- Get current component interests
---@return table List of component interests
---@private
function M:__get_interests()
	local instance_class = self._meta.instance_class
	if INTERESTS[instance_class] then
		return INTERESTS[instance_class]
	end

	local interests = {}
	for index = 1, #const.ALL_INTERESTS do
		local interest = const.ALL_INTERESTS[index]
		if self[interest] and type(self[interest]) == "function" then
			table.insert(interests, interest)
		end
	end

	INTERESTS[instance_class] = interests
	return INTERESTS[instance_class]
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
---@generic T: druid.base_component
---@param child T The druid component instance
---@return T self The component itself for chaining
---@private
function M:__add_child(child)
	table.insert(self._meta.children, child)

	return self
end



---Remove child from component children list
---@generic T: druid.base_component
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


--- Return all children components, recursive
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
---@return druid.base_component
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


return M
