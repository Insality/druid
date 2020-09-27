local druid_const = require("druid.const")

local M = {}


local function remove_node(self, button, is_shift)
	gui.delete_node(button.node)

	self.druid:remove(button)
	local index = self.grid_nodes:get_index_by_node(button.node)
	self.grid_nodes:remove(index, is_shift)
	for i = 1, #self.grid_node_buttons do
		if self.grid_node_buttons[i] == button then
			table.remove(self.grid_node_buttons, i)
			self.grid_static_scroll:set_size(self.grid_nodes:get_size())
			break
		end
	end
end


local function add_node(self, index)
	local prefab = gui.get_node("grid_nodes_prefab")
	local cloned = gui.clone_tree(prefab)
	gui.set_enabled(cloned["grid_nodes_prefab"], true)

	local button = self.druid:new_button(cloned["grid_nodes_prefab"], function(_, params, button)
		remove_node(self, button, true)
	end)
	button.on_long_click:subscribe(function()
		remove_node(self, button)
	end)
	button:set_click_zone(self.grid_static_scroll.view_node)

	table.insert(self.grid_node_buttons, button)

	self.grid_nodes:add(cloned["grid_nodes_prefab"], index)

	self.grid_static_scroll:set_size(self.grid_nodes:get_size())
end


local function clear_nodes(self)
	local nodes = self.grid_nodes.nodes
	for i, node in pairs(nodes) do
		gui.delete_node(node)
	end

	for i = 1, #self.grid_node_buttons do
		self.druid:remove(self.grid_node_buttons[i])
	end
	self.grid_node_buttons = {}

	self.grid_nodes:clear()
end


local function init_static_grid(self)
	self.grid_nodes = self.druid:new_static_grid("grid_nodes", "grid_nodes_prefab", 5)
	self.grid_nodes:set_position_function(function(node, pos)
		gui.animate(node, "position", pos, gui.EASING_OUTSINE, 0.2)
	end)
	self.grid_node_buttons = {}
	gui.set_enabled(gui.get_node("grid_nodes_prefab"), false)

	for i = 1, 15 do
		add_node(self, i)
	end

	self.druid:new_button("button_add/button", add_node)
	self.druid:new_button("button_clear/button", clear_nodes)

	local remove_button = self.druid:new_button("button_remove/button", remove_node)
	gui.set_enabled(remove_button.node, false)
end


local function remove_dynamic_node(self, button)
	gui.delete_node(button.node)

	self.druid:remove(button)
	local index = self.dynamic_grid:get_index_by_node(button.node)
	self.dynamic_grid:remove(index)
	for i = 1, #self.dynamic_node_buttons do
		if self.dynamic_node_buttons[i] == button then
			table.remove(self.dynamic_node_buttons, i)
			self.grid_dynamic_scroll:set_size(self.dynamic_grid:get_size())
			self.grid_dynamic_scroll:set_scroll_offset(self.dynamic_grid:get_zero_offset())
			break
		end
	end
end


local function add_node_dynamic(self, index, is_shift_left)
	local node = gui.clone(self.prefab_dynamic)
	gui.set_enabled(node, true)
	gui.set_size(node, vmath.vector3(250, math.random(60, 150), 0))
	self.dynamic_grid:add(node, index, is_shift_left)

	local button = self.druid:new_button(node, function(_, params, button)
		remove_dynamic_node(self, button)
	end)
	button:set_click_zone(self.grid_dynamic_scroll.view_node)
	self.grid_dynamic_scroll:set_size(self.dynamic_grid:get_size())
	self.grid_dynamic_scroll:set_scroll_offset(self.dynamic_grid:get_zero_offset())
	table.insert(self.dynamic_node_buttons, button)
end


local function add_node_dynamic_hor(self, index)
	local node = gui.clone(self.prefab_hor_dynamic)
	gui.set_enabled(node, true)
	gui.set_size(node, vmath.vector3(80 + math.random(0, 80), 80, 0))
	self.dynamic_hor_grid:add(node, index)
	self.grid_dynamic_hor_scroll:set_size(self.dynamic_hor_grid:get_size())
	self.grid_dynamic_hor_scroll:set_scroll_offset(self.dynamic_hor_grid:get_zero_offset())
end


local function init_dynamic_grid(self)
	-- Vertical horizontal grid
	self.dynamic_node_buttons = {}
	self.dynamic_grid = self.druid:new_dynamic_grid("grid_dynamic_nodes")
	self.dynamic_grid:set_position_function(function(node, pos)
		gui.animate(node, gui.PROP_POSITION, pos, gui.EASING_OUTSINE, 0.2)
	end)

	self.prefab_dynamic = gui.get_node("grid_dynamic_prefab")
	gui.set_enabled(self.prefab_dynamic, false)

	for i = 1, 10 do
		add_node_dynamic(self, i)
	end
	self.druid:new_button("button_add_start_dynamic/button", function()
		local start_index = (self.dynamic_grid.first_index or 2) - 1
		add_node_dynamic(self, start_index)
	end)
	self.druid:new_button("button_add_end_dynamic/button", function()
		add_node_dynamic(self)
	end)


	-- Horizontal dynamic grid
	self.dynamic_hor_grid = self.druid:new_dynamic_grid("grid_dynamic_hor_nodes")
	self.dynamic_hor_grid:set_position_function(function(node, pos)
		gui.animate(node, gui.PROP_POSITION, pos, gui.EASING_OUTSINE, 0.2)
	end)
	self.prefab_hor_dynamic = gui.get_node("grid_dynamic_hor_prefab")
	gui.set_enabled(self.prefab_hor_dynamic, false)

	for i = 1, 10 do
		add_node_dynamic_hor(self, i)
	end

	self.druid:new_button("button_add_start_dynamic_hor/button", function()
		add_node_dynamic_hor(self, 1)
	end)
	self.druid:new_button("button_add_end_dynamic_hor/button", function()
		add_node_dynamic_hor(self)
	end)
end


function M.setup_page(self)
	self.grid_page_scroll = self.druid:new_scroll("grid_page", "grid_page_content")

	self.grid_static_scroll = self.druid:new_scroll("grid_nodes_view", "grid_nodes")
		:set_horizontal_scroll(false)
	self.grid_dynamic_scroll = self.druid:new_scroll("grid_dynamic_view", "grid_dynamic_nodes")
		:set_horizontal_scroll(false)
	self.grid_dynamic_hor_scroll = self.druid:new_scroll("grid_dynamic_hor_view", "grid_dynamic_hor_nodes")
		:set_vertical_scroll(false)

	init_static_grid(self)
	init_dynamic_grid(self)
end


return M
