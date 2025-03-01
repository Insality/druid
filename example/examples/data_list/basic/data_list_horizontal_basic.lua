local component = require("druid.component")

---@class data_list_horizontal_basic: druid.base_component
---@field druid druid.instance
local M = component.create("data_list_horizontal_basic")


---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.prefab = self:get_node("prefab")
	gui.set_enabled(self.prefab, false)

	self.scroll = self.druid:new_scroll("view", "content")
	self.grid = self.druid:new_grid("content", self.prefab, 1000)
	self.data_list = self.druid:new_data_list(self.scroll, self.grid, self.create_item_callback) --[[@as druid.data_list]]

	local data = {}
	for index = 1, 100 do
		table.insert(data, {})
	end
	self.data_list:set_data(data)
end


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
	print("Button clicked", index)
end


return M
