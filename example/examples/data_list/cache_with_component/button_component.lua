---@class examples.button_component: druid.widget
---@field root node
---@field text druid.text
---@field button druid.button
---@field data any
local M = {}


function M:init()
	self.root = self:get_node("root")

	self.button = self.druid:new_button(self.root)
	self.text = self.druid:new_text("text")

	self.data = nil
end


---@param data any
function M:set_data(data)
	self.data = data
end


function M:get_data()
	return self.data
end


return M
