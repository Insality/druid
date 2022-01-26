-- Copyright (c) 2021 Maxim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Component to block input on specify zone by node
-- @module Blocker
-- @within BaseComponent
-- @alias druid.blocker

---Trigger node
-- @tfield node node

---

local const = require("druid.const")
local component = require("druid.component")

local Blocker = component.create("blocker")


--- Component init function
-- @tparam Blocker self
-- @tparam node node Gui node
function Blocker.init(self, node)
	self.node = self:get_node(node)
end


function Blocker.on_input(self, action_id, action)
	if action_id ~= const.ACTION_TOUCH and
		action_id ~= const.ACTION_MULTITOUCH and
		action_id ~= nil then
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
-- @tparam Blocker self
-- @tparam bool state Enabled state
function Blocker.set_enabled(self, state)
	gui.set_enabled(self.node, state)
end


--- Return blocked enabled state
-- @tparam Blocker self
-- @treturn bool True, if blocker is enabled
function Blocker.is_enabled(self)
	return gui.is_enabled(self.node)
end


return Blocker
