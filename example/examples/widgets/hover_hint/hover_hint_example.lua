local hover_hint = require("example.examples.widgets.hover_hint.hover_hint")

local component = require("druid.component")

---@class hover_hint_example: druid.component
---@field druid druid_instance
local M = component.create("hover_hint_example")


---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)
	self.hover_hint = self.druid:new(hover_hint, "hover_hint")

	self.hover_hint:add_hover_hint(self:get_node("node_yellow"), "Yellow box", gui.PIVOT_N, gui.PIVOT_S)
	self.hover_hint:add_hover_hint(self:get_node("node_green"), "Green box", gui.PIVOT_S, gui.PIVOT_N)
	self.hover_hint:add_hover_hint(self:get_node("node_red"), "Red box", gui.PIVOT_E, gui.PIVOT_W)
	self.hover_hint:add_hover_hint(self:get_node("node_blue"), "And this is definitely a blue box", gui.PIVOT_W, gui.PIVOT_E)
end


return M
