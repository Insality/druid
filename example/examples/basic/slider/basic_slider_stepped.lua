local component = require("druid.component")
local slider = require("druid.extended.slider")

---@class basic_slider_stepped: druid.base_component
---@field druid druid_instance
---@field root node
---@field slider druid.slider
local M = component.create("basic_slider_stepped")


---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.slider = self.druid:new(slider, "slider/slider_pin", vmath.vector3(118, 0, 0), self.on_slider_change) --[[@as druid.slider]]

	-- To add input across all slider widget add a root node to acquire additional input
	self.slider:set_input_node("slider/root")

	self.slider:set_steps({0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1})

	self.text_value = self:get_node("slider_value")
end


function M:on_slider_change(value)
	gui.set_text(self.text_value, math.ceil(value * 100) .. "%")
end


return M
