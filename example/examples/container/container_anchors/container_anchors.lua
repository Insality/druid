---@class widget.container_anchors: druid.widget
local M = {}


function M:init()
	self.parent_container = self.druid:new_container("parent_container")
	self.parent_container:create_draggable_corners()

	self.parent_container:add_container("anchor_ne")
	self.parent_container:add_container("anchor_nw")
	self.parent_container:add_container("anchor_se")
	self.parent_container:add_container("anchor_sw")
	self.parent_container:add_container("anchor_n")
	self.parent_container:add_container("anchor_s")
	self.parent_container:add_container("anchor_e")
	self.parent_container:add_container("anchor_w")
	self.parent_container:add_container("anchor_center")
end


return M
