local color = require("druid.color")

---@class druid.widget.property_button: druid.widget
---@field root node
---@field container druid.container
---@field text_name druid.text
---@field button druid.button
---@field text_button druid.text
local M = {}


function M:init()
	self.root = self:get_node("root")
	self.text_name = self.druid:new_text("text_name")
		:set_text_adjust("scale_then_trim", 0.3)

	self.selected = self:get_node("selected")
	gui.set_alpha(self.selected, 0)

	self.button = self.druid:new_button("button", self.on_click)
	self.text_button = self.druid:new_text("text_button")

	self.container = self.druid:new_container(self.root)
	self.container:add_container("text_name", nil, function(_, size)
		self.text_button:set_size(size)
	end)
	self.container:add_container("E_Anchor")
end


function M:on_click()
	gui.set_alpha(self.selected, 1)
	gui.animate(self.selected, "color.w", 0, gui.EASING_INSINE, 0.16)
end


---@param text string
---@return druid.widget.property_button
function M:set_text_property(text)
	self.text_name:set_text(text)
	return self
end


---@param text string
---@return druid.widget.property_button
function M:set_text_button(text)
	self.text_button:set_text(text)
	return self
end


---@param enabled boolean
---@return druid.widget.property_button
function M:set_enabled(enabled)
	self.button:set_enabled(enabled)
	return self
end


function M:set_color(color_value)
	color.set_color(self:get_node("button"), color_value)
end


return M
