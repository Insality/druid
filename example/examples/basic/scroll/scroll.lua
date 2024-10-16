local component = require("druid.component")

---@class scroll: druid.base_component
---@field root node
---@field scroll druid.scroll
---@field druid druid_instance
local M = component.create("scroll")

---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.scroll = self.druid:new_scroll("scroll_view", "scroll_content")

	self.button_tutorial = self.druid:new_button("button_tutorial/root")
	self.button_stencil = self.druid:new_button("button_stencil/root")
end


return M
