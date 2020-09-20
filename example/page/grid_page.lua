local M = {}


local function remove_node(self, button)
	gui.delete_node(button.node)

	self.druid:remove(button)
	local index = self.grid_nodes:get_index_by_node(button.node)
	self.grid_nodes:remove(index, true)
	for i = 1, #self.grid_node_buttons do
		if self.grid_node_buttons[i] == button then
			table.remove(self.grid_node_buttons, i)
			break
		end
	end
end


local function add_node(self)
	local prefab = gui.get_node("grid_nodes_prefab")
	local cloned = gui.clone_tree(prefab)
	gui.set_enabled(cloned["grid_nodes_prefab"], true)

	local button = self.druid:new_button(cloned["grid_nodes_prefab"], function(_, params, button)
		remove_node(self, button)
	end)
	table.insert(self.grid_node_buttons, button)

	self.grid_nodes:add(cloned["grid_nodes_prefab"])
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


function M.setup_page(self)
	self.grid_nodes = self.druid:new_static_grid("grid_nodes", "grid_nodes_prefab", 5)
	self.grid_nodes:set_position_function(function(node, pos)
		gui.animate(node, "position", pos, gui.EASING_OUTSINE, 0.2)
	end)
	self.grid_node_buttons = {}
	gui.set_enabled(gui.get_node("grid_nodes_prefab"), false)

	for i = 1, 15 do
		add_node(self)
	end

	self.druid:new_button("button_add/button", add_node)
	self.druid:new_button("button_clear/button", clear_nodes)

	local remove_button = self.druid:new_button("button_remove/button", remove_node)
	gui.set_enabled(remove_button.node, false)
end


return M
