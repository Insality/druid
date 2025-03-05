local event = require("event.event")
local component = require("druid.component")

-- Require checkbox component from checkbox example
local checkbox = require("example.examples.basic.checkbox.checkbox")

---@class checkbox_group: druid.component
---@field druid druid.instance
---@field button druid.button
local M = component.create("checkbox_group")


---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

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


return M
