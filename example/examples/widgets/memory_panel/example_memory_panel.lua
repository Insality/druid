local memory_panel = require("druid.widget.memory_panel.memory_panel")

---@class widget.example_memory_panel: druid.widget
local M = {}


function M:init()
	self.memory_panel = self.druid:new_widget(memory_panel, "memory_panel")
end


return M