local M = {}


local function init_grid(self)
	local prefab = gui.get_node("grid_prefab")

	local grid_scroll = self.druid:new_scroll("scroll_with_grid_size", "grid_content")
	local grid = self.druid:new_grid("grid_content", "grid_prefab", 20)

	for i = 1, 40 do
		local clone_prefab = gui.clone_tree(prefab)

		grid:add(clone_prefab["grid_prefab"])
		gui.set_text(clone_prefab["grid_prefab_text"], "Node " .. i)

		local button = self.druid:new_button(clone_prefab["grid_button"], function()
			local position = gui.get_position(clone_prefab["grid_prefab"])
			position.x = -position.x
			grid_scroll:scroll_to(position)
		end)
		button:set_click_zone(gui.get_node("scroll_with_grid_size"))
	end

	gui.set_enabled(prefab, false)

	grid_scroll:set_size(grid:get_size())

	local scroll_slider = self.druid:new_slider("grid_scroll_pin", vmath.vector3(300, 0, 0), function(_, value)
		-- grid_scroll:scroll_to_percent(vmath.vector3(value, 0, 0), true)
	end)

	grid_scroll.on_scroll:subscribe(function(_, point)
		scroll_slider:set(grid_scroll:get_percent().x, true)
	end)
end


function M.setup_page(self)
	self.druid:new_scroll("scroll_page", "scroll_page_content")
	self.druid:new_scroll("simple_scroll_input", "simple_scroll_content")

	-- scroll contain scrolls:
	-- parent first
	self.druid:new_scroll("children_scroll", "children_scroll_content")
	-- chilren next
	self.druid:new_scroll("children_scroll_1", "children_scroll_content_1")
	self.druid:new_scroll("children_scroll_2", "children_scroll_content_2")
	self.druid:new_scroll("children_scroll_3", "children_scroll_content_3")

	init_grid(self)
end


return M
