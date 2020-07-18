local M = {}


local function add_node(self)
	local prefab = gui.get_node("grid_nodes_prefab")
	local cloned = gui.clone_tree(prefab)
	gui.set_enabled(cloned["grid_nodes_prefab"], true)
	local index = #self.grid_nodes + 1
	gui.set_text(cloned["grid_nodes_text"], index)

	local button = self.druid:new_button(cloned["grid_nodes_prefab"], function()
		print(index)
	end)
	table.insert(self.grid_node_buttons, button)

	self.grid_nodes:add(cloned["grid_nodes_prefab"])
end


local function clear_nodes(self)
	local nodes = self.grid_nodes.nodes
	for i = 1, #nodes do
		gui.delete_node(nodes[i])
	end

	for i = 1, #self.grid_node_buttons do
		self.druid:remove(self.grid_node_buttons[i])
	end
	self.grid_node_buttons = {}

	self.grid_nodes:clear()
end


local function remove_node(self)
	-- Remove is not implemented yet
end


function M.setup_page(self)
	self.grid_nodes = self.druid:new_grid("grid_nodes", "grid_nodes_prefab", 5)
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
