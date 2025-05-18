local helper = require("druid.helper")
local property_checkbox = require("druid.widget.properties_panel.properties.property_checkbox")
local property_slider = require("druid.widget.properties_panel.properties.property_slider")
local property_button = require("druid.widget.properties_panel.properties.property_button")
local property_input = require("druid.widget.properties_panel.properties.property_input")
local property_text = require("druid.widget.properties_panel.properties.property_text")
local property_left_right_selector = require("druid.widget.properties_panel.properties.property_left_right_selector")
local property_vector3 = require("druid.widget.properties_panel.properties.property_vector3")

---@class druid.widget.properties_panel: druid.widget
---@field root node
---@field scroll druid.scroll
---@field layout druid.layout
---@field container druid.container
---@field container_content druid.container
---@field container_scroll_view druid.container
---@field contaienr_scroll_content druid.container
---@field button_hidden druid.button
---@field text_header druid.text
---@field paginator druid.widget.property_left_right_selector
---@field properties druid.widget[] List of created properties
---@field properties_constructors fun()[] List of properties functions to create a new widget. Used to not spawn non-visible widgets but keep the reference
local M = {}


function M:init()
	self.root = self:get_node("root")
	self.content = self:get_node("content")

	self.container = self.druid:new_container(self.root)
	self.container:add_container("header")
	self.container_content = self.container:add_container("content")
	self.container_scroll_view = self.container_content:add_container("scroll_view")
	self.contaienr_scroll_content = self.container_scroll_view:add_container("scroll_content")

	self.default_size = self.container:get_size()

	-- To have ability to go back to previous scene, collections of all properties to rebuild
	self.scenes = {}

	self.properties = {}
	self.properties_constructors = {}
	self.current_page = 1
	self.properties_per_page = 15

	self.text_header = self.druid:new_text("text_header")
	self.scroll = self.druid:new_scroll("scroll_view", "scroll_content")
	self.layout = self.druid:new_layout("scroll_content", "vertical")
		:set_hug_content(false, true)
		:set_padding(nil, 0)

	self.layout.on_size_changed:subscribe(self.on_size_changed, self)

	self.druid:new_drag("header", self.on_drag_widget)
	self.button_hidden = self.druid:new_button("icon_drag", function()
		self:set_hidden(not self._is_hidden)
	end):set_style(nil)

	self.button_back = self.druid:new_button("icon_back", function()
		self:previous_scene()
	end)
	gui.set_enabled(self.button_back.node, false)

	self.button_refresh = self.druid:new_button("icon_refresh", function()
		self.is_dirty = true
	end)

	-- We not using as a part of properties, since it handled in a way to be paginable
	self.paginator = self.druid:new_widget(property_left_right_selector, "property_left_right_selector", "root")
	self.paginator:set_text("Page")
	self.paginator:set_number_type(1, 1, true)
	self.paginator:set_value(self.current_page)
	self.paginator.on_change_value:subscribe(function(value)
		self:set_page(value)
	end)
	local width = self.layout:get_content_size()
	self.paginator.container:set_size(width)

	gui.set_enabled(self.paginator.root, false)

	gui.set_enabled(self:get_node("property_checkbox/root"), false)
	gui.set_enabled(self:get_node("property_slider/root"), false)
	gui.set_enabled(self:get_node("property_button/root"), false)
	gui.set_enabled(self:get_node("property_input/root"), false)
	gui.set_enabled(self:get_node("property_text/root"), false)
	gui.set_enabled(self:get_node("property_left_right_selector/root"), false)
	gui.set_enabled(self:get_node("property_vector3/root"), false)
end


function M:on_remove()
	self:clear()
end


function M:on_drag_widget(dx, dy)
	local position = self.container:get_position()
	self.container:set_position(position.x + dx, position.y + dy)
end


function M:clear_created_properties()
	for index = 1, #self.properties do
		local property = self.properties[index]
		local root = property.root --[[@as node]]

		if root then
			-- If prefab used clone nodes we can remove it
			if property:get_nodes() then
				gui.delete_node(root)
			else
				-- Probably we have component placed on scene directly
				gui.set_enabled(root, false)
			end
		end

		self.druid:remove(self.properties[index])
	end
	self.properties = {}

	self.layout:clear_layout()

	-- Use paginator as "pinned" widget
	self.layout:add(self.paginator.root)
end


