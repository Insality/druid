local property_checkbox = require("druid.widget.properties_panel.properties.property_checkbox")
local property_slider = require("druid.widget.properties_panel.properties.property_slider")
local property_button = require("druid.widget.properties_panel.properties.property_button")
local property_input = require("druid.widget.properties_panel.properties.property_input")
local property_text = require("druid.widget.properties_panel.properties.property_text")
local property_left_right_selector = require("druid.widget.properties_panel.properties.property_left_right_selector")

---@class widget.properties_panel: druid.widget
---@field root node
---@field scroll druid.scroll
---@field druid druid_instance
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

	self.paginator = self:add_left_right_selector("Page", self.current_page, function(value)
		self.current_page = value
		self:refresh_page()
	end):set_number_type(1, 1, true)
	gui.set_enabled(self.paginator.root, false)

	-- Remove paginator from properties
	for index = 1, #self.properties do
		if self.properties[index] == self.paginator then
			table.remove(self.properties, index)
			break
		end
	end
end


function M:on_drag_widget(dx, dy)
	local position = self.container:get_position()
	self.container:set_position(position.x + dx, position.y + dy)
end


function M:clear()
	for index = 1, #self.properties do
		gui.delete_node(self.properties[index].root)
		self.druid:remove(self.properties[index])
	end
	self.layout:clear_layout()
	self.layout:add(self.paginator.root)

	self.properties = {}
	self.properties_constructors = {}

	self:refresh_page()
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
end


---@param text string
---@param initial_value boolean
---@param on_change_callback function
---@return widget.property_checkbox
function M:add_checkbox(text, initial_value, on_change_callback)
	local instance = self:create_from_prefab(property_checkbox, "property_checkbox", self.property_checkbox_prefab)

	instance.text_name:set_text(text)
	instance:set_value(initial_value, true)
	instance.button.on_click:subscribe(function()
		on_change_callback(instance:get_value())
	end)

	return instance
end


---@param text string
---@param initial_value number
---@param on_change_callback function
---@return widget.property_slider
function M:add_slider(text, initial_value, on_change_callback)
	local instance = self:create_from_prefab(property_slider, "property_slider", self.property_slider_prefab)

	instance.text_name:set_text(text)
	instance:set_value(initial_value, true)
	instance.slider.on_change_value:subscribe(function(_, value)
		on_change_callback(value)
	end)

	return instance
end


---@param text string
---@param on_click_callback function|nil
---@param callback_context any|nil
---@return widget.property_button
function M:add_button(text, on_click_callback, callback_context)
	local instance = self:create_from_prefab(property_button, "property_button", self.property_button_prefab)

	instance.text_name:set_text(text)
	if on_click_callback then
		instance.button.on_click:subscribe(on_click_callback, callback_context)
	end

	return instance
end


---@param text string
---@param initial_value string
---@param on_change_callback function
---@return widget.property_input
function M:add_input(text, initial_value, on_change_callback)
	local instance = self:create_from_prefab(property_input, "property_input", self.property_input_prefab)

	instance.text_name:set_text(text)
	instance.rich_input:set_text(initial_value)
	instance.rich_input:set_placeholder("")
	instance.rich_input.input.on_input_unselect:subscribe(function(_, value)
		on_change_callback(value)
	end)

	return instance
end


---@param text string
---@param right_text string|nil
---@return widget.property_text
function M:add_text(text, right_text)
	local instance = self:create_from_prefab(property_text, "property_text", self.property_text_prefab)

	instance:set_text(text)
	instance:set_right_text(right_text)

	return instance
end


---@param text string
---@param value string|number|nil
---@param on_change_callback fun(value: string|number)
---@return widget.property_left_right_selector
function M:add_left_right_selector(text, value, on_change_callback)
	local instance = self:create_from_prefab(property_left_right_selector, "property_left_right_selector", self.property_left_right_selector_prefab)

	instance:set_text(text)
	instance:set_value(value or 0, true)
	instance.on_change_value:subscribe(on_change_callback)

	return instance
end


---@private
function M:create_from_prefab(widget_class, widget_name, prefab)
	local nodes = gui.clone_tree(prefab)
	local instance = self.druid:new_widget(widget_class, widget_name, nodes)
	self:add_property(instance)
	return instance
end


---@private
function M:add_property(widget)
	gui.set_enabled(widget.root, true)
	self.layout:add(widget.root)

	table.insert(self.properties, widget)
	local width = self.layout:get_size().x - self.layout.padding.x - self.layout.padding.z
	widget.container:set_size(width)

	if #self.properties > self.properties_per_page then
		self:refresh_page()
	end

	return widget
end


function M:refresh_page()
	local start_index = (self.current_page - 1) * self.properties_per_page + 1
	local end_index = start_index + self.properties_per_page - 1

	for index = 1, #self.properties do
		local is_visible = index >= start_index and index <= end_index
		gui.set_enabled(self.properties[index].root, is_visible)
	end

	gui.set_enabled(self.paginator.root, #self.properties > self.properties_per_page)
	self.paginator:set_number_type(1, math.ceil(#self.properties / self.properties_per_page), true)
	self.paginator.text_value:set_text(self.current_page .. " / " .. math.ceil(#self.properties / self.properties_per_page))

	self.layout:set_dirty()
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
	self.paginator:set_value(self.current_page, true)
	self:refresh_page()
end


return M
