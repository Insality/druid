local component = require("druid.component")

---@class basic_input: druid.base_component
---@field druid druid.instance
---@field input druid.input
local M = component.create("basic_input")


---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.input = self.druid:new_input("input/root", "input/text")

	self.input_2 = self.druid:new_input("input_2/root", "input_2/text") --[[@as druid.input]]

	-- you can set custom style for input and their components
	-- Check in the example, how long tap on bottom input will erase text
	self.input_2.style.IS_LONGTAP_ERASE = true
	self.input_2.button.style.AUTOHOLD_TRIGGER = 1.5
end


return M
