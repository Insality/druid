local component = require("druid.component")
local container = require("example.components.container.container")

---@class example_scene: druid.base_component
---@field root druid.container
---@field text_debug_info druid.text
---@field druid druid_instance
local M = component.create("example_scene")


---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.root = self.druid:new(container, "root") --[[@as druid.container]]
	self.root:add_container("text_debug_info")

	self.text_debug_info = self.druid:new_text("text_debug_info")
end


---@param info string
function M:set_debug_info(info)
	self.text_debug_info:set_to(info)
end


return M
