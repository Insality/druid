local M = {}


local function init_grid(self)
	local prefab = gui.get_node("grid_prefab")

	local grid = self.druid:new_grid("grid_content", "grid_prefab", 20)
	grid:set_anchor(vmath.vector3(0, 0.5, 0))

	for i = 1, 40 do
		local clone_prefab = gui.clone_tree(prefab)

		grid:add(clone_prefab["grid_prefab"])
		gui.set_text(clone_prefab["grid_prefab_text"], "Node " .. i)

		self.druid:new_button(clone_prefab["grid_button"])
	end

	gui.set_enabled(prefab, false)
	local grid_scroll = self.druid:new_scroll("grid_content", "scroll_with_grid_size")
	grid_scroll:set_border(grid:get_size())
end


function M.setup_page(self)
	self.druid:new_scroll("scroll_page_content", "scroll_page")
	self.druid:new_scroll("simple_scroll_content", "simple_scroll_input")
	init_grid(self)
end


return M
