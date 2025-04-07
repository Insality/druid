local component = require("druid.component")
local input = require("druid.extended.input")

---@class basic_input: druid.base_component
---@field druid druid_instance
---@field input druid.input
local M = component.create("basic_input")

local COLOR_SELECTED = vmath.vector3(1, 1, 1)
local COLOR_UNSELECTED = vmath.vector3(184/255, 189/255, 194/255)

---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.input = self.druid:new(input, "input/root", "input/text")
	self.input.on_input_select:subscribe(function()
		gui.set_color(self.input.text.node, COLOR_SELECTED)
	end)
	self.input.on_input_unselect:subscribe(function(_, text)
		print("User Enters Text: " .. text)
		gui.set_color(self.input.text.node, COLOR_UNSELECTED)
	end)

	self.input_2 = self.druid:new(input, "input_2/root", "input_2/text") --[[@as druid.input]]
	self.input_2:set_text("")
	self.input_2.on_input_select:subscribe(function()
		gui.set_color(self.input_2.text.node, COLOR_SELECTED)
	end)
	self.input_2.on_input_unselect:subscribe(function(_, text)
		print("User Enters Text: " .. text)
		gui.set_color(self.input_2.text.node, COLOR_UNSELECTED)
	end)

	-- you can set custom style for input and their components
	-- Check in the example, how long tap on bottom input will erase text
	self.input_2.style.IS_LONGTAP_ERASE = true
	self.input_2.button.style.AUTOHOLD_TRIGGER = 1.5
end


return M