function M:next_scene()
	local scene = {
		header = self.text_header:get_text(),
		current_page = self.current_page,
	}

	helper.add_array(scene, self.properties_constructors)
	table.insert(self.scenes, scene)

	self:clear()

	self.is_dirty = true

	gui.set_enabled(self.button_back.node, #self.scenes > 0)
end


function M:previous_scene()
	local scene = table.remove(self.scenes)
	self:clear()
	helper.add_array(self.properties_constructors, scene)

	self.text_header:set_text(scene.header)
	self.current_page = scene.current_page

	self.is_dirty = true

	gui.set_enabled(self.button_back.node, #self.scenes > 0)
end


function M:clear()
	self:clear_created_properties()
	self.properties_constructors = {}
end


function M:on_size_changed(new_size)
	self.container_content:set_size(new_size.x, new_size.y, gui.PIVOT_N)

	self.default_size = vmath.vector3(new_size.x, new_size.y + 50, 0)
	if not self._is_hidden then
		self.container:set_size(self.default_size.x, self.default_size.y, gui.PIVOT_N)
	end

	local width = self.layout:get_size().x - self.layout.padding.x - self.layout.padding.z
	for index = 1, #self.properties do
		local property = self.properties[index]
		local container = property.container --[[@as druid.container]]
		if container then
			container:set_size(width)
		end
	end
	self.paginator.container:set_size(width)
end


function M:update(dt)
	if self.is_dirty then
		self.is_dirty = false

		self:clear_created_properties()

		local properties_count = #self.properties_constructors

		-- Render all current properties
		local start_index = (self.current_page - 1) * self.properties_per_page + 1
		local end_index = start_index + self.properties_per_page - 1
		end_index = math.min(end_index, properties_count)

		local is_paginator_visible = properties_count > self.properties_per_page
		gui.set_enabled(self.paginator.root, is_paginator_visible)
		self.paginator:set_number_type(1, math.ceil(properties_count / self.properties_per_page), true)
		self.paginator.text_value:set_text(self.current_page .. " / " .. math.ceil(properties_count / self.properties_per_page))

		for index = start_index, end_index do
			self.properties_constructors[index]()
		end
	end
end


---@param on_create fun(checkbox: druid.widget.property_checkbox)|nil
---@return druid.widget.properties_panel
function M:add_checkbox(on_create)
	return self:add_inner_widget(property_checkbox, "property_checkbox", "root", on_create)
end


---@param on_create fun(slider: druid.widget.property_slider)|nil
---@return druid.widget.properties_panel
function M:add_slider(on_create)
	return self:add_inner_widget(property_slider, "property_slider", "root", on_create)
end


---@param on_create fun(button: druid.widget.property_button)|nil
---@return druid.widget.properties_panel
function M:add_button(on_create)
	return self:add_inner_widget(property_button, "property_button", "root", on_create)
end


---@param on_create fun(input: druid.widget.property_input)|nil
---@return druid.widget.properties_panel
function M:add_input(on_create)
	return self:add_inner_widget(property_input, "property_input", "root", on_create)
end


---@param on_create fun(text: druid.widget.property_text)|nil
function M:add_text(on_create)
	return self:add_inner_widget(property_text, "property_text", "root", on_create)
end


---@param on_create fun(selector: druid.widget.property_left_right_selector)|nil
function M:add_left_right_selector(on_create)
	return self:add_inner_widget(property_left_right_selector, "property_left_right_selector", "root", on_create)
end


---@param on_create fun(vector3: druid.widget.property_vector3)|nil
function M:add_vector3(on_create)
	return self:add_inner_widget(property_vector3, "property_vector3", "root", on_create)
end


---@generic T: druid.widget
---@param widget_class T
---@param template string|nil
---@param nodes table<hash, node>|string|node|nil
---@param on_create fun(widget: T)|nil
---@return druid.widget.properties_panel
function M:add_inner_widget(widget_class, template, nodes, on_create)
	table.insert(self.properties_constructors, function()
		local widget = self.druid:new_widget(widget_class, template, nodes)

		self:add_property(widget)
		if on_create then
			on_create(widget)
		end
	end)

	self.is_dirty = true

	return self
end


---@param create_widget_callback fun(): druid.widget
---@return druid.widget.properties_panel
function M:add_widget(create_widget_callback)
	table.insert(self.properties_constructors, function()
		local widget = create_widget_callback()
		self:add_property(widget)
	end)

	self.is_dirty = true

	return self
end


---@private
function M:create_from_prefab(widget_class, template, nodes)
	return self:add_property(self.druid:new_widget(widget_class, template, nodes))
end


---@private
function M:add_property(widget)
	gui.set_enabled(widget.root, true)
	table.insert(self.properties, widget)
	local width = self.layout:get_content_size()
	widget.container:set_size(width)

	self.layout:add(widget.root)

	return widget
end


function M:remove(widget)
	for index = 1, #self.properties do
		if self.properties[index] == widget then
			self.druid:remove(widget)
			self.layout:remove(widget.root)

			-- If prefab used clone nodes we can remove it
			if widget:get_nodes() then
				gui.delete_node(widget.root)
			else
				-- Probably we have component placed on scene directly
				gui.set_enabled(widget.root, false)
			end

			table.remove(self.properties, index)
			break
		end
	end
end


---Force to refresh properties next update
function M:set_dirty()
	self.is_dirty = true
end


function M:set_hidden(is_hidden)
	self._is_hidden = is_hidden
	local hidden_size = gui.get_size(self:get_node("header"))

	local new_size = self._is_hidden and hidden_size or self.default_size
	self.container:set_size(new_size.x, new_size.y, gui.PIVOT_N)

	gui.set_enabled(self.content, not self._is_hidden)
end


function M:is_hidden()
	return self._is_hidden
end


function M:load_previous_page()
	self.current_page = self.current_page - 1
	self.is_dirty = true
end


---@param properties_per_page number
function M:set_properties_per_page(properties_per_page)
	self.properties_per_page = properties_per_page
end


---Set a page of current scene
---@param page number
function M:set_page(page)
	self.current_page = page
	self.is_dirty = true
end


---Set a text at left top corner of the properties panel
---@param header string
function M:set_header(header)
	self.text_header:set_text(header)
end


---@param data table
function M:render_lua_table(data)
	local component_order = {}
	for component_id in pairs(data) do
		table.insert(component_order, component_id)
	end
	table.sort(component_order, function(a, b)
		local a_type = type(data[a])
		local b_type = type(data[b])
		if a_type ~= b_type then
			return a_type < b_type
		end
		if type(a) == "number" and type(b) == "number" then
			return a < b
		end
		return tostring(a) < tostring(b)
	end)

	for i = 1, #component_order do
		local component_id = component_order[i]
		self:add_property_component(component_id, data)
	end

	local metatable = getmetatable(data)
	if metatable and metatable.__index and type(metatable.__index) == "table" then
		local metatable_order = {}
		for key in pairs(metatable.__index) do
			table.insert(metatable_order, key)
		end
		table.sort(metatable_order)

		for i = 1, #metatable_order do
			local component_id = metatable_order[i]
			local component = metatable.__index[component_id]
			self:add_property_component("M:" .. component_id, data)
		end
	end
end


---@private
---@param component_id string
---@param data table
function M:add_property_component(component_id, data)
	local component = data[component_id]
	local component_type = type(component)

	if component_type == "table" then
		self:add_button(function(button)
			local is_empty = next(component) == nil
			local is_array = component[1] ~= nil
			local name = "Inspect"
			if is_empty then
				name = "Inspect (Empty)"
			end
			if is_array then
				name = "Inspect (" .. #component .. ")"
			end

			local button_name = component_id
			-- If it's a number or array, try to get the id/name/prefab_id from the component
			if type(component) == "table" and type(component_id) == "number" then
				local extracted_id = component.name or component.prefab_id or component.node_id or component.id
				if extracted_id then
					button_name = component_id .. ". " .. extracted_id
				end
			end

			button:set_text_property(button_name)
			button:set_text_button(name)
			button.button.on_click:subscribe(function()
				self:next_scene()
				self:set_header(button_name)
				self:render_lua_table(component)
			end)
		end)
	end

	if component_type == "string" then
		self:add_input(function(input)
			input:set_text_property(tostring(component_id))
			input:set_text_value(tostring(data[component_id]))
			input:on_change(function(_, value)
				data[component_id] = value
			end)
		end)
	end

	if component_type == "number" then
		self:add_input(function(input)
			input:set_text_property(tostring(component_id))
			input:set_text_value(tostring(helper.round(data[component_id], 3)))
			input:on_change(function(_, value)
				data[component_id] = tonumber(value)
			end)
		end)
	end

	if component_type == "boolean" then
		self:add_checkbox(function(checkbox)
			checkbox:set_text_property(tostring(component_id))
			checkbox:set_value(data[component_id])
			checkbox:on_change(function(value)
				data[component_id] = value
			end)
		end)
	end

	if component_type == "userdata" then
		if types.is_vector3(component) then
			---@cast component vector3
			self:add_vector3(function(vector3)
				vector3:set_text_property(tostring(component_id))
				vector3:set_value(data[component_id].x, data[component_id].y, data[component_id].z)
				vector3.on_change:subscribe(function(value)
					data[component_id].x = value.x
					data[component_id].y = value.y
					data[component_id].z = value.z
				end)
			end)
		else
			self:add_text(function(text)
				text:set_text_property(tostring(component_id))
				text:set_text_value(tostring(data[component_id]))
			end)
		end
	end

	if component_type == "function" then
		self:add_button(function(button)
			button:set_text_property(tostring(component_id))
			button:set_text_button("Call")
			button.button.on_click:subscribe(function()
				component(data)
			end)
		end)
	end
end



return M
