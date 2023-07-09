-- Copyright (c) 2023 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Component to consume input in special zone defined by GUI node.
-- # Overview #
--
-- # Notes #
--
-- Blocker consume input if `gui.pick_node` works on it.
--
-- • Blocker inheritance @{BaseComponent}, you can use all of its methods in addition to those described here.
--
-- • Blocker initial enabled state is `gui.is_enabled(node, true)`
-- @usage
-- local node = gui.get_node("blocker_node")
-- local blocker = self.druid:new_blocker(node)
-- @module Blocker
-- @within BaseComponent
-- @alias druid.blocker

---Blocker node
-- @tfield node node

---

local const = require("druid.const")
local component = require("druid.component")

local Blocker = component.create("blocker")


--- @{Blocker} constructor
-- @tparam Blocker self @{Blocker}
-- @tparam node node Gui node
function Blocker.init(self, node)
	self.node = self:get_node(node)
	self._is_enabled = gui.is_enabled(node, true)
end


--- Component input handler
-- @tparam Blocker self @{Blocker}
-- @tparam string action_id on_input action id
-- @tparam table action on_input action
-- @local
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


--- Set enabled blocker component state.
--
-- Don't change node enabled state.
-- @tparam Blocker self @{Blocker}
-- @tparam bool state Enabled state
function Blocker.set_enabled(self, state)
	self._is_enabled = state
end


--- Return blocker enabled state
-- @tparam Blocker self @{Blocker}
-- @treturn bool True, if blocker is enabled
function Blocker.is_enabled(self)
	return self._is_enabled
end


return Blocker
