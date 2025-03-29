local event = require("event.event")

-- Require checkbox component from checkbox example
local checkbox = require("example.examples.basic.checkbox.checkbox")

---@class examples.checkbox_group: druid.widget
---@field checkbox_1 examples.checkbox
---@field checkbox_2 examples.checkbox
---@field checkbox_3 examples.checkbox
local M = {}


function M:init()
	self.checkbox_1 = self.druid:new(checkbox, "checkbox_1")
	self.checkbox_2 = self.druid:new(checkbox, "checkbox_2")
	self.checkbox_3 = self.druid:new(checkbox, "checkbox_3")

	self.checkbox_1.on_state_changed:subscribe(self.on_checkbox_click, self)
	self.checkbox_2.on_state_changed:subscribe(self.on_checkbox_click, self)
	self.checkbox_3.on_state_changed:subscribe(self.on_checkbox_click, self)

	self.on_state_changed = event.create()
end


function M:on_checkbox_click()
	print("Checkbox 1: ", self.checkbox_1:get_state())
	print("Checkbox 2: ", self.checkbox_2:get_state())
	print("Checkbox 3: ", self.checkbox_3:get_state())

	self.on_state_changed:trigger(self.checkbox_1:get_state(), self.checkbox_2:get_state(), self.checkbox_3:get_state())
end


---@param output_log output_list
function M:on_example_created(output_log)
	self.on_state_changed:subscribe(function(state1, state2, state3)
		output_log:add_log_text("State: " .. tostring(state1) .. " " .. tostring(state2) .. " " .. tostring(state3))
	end)
end


return M
