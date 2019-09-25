local M = {}


local function on_checkbox_click(self, index)
	if self.is_radio_mode then
		for i = 1, #self.checkboxes do
			self.checkboxes[i]:set_state(i == index, true)
		end
	end
end


function M.set_state(self, indexes)
	for i = 1, #indexes do
		if self.checkboxes[i] then
			self.checkboxes[i]:set_state(indexes[i], true)
		end
	end
end


function M.get_state(self)
	local result = {}

	for i = 1, #self.checkboxes do
		table.insert(result, self.checkboxes[i]:get_state())
	end

	return result
end


function M.init(self, nodes, callback, is_radio_mode, anim_nodes)
	self.is_radio_mode = is_radio_mode
	self.checkboxes = {}

	for i = 1, #nodes do
		local anim_node = anim_nodes and anim_nodes[i] or nil
		local checkbox = self.parent:new_checkbox(nodes[i], function()
			on_checkbox_click(self, i)
		end, anim_node)
		table.insert(self.checkboxes, checkbox)
	end
end


return M
