local tiling_node = require("druid.widget.tiling_node.tiling_node")

---@class examples.example_tiling_node: druid.widget
local M = {}


function M:init()
	self.tiling_node = self.druid:new_widget(tiling_node, nil, nil, self:get_node("tiling_node"))
end


return M
