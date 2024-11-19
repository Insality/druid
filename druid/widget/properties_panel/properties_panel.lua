local property_checkbox = require("druid.widget.properties_panel.properties.property_checkbox")
local property_slider = require("druid.widget.properties_panel.properties.property_slider")
local property_button = require("druid.widget.properties_panel.properties.property_button")
local property_input = require("druid.widget.properties_panel.properties.property_input")
local property_text = require("druid.widget.properties_panel.properties.property_text")

---@class properties_panel: druid.widget
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
	self.properties = {}
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
---@return property_checkbox
function M:add_checkbox(text, initial_value, on_change_callback)
	text = tostring(text)

	local nodes = gui.clone_tree(self.property_checkbox_prefab)
	local instance = self.druid:new_widget(property_checkbox, "property_checkbox", nodes)
	self:add_property(instance)

	instance.text_name:set_to(text)
	instance:set_value(initial_value, true)
	instance.button.on_click:subscribe(function()
		on_change_callback(instance:get_value())
	end)

	return instance
end


---@param text string
---@param initial_value number
---@param on_change_callback function
---@return property_slider
function M:add_slider(text, initial_value, on_change_callback)
	text = tostring(text)
	local nodes = gui.clone_tree(self.property_slider_prefab)
	local instance = self.druid:new_widget(property_slider, "property_slider", nodes)
	self:add_property(instance)

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
function M:add_button(text, on_click_callback, callback_context)
	local nodes = gui.clone_tree(self.property_button_prefab)
	local instance = self.druid:new_widget(property_button, "property_button", nodes)
	self:add_property(instance)

	instance.text_name:set_text(text)
	if on_click_callback then
		instance.button.on_click:subscribe(on_click_callback, callback_context)
	end

	return instance
end


function M:add_input(text, initial_value, on_change_callback)
	text = tostring(text)
	local nodes = gui.clone_tree(self.property_input_prefab)
	local instance = self.druid:new_widget(property_input, "property_input", nodes)
	self:add_property(instance)

	instance.text_name:set_text(text)
	instance.rich_input:set_text(initial_value)
	instance.rich_input:set_placeholder("")
	instance.rich_input.input.on_input_unselect:subscribe(function(_, value)
		on_change_callback(value)
	end)
end


---@param text string
---@param right_text string|nil
---@return property_text
function M:add_text(text, right_text)
	text = tostring(text)
	local nodes = gui.clone_tree(self.property_text_prefab)
	local instance = self.druid:new_widget(property_text, "property_text", nodes)
	self:add_property(instance)

	instance:set_text(text)
	instance:set_right_text(right_text)
	return instance
end


---@private
function M:add_property(widget)
	gui.set_enabled(widget.root, true)
	self.layout:add(widget.root)
	table.insert(self.properties, widget)
	local width = self.layout:get_size().x - self.layout.padding.x - self.layout.padding.z
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


return M
