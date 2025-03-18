local event = require("event.event")
local const = require("druid.const")
local component = require("druid.component")

---The component that handles the back handler action, like backspace or android back button
---@class druid.back_handler: druid.component
---@field on_back event Trigger on back handler action, fun(self, params)
---@field params any|nil Custom args to pass in the callback
local M = component.create("back_handler")


---@param callback function|nil The callback to call when the back handler is triggered
---@param params any? Custom args to pass in the callback
function M:init(callback, params)
	self.params = params
	self.on_back = event.create(callback)
end


---@private
---@param action_id hash The action id
---@param action table The action table
---@return boolean is_consumed True if the input was consumed
function M:on_input(action_id, action)
	if action.released and (action_id == const.ACTION_BACK or action_id == const.ACTION_BACKSPACE) then
		self.on_back:trigger(self:get_context(), self.params)
		return true
	end

	return false
end


return M
