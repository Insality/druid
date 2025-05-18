local event = require("event.event")

---@class druid.widget.property_checkbox: druid.widget
---@field root node
---@field druid druid.instance
---@field text_name druid.text
---@field button druid.button
---@field selected node
local M = {}


function M:init()
	self.root = self:get_node("root")

	self.icon = self:get_node("icon")
	gui.set_enabled(self.icon, false)

	self.selected = self:get_node("selected")
	gui.set_alpha(self.selected, 0)

	self.text_name = self.druid:new_text("text_name")
		:set_text_adjust("scale_then_trim", 0.3)

	self.button = self.druid:new_button("button", self.on_click)

	self.container = self.druid:new_container(self.root)
	self.container:add_container("text_name")
	self.container:add_container("E_Anchor")

	self.on_change_value = event.create()
end


---@param value boolean
function M:set_value(value, is_instant)
	if self._value == value then
		return
	end

	self._value = value
	gui.set_enabled(self.icon, value)
	self.on_change_value:trigger(value)

	if not is_instant then
		gui.set_alpha(self.selected, 1)
		gui.animate(self.selected, "color.w", 0, gui.EASING_INSINE, 0.16)
	end
end


---@return boolean
function M:get_value()
	return self._value
end


function M:on_click()
	self:set_value(not self:get_value())
end


---Set the text property of the checkbox
---@param text string
function M:set_text_property(text)
	self.text_name:set_text(text)
end


---Set the callback function for when the checkbox value changes
---@param callback function
function M:on_change(callback)
	self.on_change_value:subscribe(callback)
end


---Set the enabled state of the checkbox
---@param enabled boolean
function M:set_enabled(enabled)
	self.button:set_enabled(enabled)
end


return M
