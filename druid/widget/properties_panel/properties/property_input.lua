---@class widget.property_input: druid.widget
---@field root node
---@field container druid.container
---@field text_name druid.text
---@field button druid.button
---@field text_button druid.text
---@field druid druid_instance
local M = {}

function M:init()
	self.root = self:get_node("root")
	self.text_name = self.druid:new_text("text_name")
		:set_text_adjust("scale_then_trim_left", 0.3)

	self.selected = self:get_node("selected")
	gui.set_alpha(self.selected, 0)

	self.rich_input = self.druid:new_rich_input("rich_input")

	self.container = self.druid:new_container(self.root)
	self.container:add_container("text_name")
	self.container:add_container("E_Anchor")
end


function M:on_click()
	gui.set_alpha(self.selected, 1)
	gui.animate(self.selected, "color.w", 0, gui.EASING_INSINE, 0.16)
end


---@param text string
---@return property_input
function M:set_text_button(text)
	self.text_button:set_text(text)
	return self
end


return M
