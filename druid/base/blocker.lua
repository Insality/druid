--- Component to block input on specify zone (node)
-- @module druid.blocker

local const = require("druid.const")
local helper = require("druid.helper")
local component = require("druid.component")

local M = component.create("blocker", { const.ON_SWIPE })


function M.init(self, node)
	self.node = self:get_node(node)
end


function M.on_input(self, action_id, action)
	if action_id ~= const.ACTION_TOUCH then
		return false
	end

	if not helper.is_enabled(self.node) then
		return false
	end

	if gui.pick_node(self.node, action.x, action.y) then
		return true
	end

	return false
end


return M
