local event = require("event.event")


---@class widget.property_vector3: druid.widget
---@field root node
---@field container druid.container
---@field text_name druid.text
---@field button druid.button
---@field druid druid.instance
local M = {}

function M:init()
	self.root = self:get_node("root")
	self.text_name = self.druid:new_text("text_name")
		:set_text_adjust("scale_then_trim", 0.3)

	self.selected_x = self:get_node("selected_x")
	gui.set_alpha(self.selected_x, 0)

	self.selected_y = self:get_node("selected_y")
	gui.set_alpha(self.selected_y, 0)

	self.selected_z = self:get_node("selected_z")
	gui.set_alpha(self.selected_z, 0)

	self.rich_input_x = self.druid:new_rich_input("rich_input_x")
	self.rich_input_y = self.druid:new_rich_input("rich_input_y")
	self.rich_input_z = self.druid:new_rich_input("rich_input_z")

	self.value = vmath.vector3(0)

	self.rich_input_x.input.on_input_unselect:subscribe(function()
		self.value.x = tonumber(self.rich_input_x.input:get_text()) or 0
		self.on_change:trigger(self.value)
	end)

	self.rich_input_y.input.on_input_unselect:subscribe(function()
		self.value.y = tonumber(self.rich_input_y.input:get_text()) or 0
		self.on_change:trigger(self.value)
	end)

	self.rich_input_z.input.on_input_unselect:subscribe(function()
		self.value.z = tonumber(self.rich_input_z.input:get_text()) or 0
		self.on_change:trigger(self.value)
	end)

	self.container = self.druid:new_container(self.root)
	self.container:add_container("text_name")
	self.container:add_container("E_Anchor")

	self.on_change = event.create()
end


---@param text string
---@return widget.property_vector3
function M:set_text_property(text)
	self.text_name:set_text(text)
	return self
end


---@param x number
---@param y number
---@param z number
---@return widget.property_vector3
function M:set_value(x, y, z)
	self.rich_input_x:set_text(tostring(x))
	self.rich_input_y:set_text(tostring(y))
	self.rich_input_z:set_text(tostring(z))
	return self
end


return M
