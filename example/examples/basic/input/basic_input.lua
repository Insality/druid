---@class examples.basic_input: druid.widget
---@field input druid.input
local M = {}

function M:init()
	self.input = self.druid:new_input("input/root", "input/text")

	self.input_2 = self.druid:new_input("input_2/root", "input_2/text") --[[@as druid.input]]

	-- you can set custom style for input and their components
	-- Check in the example, how long tap on bottom input will erase text
	self.input_2.style.IS_LONGTAP_ERASE = true
	self.input_2.button.style.AUTOHOLD_TRIGGER = 1.5
end


---@param output_log output_list
function M:on_example_created(output_log)
	self.input.on_input_select:subscribe(function()
		output_log:add_log_text("Input Selected")
	end)
	self.input_2.on_input_select:subscribe(function()
		output_log:add_log_text("Input 2 Selected")
	end)
	self.input.on_input_unselect:subscribe(function(_, text)
		output_log:add_log_text("Input Deselected. Text: " .. text)
	end)
	self.input_2.on_input_unselect:subscribe(function(_, text)
		output_log:add_log_text("Input Deselected. Text: " .. text)
	end)
end


return M
