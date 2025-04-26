---@class examples.grid: druid.widget
---@field grid druid.grid
---@field text druid.text
local M = {}

function M:init()
	self.created_nodes = {}

	self.prefab = self:get_node("prefab")
	gui.set_enabled(self.prefab, false)

	self.grid = self.druid:new_grid("grid", "prefab", 3)

	for index = 1, 9 do
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
	gui.set_text(text, #self.created_nodes)
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
	local grid = self.grid

	local slider = properties_panel:add_slider("ui_grid_in_row", 0.3, function(value)
		local in_row_amount = math.ceil(value * 10)
		in_row_amount = math.max(1, in_row_amount)
		grid:set_in_row(in_row_amount)
	end)
	slider:set_text_function(function(value)
		return tostring(math.ceil(value * 10))
	end)

	properties_panel:add_button("ui_add_element", function()
		if #self.created_nodes >= 36 then
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

	properties_panel:add_checkbox("ui_dynamic_pos", grid.style.IS_DYNAMIC_NODE_POSES, function()
		grid.style.IS_DYNAMIC_NODE_POSES = not grid.style.IS_DYNAMIC_NODE_POSES
		grid:refresh()
	end)

	properties_panel:add_checkbox("ui_align_last_row", grid.style.IS_ALIGN_LAST_ROW, function()
		grid.style.IS_ALIGN_LAST_ROW = not grid.style.IS_ALIGN_LAST_ROW
		grid:refresh()
	end)

	local pivot_index = 1
	local pivot_list = {
		gui.PIVOT_CENTER,
		gui.PIVOT_W,
		gui.PIVOT_SW,
		gui.PIVOT_S,
		gui.PIVOT_SE,
		gui.PIVOT_E,
		gui.PIVOT_NE,
		gui.PIVOT_N,
		gui.PIVOT_NW,
	}

	properties_panel:add_button("ui_pivot_next", function()
		pivot_index = pivot_index + 1
		if pivot_index > #pivot_list then
			pivot_index = 1
		end
		grid:set_pivot(pivot_list[pivot_index])
	end)

	local slider_size = properties_panel:add_slider("ui_item_size", 0.5, function(value)
		local size = 50 + value * 100
		grid:set_item_size(size, size)
	end)
	slider_size:set_text_function(function(value)
		return tostring(50 + math.ceil(value * 100))
	end)
	slider_size:set_value(0.5)
end


---@return string
function M:get_debug_info()
	local info = ""

	info = info .. "Grid Items: " .. #self.grid.nodes .. "\n"
	info = info .. "Grid Item Size: " .. self.grid.node_size.x .. " x " .. self.grid.node_size.y .. "\n"
	info = info .. "Pivot: " .. tostring(self.grid.pivot)

	return info
end


return M
