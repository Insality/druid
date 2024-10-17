local component = require("druid.component")
local container = require("example.components.container.container")

---@class multiline_text: druid.base_component
---@field root node
---@field druid druid_instance
local M = component.create("multiline_text")

---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.root = self:get_node("root")
	self.text = self.druid:new_text("text")

	-- This code is for adjustable text area with mouse
	self.container = self.druid:new(container, "text_area", nil, function(_, size)
		self.text:set_size(size)
	end) --[[@as druid.container]]

	self.container:create_draggable_corners()
end


return M
