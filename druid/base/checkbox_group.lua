--- Checkboux group module
-- @module druid.checkbox_group

local Event = require("druid.event")
local component = require("druid.component")

local M = component.create("checkbox_group")


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


function M.init(self, nodes, callback, click_nodes)
	self.druid = self:get_druid()
	self.checkboxes = {}

	self.on_checkbox_click = Event(callback)

	for i = 1, #nodes do
		local click_node = click_nodes and click_nodes[i] or nil
		local checkbox = self.druid:new_checkbox(nodes[i], function()
			self.on_checkbox_click:trigger(self:get_context(), i)
		end, click_node)

		table.insert(self.checkboxes, checkbox)
	end
end


return M
