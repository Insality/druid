local helper = require("druid.helper")
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
		self:refresh_text_position()
	end) --[[@as druid.container]]

	self.container:create_draggable_corners()
end


function M:set_pivot(pivot)
	self.text:set_pivot(pivot)
	self:refresh_text_position()
end


function M:refresh_text_position()
	-- Need to update text position with different pivot
	local pivot = gui.get_pivot(self.text.node)
	local pivot_offset = helper.get_pivot_offset(pivot)
	gui.set_position(self.text.node, vmath.vector3(pivot_offset.x * self.text.start_size.x, pivot_offset.y * self.text.start_size.y, 0))
end


return M
