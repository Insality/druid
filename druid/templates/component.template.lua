---@class druid.widget.TEMPLATE: druid.widget
local M = {}


function M:init()
	self.root = self:get_node("root")
	self.button = self.druid:new_button("button", self.on_button, self)
end


function M:on_button()
	print("Root node", self.root)
end


return M