---@class widget.container_anchors: druid.widget
local M = {}


function M:init()
	self.parent_container = self.druid:new_container("parent_container")
	self.parent_container:create_draggable_corners()

	self.parent_container:add_container("panel_left", "stretch_y")
	self.parent_container:add_container("panel_right", "stretch_y")
	self.parent_container:add_container("panel_bot", "stretch_x")

	self.container_content = self.parent_container:add_container("panel_content")
	self.container_content:add_container("anchor_ne")
	self.container_content:add_container("anchor_nw")
	self.container_content:add_container("anchor_se")
	self.container_content:add_container("anchor_sw")
	self.container_content:add_container("anchor_n")
	self.container_content:add_container("anchor_s")
	self.container_content:add_container("anchor_e")
	self.container_content:add_container("anchor_w")
	self.container_content:add_container("anchor_center")
end


return M
