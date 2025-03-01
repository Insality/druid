local component = require("druid.component")

---@class basic_slider: druid.base_component
---@field druid druid.instance
---@field root node
---@field slider druid.slider
local M = component.create("basic_slider")


---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.slider = self.druid:new_slider("slider/slider_pin", vmath.vector3(118, 0, 0), self.on_slider_change) --[[@as druid.slider]]

	-- To add input across all slider widget add a root node to acquire additional input
	self.slider:set_input_node("slider/root")

	self.text_value = self:get_node("slider_value")
end


function M:on_slider_change(value)
	gui.set_text(self.text_value, math.ceil(value * 100) .. "%")
end


return M
