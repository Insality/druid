local component = require("druid.component")

---@class scroll_bind_grid_horizontal: druid.base_component
---@field scroll druid.scroll
---@field grid druid.static_grid
---@field text druid.text
---@field druid druid_instance
local M = component.create("scroll_bind_grid_horizontal")


---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.created_nodes = {}

	self.prefab = self:get_node("prefab")
	gui.set_enabled(self.prefab, false)

	self.scroll = self.druid:new_scroll("view", "content")
	self.grid = self.druid:new_static_grid("content", "prefab", 99999)
	self.scroll:bind_grid(self.grid)

	for index = 1, 30 do
		self:add_element()
	end
end


function M:on_remove()
	self:clear()
end


function M:add_element()
	local prefab_nodes = gui.clone_tree(self.prefab)
	local root = prefab_nodes[self:get_template() .. "/prefab"]
	local text = prefab_nodes[self:get_template() .. "/text"]
	table.insert(self.created_nodes, root)
	gui.set_text(text, "Grid Item " .. #self.created_nodes)
	gui.set_enabled(root, true)

	self.grid:add(root)
end


function M:remove_element()
	local last_node = table.remove(self.created_nodes)
	if last_node == nil then
		return
	end

	gui.delete_node(last_node)
	local grid_index = self.grid:get_index_by_node(last_node)
	self.grid:remove(grid_index)
end


function M:clear()
	for _, node in ipairs(self.created_nodes) do
		gui.delete_node(node)
	end
	self.created_nodes = {}
	self.grid:clear()
end


return M
