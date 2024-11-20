local event = require("druid.event")
local component = require("druid.component")
local data_list = require("druid.extended.data_list")

---@class data_list_add_remove_clear: druid.base_component
---@field druid druid_instance
---@field data_list druid.data_list
local M = component.create("data_list_add_remove_clear")


---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.prefab = self:get_node("prefab")
	gui.set_enabled(self.prefab, false)

	self.scroll = self.druid:new_scroll("view", "content")
	self.grid = self.druid:new_grid("content", self.prefab, 1)
	self.data_list = self.druid:new(data_list, self.scroll, self.grid, self.create_item_callback) --[[@as druid.data_list]]

	local data = {}
	for index = 1, 20 do
		table.insert(data, {})
	end
	self.data_list:set_data(data)

	self.on_item_click = event()
end


---@param item_data table
---@param index number
---@return node, druid.base_component
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


function M:add_item(index)
	self.data_list:add({}, index)
end


function M:remove_item(index)
	print("Want to remove item", index)
	self.data_list:remove(index)
end


function M:clear()
	self.data_list:clear()
end


return M
