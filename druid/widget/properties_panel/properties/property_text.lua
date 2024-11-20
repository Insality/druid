---@class widget.property_text: druid.widget
---@field root node
---@field container druid.container
---@field text_name druid.text
---@field text_right druid.text
local M = {}

function M:init()
	self.root = self:get_node("root")
	self.text_name = self.druid:new_text("text_name")
		:set_text_adjust("scale_when_trim_left", 0.3)

	self.text_right = self.druid:new_text("text_right", "")
		--:set_text_adjust("scale_when_trim_left", 0.3) -- TODO: not works? why?

	self.container = self.druid:new_container(self.root)
	self.container:add_container("text_name", nil, function(_, size)
		self.text_name:set_size(size)
	end)
	self.container:add_container("text_right", nil, function(_, size)
		self.text_right:set_size(size)
	end)
end


---@param text string
---@return widget.property_text
function M:set_text(text)
	self.text_name:set_text(text)
	return self
end


---@param text string|nil
---@return widget.property_text
function M:set_right_text(text)
	self.text_right:set_text(text or "")
	return self
end


return M
