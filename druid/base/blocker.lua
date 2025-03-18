local const = require("druid.const")
local component = require("druid.component")

---@class druid.blocker: druid.component
---@field node node
---@field private _is_enabled boolean
local M = component.create("blocker")


---@param node node|string The node to use as a blocker
function M:init(node)
	self.node = self:get_node(node)
	self._is_enabled = gui.is_enabled(self.node, true)
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
