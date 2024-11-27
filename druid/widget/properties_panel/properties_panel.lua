local property_checkbox = require("druid.widget.properties_panel.properties.property_checkbox")
local property_slider = require("druid.widget.properties_panel.properties.property_slider")
local property_button = require("druid.widget.properties_panel.properties.property_button")
local property_input = require("druid.widget.properties_panel.properties.property_input")
local property_text = require("druid.widget.properties_panel.properties.property_text")
local property_left_right_selector = require("druid.widget.properties_panel.properties.property_left_right_selector")

---@class widget.properties_panel: druid.widget
---@field root node
---@field scroll druid.scroll
---@field layout druid.layout
---@field container druid.container
---@field container_content druid.container
---@field container_scroll_view druid.container
---@field contaienr_scroll_content druid.container
---@field text_header druid.text
---@field paginator widget.property_left_right_selector
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
	self.druid:new_button("icon_drag", self.toggle_hide)
		:set_style(nil)

	self.property_checkbox_prefab = self:get_node("property_checkbox/root")
	gui.set_enabled(self.property_checkbox_prefab, false)

	self.property_slider_prefab = self:get_node("property_slider/root")
	gui.set_enabled(self.property_slider_prefab, false)

	self.property_button_prefab = self:get_node("property_button/root")
	gui.set_enabled(self.property_button_prefab, false)

	self.property_input_prefab = self:get_node("property_input/root")
	gui.set_enabled(self.property_input_prefab, false)

	self.property_text_prefab = self:get_node("property_text/root")
	gui.set_enabled(self.property_text_prefab, false)

	self.property_left_right_selector_prefab = self:get_node("property_left_right_selector/root")
	gui.set_enabled(self.property_left_right_selector_prefab, false)

	-- We not using as a part of properties, since it handled in a way to be paginable
	self.paginator = self.druid:new_widget(property_left_right_selector, "property_left_right_selector", self.property_left_right_selector_prefab)
	self.paginator:set_text("Page")
	self.paginator:set_number_type(1, 1, true)
	self.paginator:set_value(self.current_page)
	self.paginator.on_change_value:subscribe(function(value)
		self:set_page(value)
	end)
	local width = self.layout:get_content_size()
	self.paginator.container:set_size(width)

	gui.set_enabled(self.paginator.root, false)
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
		gui.delete_node(self.properties[index].root)
		self.druid:remove(self.properties[index])
	end
	self.properties = {}

	self.layout:clear_layout()

	-- Use paginator as "pinned" widget
	self.layout:add(self.paginator.root)
end


function M:clear()
	self:clear_created_properties()
	self.properties_constructors = {}
end


function M:on_size_changed(new_size)
	self.container_content:set_size(new_size.x, new_size.y, gui.PIVOT_N)

	self.default_size = vmath.vector3(new_size.x, new_size.y + 50, 0)
	if not self.is_hidden then
		self.container:set_size(self.default_size.x, self.default_size.y, gui.PIVOT_N)
	end

	local width = self.layout:get_size().x - self.layout.padding.x - self.layout.padding.z
	for index = 1, #self.properties do
		self.properties[index].container:set_size(width)
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


---@param on_create fun(checkbox: widget.property_checkbox)|nil
---@return widget.properties_panel
function M:add_checkbox(on_create)
	return self:add_inner_widget(property_checkbox, "property_checkbox", self.property_checkbox_prefab, on_create)
end


---@param on_create fun(slider: widget.property_slider)|nil
---@return widget.properties_panel
function M:add_slider(on_create)
	return self:add_inner_widget(property_slider, "property_slider", self.property_slider_prefab, on_create)
end


---@param on_create fun(button: widget.property_button)|nil
---@return widget.properties_panel
function M:add_button(on_create)
	return self:add_inner_widget(property_button, "property_button", self.property_button_prefab, on_create)
end


---@param on_create fun(input: widget.property_input)|nil
---@return widget.properties_panel
function M:add_input(on_create)
	return self:add_inner_widget(property_input, "property_input", self.property_input_prefab, on_create)
end


---@param on_create fun(text: widget.property_text)|nil
function M:add_text(on_create)
	return self:add_inner_widget(property_text, "property_text", self.property_text_prefab, on_create)
end


---@param on_create fun(selector: widget.property_left_right_selector)|nil
function M:add_left_right_selector(on_create)
	return self:add_inner_widget(property_left_right_selector, "property_left_right_selector", self.property_left_right_selector_prefab, on_create)
end


---@generic T: druid.widget
---@param widget_class T
---@param template string|nil
---@param nodes table<string, node>|node|nil
---@param on_create fun(widget: T)|nil
---@return widget.properties_panel
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
---@return widget.properties_panel
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
	self.layout:add(widget.root)

	table.insert(self.properties, widget)
	local width = self.layout:get_content_size()
	widget.container:set_size(width)

	return widget
end


function M:remove(widget)
	for index = 1, #self.properties do
		if self.properties[index] == widget then
			self.druid:remove(widget)
			self.layout:remove(widget.root)
			gui.delete_node(widget.root)
			table.remove(self.properties, index)
			break
		end
	end
end


function M:toggle_hide()
	self.is_hidden = not self.is_hidden
	local hidden_size = gui.get_size(self:get_node("header"))

	local new_size = self.is_hidden and hidden_size or self.default_size
	self.container:set_size(new_size.x, new_size.y, gui.PIVOT_N)

	gui.set_enabled(self.content, not self.is_hidden)
	return self
end


---@param properties_per_page number
function M:set_properties_per_page(properties_per_page)
	self.properties_per_page = properties_per_page
end


function M:set_page(page)
	self.current_page = page
	self.is_dirty = true
end


return M
