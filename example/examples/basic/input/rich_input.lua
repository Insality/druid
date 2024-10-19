local component = require("druid.component")
local rich_input = require("druid.custom.rich_input.rich_input")

---@class rich_input: druid.base_component
---@field druid druid_instance
---@field rich_input druid.rich_input
local M = component.create("rich_input")

---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.rich_input = self.druid:new(rich_input, "rich_input") --[[@as druid.rich_input]]
	self.rich_input:set_placeholder("Enter text")

	self.rich_input_2 = self.druid:new(rich_input, "rich_input_2") --[[@as druid.rich_input]]
	self.rich_input_2:set_placeholder("Enter text")
end


return M
