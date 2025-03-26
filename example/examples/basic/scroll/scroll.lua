local component = require("druid.component")

---@class examples.scroll: druid.widget
---@field root node
---@field scroll druid.scroll
local M = {}

function M:init()
	self.scroll = self.druid:new_scroll("scroll_view", "scroll_content")

	self.button_tutorial = self.druid:new_button("button_tutorial/root")
	self.button_stencil = self.druid:new_button("button_stencil/root")
end


return M
