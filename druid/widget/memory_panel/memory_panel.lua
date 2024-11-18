local mini_graph = require("druid.widget.mini_graph.mini_graph")

---@class widget.memory_panel: druid.widget
---@field root node
local M = {}


function M:init()
	self.druid = self:get_druid()
	self.mini_graph = self.druid:new_widget(mini_graph, "mini_graph")

	--for index = 1, 32 do
	--	self.mini_graph:set_line_value(index, 0)
	--end

	timer.delay(0.1, true, function()
		self.mini_graph:push_line_value(math.random())
	end)
end


return M