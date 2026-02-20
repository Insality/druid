local component = require("druid.component")

local property_checkbox = require("example.components.properties_panel.properties.property_checkbox")
local property_slider = require("example.components.properties_panel.properties.property_slider")
local property_button = require("example.components.properties_panel.properties.property_button")

---@class properties_panel: druid.component
---@field root druid.container
---@field text_no_properties druid.lang_text
---@field scroll druid.scroll
---@field druid druid.instance
local M = component.create("properties_panel")

---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.root = self.druid:new_container("root") --[[@as druid.container]]
	self.root:add_container("text_header")
	self.root:add_container("separator")
	--self.root:add_container("scroll_view", nil, function()
	--	self.scroll:update_view_size()
	--end)

	self.properties = {}

	self.druid:new_lang_text("text_header", "ui_properties_panel")
	self.text_no_properties = self.druid:new_lang_text("text_no_properties", "ui_no_properties") --[[@as druid.lang_text]]

	self.scroll = self.druid:new_scroll("scroll_view", "scroll_content")
	self.grid = self.druid:new_grid("scroll_content", "item_size", 1)
	self.scroll:bind_grid(self.grid)
	self.scroll.on_scroll:subscribe(self.on_scroll)
	self.grid.on_change_items:subscribe(self.on_grid_change_items)

	self.slider = self.druid:new_slider("scroll_bar_pin", vmath.vector3(-8, 48-290.0, 0), self.on_slider_change)
	self.slider:set_input_node("scroll_bar_view")

	self.property_checkbox_prefab = self:get_node("property_checkbox/root")
	gui.set_enabled(self.property_checkbox_prefab, false)

	self.property_slider_prefab = self:get_node("property_slider/root")
	gui.set_enabled(self.property_slider_prefab, false)

	self.property_button_prefab = self:get_node("property_button/root")
	gui.set_enabled(self.property_button_prefab, false)
end


function M:clear()
	for index = 1, #self.properties do
		self.druid:remove(self.properties[index])
	end
	self.properties = {}

	local nodes = self.grid.nodes
	for index = 1, #nodes do
		gui.delete_node(nodes[index])
	end
	self.grid:clear()

	gui.set_enabled(self.text_no_properties.text.node, true)
end


---@param text_id string
---@param initial_value boolean
---@param on_change_callback function
---@return property_checkbox
function M:add_checkbox(text_id, initial_value, on_change_callback)
	local instance = self.druid:new_widget(property_checkbox, "property_checkbox", self.property_checkbox_prefab) --[[@as property_checkbox]]
	instance.text_name:translate(text_id)
	instance:set_value(initial_value, true)
	instance.button.on_click:subscribe(function()
		on_change_callback(instance:get_value())
	end)

	gui.set_enabled(instance.root.node, true)
	self.grid:add(instance.root.node)
	table.insert(self.properties, instance)
	gui.set_enabled(self.text_no_properties.text.node, false)

	return instance
end


---@param text_id string
---@param initial_value number
---@param on_change_callback function
---@return property_slider
function M:add_slider(text_id, initial_value, on_change_callback)
	local instance = self.druid:new_widget(property_slider, "property_slider", self.property_slider_prefab) --[[@as property_slider]]
	instance.text_name:translate(text_id)
	instance:set_value(initial_value, true)

	gui.set_enabled(instance.root.node, true)
	self.grid:add(instance.root.node)
	table.insert(self.properties, instance)
	gui.set_enabled(self.text_no_properties.text.node, false)

	instance.slider.on_change_value:subscribe(function(_, value)
		on_change_callback(value)
	end)

	return instance
end


---@param text_id string
---@param on_click_callback function
function M:add_button(text_id, on_click_callback)
	local instance = self.druid:new_widget(property_button, "property_button", self.property_button_prefab) --[[@as property_button]]
	instance.text_name:translate(text_id)

	gui.set_enabled(instance.root, true)
	self.grid:add(instance.root)
	table.insert(self.properties, instance)
	gui.set_enabled(self.text_no_properties.text.node, false)

	instance.button.on_click:subscribe(on_click_callback)

	return instance
end


---@param value number in range [0..1]
function M:on_slider_change(value)
	self.scroll:scroll_to_percent(vmath.vector3(0, 1 - value, 0), true)
end


function M:on_scroll()
	local scroll_percent = self.scroll:get_percent()
	self.slider:set(1 - scroll_percent.y, true)
end


function M:on_grid_change_items()
	local is_scroll_available = self.scroll.drag.can_y
	gui.set_enabled(self.slider.node, is_scroll_available)
	if is_scroll_available then
		local scroll_percent = self.scroll:get_percent()
		self.slider:set(1 - scroll_percent.y, true)
	end
end

return M
