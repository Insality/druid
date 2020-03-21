--- Druid input text component.
-- Carry on user text input
-- @local unimplemented
-- @module druid.input

local component = require("druid.component")

local M = component.create("input")


function M.init(self, node, callback, click_node)
	self.style = self:get_style()
end


return M
