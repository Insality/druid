---@class druid.widget.property_input: druid.widget
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

	self.selected = self:get_node("selected")
	gui.set_alpha(self.selected, 0)

	self.rich_input = self.druid:new_rich_input("rich_input")

	self.container = self.druid:new_container(self.root)
	self.container:add_container("text_name")
	self.container:add_container("E_Anchor")
end


---@param text string
---@return druid.widget.property_input
function M:set_text_property(text)
	self.text_name:set_text(text)
	return self
end


---@param text string|number
---@return druid.widget.property_input
function M:set_text_value(text)
	self.rich_input:set_text(tostring(text))
	return self
end


---@param callback fun(self: druid.widget.property_input, text: string)
---@param callback_context any
function M:on_change(callback, callback_context)
	self.rich_input.input.on_input_unselect:subscribe(callback, callback_context)
end


return M
