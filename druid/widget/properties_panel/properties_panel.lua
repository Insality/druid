local property_checkbox = require("druid.widget.properties_panel.properties.property_checkbox")
local property_slider = require("druid.widget.properties_panel.properties.property_slider")
local property_button = require("druid.widget.properties_panel.properties.property_button")

---@class properties_panel: druid.widget
---@field root node
---@field text_no_properties node
---@field scroll druid.scroll
---@field druid druid_instance
local M = {}

---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	--self.root = self.druid:new_container("root")
	self.root = self:get_node("root")
	self.text_no_properties = self:get_node("text_no_properties")
	--self.root:add_container("text_header")

	self.properties = {}

	self.scroll = self.druid:new_scroll("scroll_view", "scroll_content")
	self.layout = self.druid:new_layout("scroll_content", "vertical")
		:set_hug_content(false, true)

	self.layout.on_size_changed:subscribe(self.on_size_changed, self)

	self.drag_corner = self.druid:new_drag("icon_drag", self.on_drag_corner)

	self.property_checkbox_prefab = self:get_node("property_checkbox/root")
	gui.set_enabled(self.property_checkbox_prefab, false)

	self.property_slider_prefab = self:get_node("property_slider/root")
	gui.set_enabled(self.property_slider_prefab, false)

	self.property_button_prefab = self:get_node("property_button/root")
	gui.set_enabled(self.property_button_prefab, false)

	self.container = self.druid:new_container(self.root)
	self.container:add_container("text_header")
	self.container:add_container("icon_drag")
	local container_scroll_view = self.container:add_container("scroll_view")
	container_scroll_view:add_container("scroll_content")
end


function M:on_drag_corner(dx, dy)
	local position = self.container:get_position()
	self.container:set_position(position.x + dx, position.y + dy)
end


function M:clear()
	for index = 1, #self.properties do
		self.druid:remove(self.properties[index])
	end
	self.properties = {}
	gui.set_enabled(self.text_no_properties, true)
end


function M:on_size_changed(new_size)
	new_size.x = new_size.x + 8
	new_size.y = new_size.y + 50 + 8

	self.container:set_size(new_size.x, new_size.y, gui.PIVOT_N)
end


---@param text_id string
---@param initial_value boolean
---@param on_change_callback function
---@return property_checkbox
function M:add_checkbox(text_id, initial_value, on_change_callback)
	local nodes = gui.clone_tree(self.property_checkbox_prefab)
	local instance = self.druid:new_widget(property_checkbox, "property_checkbox", nodes)
	instance.text_name:set_to(text_id)
	instance:set_value(initial_value, true)
	instance.button.on_click:subscribe(function()
		on_change_callback(instance:get_value())
	end)

	gui.set_enabled(instance.root, true)
	self.layout:add(instance.root)
	table.insert(self.properties, instance)
	gui.set_enabled(self.text_no_properties, false)

	return instance
end


---@param text_id string
---@param initial_value number
---@param on_change_callback function
---@return property_slider
function M:add_slider(text_id, initial_value, on_change_callback)
	local nodes = gui.clone_tree(self.property_slider_prefab)
	local instance = self.druid:new_widget(property_slider, "property_slider", nodes)
	instance.text_name:set_to(text_id)
	instance:set_value(initial_value, true)

	gui.set_enabled(instance.root, true)
	self.layout:add(instance.root)
	table.insert(self.properties, instance)
	gui.set_enabled(self.text_no_properties, false)

	instance.slider.on_change_value:subscribe(function(_, value)
		on_change_callback(value)
	end)

	return instance
end


---@param text_id string
---@param on_click_callback function|nil
---@param callback_context any|nil
function M:add_button(text_id, on_click_callback, callback_context)
	local nodes = gui.clone_tree(self.property_button_prefab)
	local instance = self.druid:new_widget(property_button, "property_button", nodes)
	instance.text_name:set_to(text_id)

	gui.set_enabled(instance.root, true)
	self.layout:add(instance.root)
	table.insert(self.properties, instance)
	gui.set_enabled(self.text_no_properties, false)

	if on_click_callback then
		instance.button.on_click:subscribe(on_click_callback, callback_context)
	end

	return instance
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

	if #self.properties == 0 then
		gui.set_enabled(self.text_no_properties, true)
	end
end


return M
