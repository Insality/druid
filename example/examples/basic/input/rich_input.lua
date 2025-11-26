local rich_input = require("widget.rich_input.rich_input")

---@class examples.rich_input: druid.widget
---@field rich_input widget.rich_input
---@field rich_input_2 widget.rich_input
local M = {}


function M:init()
	self.rich_input = self.druid:new_widget(rich_input, "rich_input")
	self.rich_input:set_placeholder("Enter text")

	self.rich_input_2 = self.druid:new_widget(rich_input, "rich_input_2")
	self.rich_input_2:set_placeholder("Enter text")
end


---@param output_log output_list
function M:on_example_created(output_log)
	self.rich_input.input.on_input_unselect:subscribe(function(_, text)
		output_log:add_log_text("Input: " .. text)
	end)
	self.rich_input_2.input.on_input_unselect:subscribe(function(_, text)
		output_log:add_log_text("Input 2: " .. text)
	end)
end


return M
