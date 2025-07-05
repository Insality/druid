local const = require("druid.const")
local component = require("druid.component")

---Druid component for block input. Use it to block input in special zone.
---
---### Setup
---Create blocker component with druid: `druid:new_blocker(node_name)`
---
---### Notes
---- Blocker can be used to create safe zones, where you have big buttons
---- Blocker will capture all input events that hit the node, preventing them from reaching other components
---- Blocker works placed as usual component in stack, so any other component can be placed on top of it and will work as usual
---@class druid.blocker: druid.component
---@field node node The node that will block input
---@field private _is_enabled boolean Whether blocker is enabled
local M = component.create("blocker")


---The Blocker constructor
---@param node node|string The node to use as a blocker
function M:init(node)
	self.node = self:get_node(node)
	self._is_enabled = true
end


---@private
---@param action_id string The action id
---@param action table The action table
---@return boolean is_consumed True if the input was consumed
function M:on_input(action_id, action)
	if action_id ~= const.ACTION_TOUCH and
		action_id ~= const.ACTION_MULTITOUCH and
		action_id ~= nil then
		return false
	end

	if not self:is_enabled() then
		return false
	end

	if not gui.is_enabled(self.node, true) then
		return false
	end

	if gui.pick_node(self.node, action.x, action.y) then
		return true
	end

	return false
end


---Set blocker enabled state
---@param state boolean The new enabled state
---@return druid.blocker self The blocker instance
function M:set_enabled(state)
	self._is_enabled = state

	return self
end


---Get blocker enabled state
---@return boolean is_enabled True if the blocker is enabled
function M:is_enabled()
	return self._is_enabled
end


return M
