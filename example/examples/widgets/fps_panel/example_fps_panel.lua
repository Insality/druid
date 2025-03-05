local fps_panel = require("druid.widget.fps_panel.fps_panel")

---@class widget.example_fps_panel: druid.widget
local M = {}


function M:init()
	self.fps_panel = self.druid:new_widget(fps_panel, "fps_panel")
end


return M
