local hover_hint = require("example.examples.widgets.hover_hint.hover_hint")

---@class examples.hover_hint_example: druid.widget
local M = {}

function M:init()
	self.hover_hint = self.druid:new_widget(hover_hint, "hover_hint")

	self.hover_hint:add_hover_hint(self:get_node("node_yellow"), "Yellow box", gui.PIVOT_N, gui.PIVOT_S)
	self.hover_hint:add_hover_hint(self:get_node("node_green"), "Green box", gui.PIVOT_S, gui.PIVOT_N)
	self.hover_hint:add_hover_hint(self:get_node("node_red"), "Red box", gui.PIVOT_E, gui.PIVOT_W)
	self.hover_hint:add_hover_hint(self:get_node("node_blue"), "And this is definitely a blue box", gui.PIVOT_W, gui.PIVOT_E)
end


return M
