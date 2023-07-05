-- Copyright (c) 2023 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Component to block input in special zone defined by GUI node.
-- # Overview #
--
-- Blocker component необходим, чтобы блокировать пользовательский ввод в определенной зоне.
-- Зона задается размером ноды, на которой находится компонент. Blocker блокирует ввод только для тех
-- элементов, которые находятся перед ним in input stack (созданы до него).
--
-- # Tech Info #
--
-- Blocker consume input if `gui.pick_node` works on it.
--
-- # Notes #
--
-- • Blocker inheritance @{BaseComponent}, you can use all of its methods in addition to those described here.
-- @usage
-- local node = gui.get_node("blocker_node")
-- local blocker = self.druid:new_blocker(node)
-- @module Blocker
-- @within BaseComponent
-- @alias druid.blocker

---Trigger node
-- @tfield node node

---

local const = require("druid.const")
local component = require("druid.component")

local Blocker = component.create("blocker")


--- Component initialize function
-- @tparam Blocker self @{Blocker}
-- @tparam node node Gui node
-- @local
function Blocker.init(self, node)
	self.node = self:get_node(node)
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


--- Set enabled blocker component state
-- @tparam Blocker self @{Blocker}
-- @tparam bool state Enabled state
function Blocker.set_enabled(self, state)
	gui.set_enabled(self.node, state)
end


--- Return blocker enabled state
-- @tparam Blocker self @{Blocker}
-- @treturn bool True, if blocker is enabled
function Blocker.is_enabled(self)
	return gui.is_enabled(self.node)
end


return Blocker
