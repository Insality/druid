local event = require("event.event")
local const = require("druid.const")
local component = require("druid.component")

---Component to handle back button. It handles Android back button and Backspace key.
---
---### Setup
---Create back handler component with druid: `druid:new_back_handler(callback)`
---
---### Notes
---- Key triggers in `input.binding` should be setup for correct working
---- It uses a key_back and key_backspace action ids
---@class druid.back_handler: druid.component
---@field on_back event Trigger on back handler action, fun(self, params)
---@field params any|nil Custom args to pass in the callback
local M = component.create("back_handler")


---The Back Handler constructor
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
