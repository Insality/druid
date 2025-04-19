---@class examples.scroll_bind_grid_points: druid.widget
---@field scroll druid.scroll
---@field grid druid.grid
---@field text druid.text
local M = {}

function M:init()
	self.created_nodes = {}

	self.prefab = self:get_node("prefab")
	gui.set_enabled(self.prefab, false)

	self.scroll = self.druid:new_scroll("view", "content")
	self.grid = self.druid:new_grid("content", "prefab", 1)
	self.scroll:bind_grid(self.grid)

	for index = 1, 20 do
		self:add_element()
	end

	local points = self.grid:get_all_pos()
	for _, point in ipairs(points) do
		point.y = point.y + self.scroll.view_size.y/2
	end
	self.scroll:set_points(points)
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


---@param properties_panel properties_panel
function M:properties_control(properties_panel)
	local view_node = self.scroll.view_node
	local is_stencil = gui.get_clipping_mode(view_node) == gui.CLIPPING_MODE_STENCIL
	properties_panel:add_checkbox("ui_clipping", is_stencil, function(value)
		gui.set_clipping_mode(view_node, value and gui.CLIPPING_MODE_STENCIL or gui.CLIPPING_MODE_NONE)
	end)

	properties_panel:add_button("ui_add_element", function()
		if #self.created_nodes >= 100 then
			return
		end
		self:add_element()
	end)

	properties_panel:add_button("ui_remove_element", function()
		self:remove_element()
	end)

	properties_panel:add_button("ui_clear_elements", function()
		self:clear()
	end)
end


---@return string
function M:get_debug_info()
	local info = ""

	local s = self.scroll
	local view_node_size = gui.get(s.view_node, "size.y")
	local scroll_position = -s.position
	local scroll_bottom_position = vmath.vector3(scroll_position.x, scroll_position.y - view_node_size, scroll_position.z)

	info = info .. "View Size Y: " .. gui.get(s.view_node, "size.y") .. "\n"
	info = info .. "Content Size Y: " .. gui.get(s.content_node, "size.y") .. "\n"
	info = info .. "Content position Y: " .. math.ceil(s.position.y) .. "\n"
	info = info .. "Content Range Y: " .. s.available_pos.y .. " - " .. s.available_pos.w .. "\n"
	info = info .. "Grid Items: " .. #self.grid.nodes .. "\n"
	info = info .. "Grid Item Size: " .. self.grid.node_size.x .. " x " .. self.grid.node_size.y .. "\n"
	info = info .. "Top Scroll Pos Grid Index: " .. self.grid:get_index(scroll_position) .. "\n"
	info = info .. "Bottm Scroll Pos Grid Index: " .. self.grid:get_index(scroll_bottom_position) .. "\n"

	return info
end


return M
