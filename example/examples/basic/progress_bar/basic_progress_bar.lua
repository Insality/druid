local component = require("druid.component")

---@class basic_progress_bar: druid.base_component
---@field druid druid.instance
---@field progress druid.progress
local M = component.create("basic_progress_bar")


---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.progress = self.druid:new_progress("progress_bar_fill", "x")
	self.text_value = self:get_node("progress_value")

	self:set_value(self.progress:get())
end


function M:set_value(value)
	gui.set_text(self.text_value, math.ceil(value * 100) .. "%")
	self.progress:set_to(value)
end


return M
