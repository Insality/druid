---@class examples.basic_progress_bar_slice9: druid.widget
---@field progress druid.progress
local M = {}

function M:init()
	self.progress = self.druid:new_progress("progress_bar_fill", "x")
	self.text_value = self:get_node("progress_value")

	self:set_value(self.progress:get())
end


function M:set_value(value)
	gui.set_text(self.text_value, math.ceil(value * 100) .. "%")
	self.progress:set_to(value)
end


---@param properties_panel properties_panel
function M:properties_control(properties_panel)
	properties_panel:add_slider("ui_value", 1, function(value)
		self:set_value(value)
	end)
end


return M
