--- Radio group module
-- @module druid.radio_group

local component = require("druid.system.component")

local M = component.create("radio_group")


local function on_checkbox_click(self, index)
	for i = 1, #self.checkboxes do
		self.checkboxes[i]:set_state(i == index, true)
	end

	if self.callback then
		self.callback(self:get_context(), index)
	end
end


function M.set_state(self, index)
	on_checkbox_click(self, index)
end


function M.get_state(self)
	local result = -1

	for i = 1, #self.checkboxes do
		if self.checkboxes[i]:get_state() then
			result = i
			break
		end
	end

	return result
end


function M.init(self, nodes, callback, click_nodes)
	self.druid = self:get_druid()
	self.checkboxes = {}
	self.callback = callback

	for i = 1, #nodes do
		local click_node = click_nodes and click_nodes[i] or nil
		local checkbox = self.druid:new_checkbox(nodes[i], function()
			on_checkbox_click(self, i)
		end, click_node)

		table.insert(self.checkboxes, checkbox)
	end
end


return M
