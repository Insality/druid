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
	local nodes = gui.clone_tree(self.property_checkbox_prefab)
	local instance = self.druid:new_widget(property_checkbox, "property_checkbox", nodes) --[[@as property_checkbox]]
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
	local nodes = gui.clone_tree(self.property_slider_prefab)
	local instance = self.druid:new_widget(property_slider, "property_slider", nodes) --[[@as property_slider]]
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
	local nodes = gui.clone_tree(self.property_button_prefab)
	local instance = self.druid:new_widget(property_button, "property_button", nodes) --[[@as property_button]]
	instance.text_name:translate(text_id)

	gui.set_enabled(instance.root, true)
	self.grid:add(instance.root)
	table.insert(self.properties, instance)
	gui.set_enabled(self.text_no_properties.text.node, false)

	instance.button.on_click:subscribe(on_click_callback)

	return instance
end


return M
