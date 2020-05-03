--- Component to block input on specify zone by node
-- @module druid.blocker

--- Component events
-- @table Events
-- @tfield druid_event on_click On release button callback
-- @tfield druid_event on_enable_change On enable/disable callback

--- Component fields
-- @table Fields
-- @tfield node node Trigger node

local Event = require("druid.event")
local const = require("druid.const")
local component = require("druid.component")

local M = component.create("blocker", { const.ON_INPUT })


--- Component init function
-- @function blocker:init
-- @tparam node node Gui node
function M.init(self, node)
	self.node = self:get_node(node)

	self.on_click = Event()
	self.on_enable_change = Event()
end


function M.on_input(self, action_id, action)
	if action_id ~= const.ACTION_TOUCH and action_id ~= const.ACTION_MULTITOUCH then
		return false
	end

	if not self:is_enabled(self.node) then
		return false
	end

	if gui.pick_node(self.node, action.x, action.y) then
		return true
	end

	return false
end


--- Set enabled blocker component state
-- @function blocker:set_enabled
-- @tparam bool state Enabled state
function M.set_enabled(self, state)
	gui.set_enabled(self.node, state)
end


--- Return blocked enabled state
-- @function blocker:is_enabled
-- @treturn bool True, if blocker is enabled
function M.is_enabled(self, state)
	return gui.is_enabled(self.node)
end


return M
