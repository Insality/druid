local component = require("druid.component")
local event = require("druid.event")

-- Require checkbox component from checkbox example
local checkbox = require("example.examples.basic.checkbox.checkbox")

---@class radio_group: druid.base_component
---@field druid druid_instance
---@field button druid.button
local M = component.create("radio_group")


---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.state = {}
	self.checkboxes = {
		self.druid:new(checkbox, "checkbox_1"),
		self.druid:new(checkbox, "checkbox_2"),
		self.druid:new(checkbox, "checkbox_3")
	}

	for i = 1, #self.checkboxes do
 		self.checkboxes[i].on_state_changed:subscribe(self.on_checkbox_click, self)
		self.state[i] = false
	end

	self.checkboxes[1]:set_state(true)
	self.state[1] = true

	self.on_state_changed = event.create()
end


function M:on_checkbox_click()
	local new_clicked = nil
	for index = 1, #self.checkboxes do
		if self.checkboxes[index]:get_state() ~= self.state[index] then
			new_clicked = index
			break
		end
	end

	for index = 1, #self.state do
		self.checkboxes[index]:set_state(index == new_clicked)
		self.state[index] = index == new_clicked
	end

	self.on_state_changed:trigger(new_clicked)
end


return M
