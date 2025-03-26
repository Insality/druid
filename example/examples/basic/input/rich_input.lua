---@class examples.rich_input: druid.widget
---@field rich_input druid.rich_input
---@field rich_input_2 druid.rich_input
local M = {}


function M:init()
	self.rich_input = self.druid:new_rich_input("rich_input") --[[@as druid.rich_input]]
	self.rich_input:set_placeholder("Enter text")

	self.rich_input_2 = self.druid:new_rich_input("rich_input_2") --[[@as druid.rich_input]]
	self.rich_input_2:set_placeholder("Enter text")
end


return M
