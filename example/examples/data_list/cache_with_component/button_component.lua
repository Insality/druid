local component = require("druid.component")

---@class button_component: druid.base_component
---@field root node
---@field druid druid.instance
---@field text druid.text
---@field data any
local M = component.create("button_component")


---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)
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
