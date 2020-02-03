--- Component to block input on specify zone (node)
-- @module base.blocker

local const = require("druid.const")
local helper = require("druid.helper")
local component = require("druid.system.component")

local M = component.create("blocker", { const.ON_SWIPE })


function M.init(self, node)
	self.node = helper.get_node(node)
	self.event = const.ACTION_TOUCH
end


function M.on_input(self, action_id, action)
	if not helper.is_enabled(self.node) then
		return false
	end

	if gui.pick_node(self.node, action.x, action.y) then
		return true
	end

	return false
end


return M
