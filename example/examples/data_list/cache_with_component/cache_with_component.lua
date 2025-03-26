local event = require("event.event")

local button_component = require("example.examples.data_list.cache_with_component.button_component")

---@class examples.data_list_cache_with_component: druid.widget
---@field prefab node
---@field scroll druid.scroll
---@field grid druid.grid
---@field data_list druid.data_list
---@field on_item_click event
local M = {}


function M:init()
	self.prefab = self:get_node("button_component/root")
	gui.set_enabled(self.prefab, false)

	self.scroll = self.druid:new_scroll("view", "content")
	self.grid = self.druid:new_grid("content", self.prefab, 1)
	self.data_list = self.druid:new_data_list(self.scroll, self.grid, self.create_item_callback) --[[@as druid.data_list]]
	self.data_list:set_use_cache(true)
	self.data_list.on_element_add:subscribe(self.on_element_add)
	self.data_list.on_element_remove:subscribe(self.on_element_remove)

	local data = {}
	for index = 1, 1000 do
		table.insert(data, {})
	end
	self.data_list:set_data(data)

	self.on_item_click = event.create()
end


---@param item_data table
---@param index number
---@return node, druid.component
function M:create_item_callback(item_data, index)
	local nodes = gui.clone_tree(self.prefab)

	local instance = self.druid:new_widget(button_component, "button_component", nodes)
	gui.set_enabled(instance.root, true)

	return instance.root, instance
end


---@param index number
---@param node node
---@param instance examples.button_component
---@param data table
function M:on_element_add(index, node, instance, data)
	instance.text:set_text("Data Item " .. index)
	instance.button.on_click:subscribe(self.on_button_click, self)
	instance:set_data(index)
end


function M:on_element_remove(index, node, instance, data)
	instance.button.on_click:unsubscribe(self.on_button_click, self)
end


---@param instance examples.button_component
function M:on_button_click(instance)
	local data = instance:get_data()
	self.on_item_click:trigger(data)
end


return M
