local event = require("event.event")

---@class examples.data_list_basic: druid.widget
---@field prefab node
---@field scroll druid.scroll
---@field grid druid.grid
---@field data_list druid.data_list
---@field on_item_click event
local M = {}


function M:init()
	self.prefab = self:get_node("prefab")
	gui.set_enabled(self.prefab, false)

	self.scroll = self.druid:new_scroll("view", "content")
	self.grid = self.druid:new_grid("content", self.prefab, 1)
	self.data_list = self.druid:new_data_list(self.scroll, self.grid, self.create_item_callback) --[[@as druid.data_list]]

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

	local root = nodes[self:get_template() .. "/prefab"]
	local text = nodes[self:get_template() .. "/text"]
	gui.set_enabled(root, true)
	gui.set_text(text, "Data Item " .. index)

	local button = self.druid:new_button(root, self.on_button_click, index)
	return root, button
end


function M:on_button_click(index)
	self.on_item_click:trigger(index)
end


return M
