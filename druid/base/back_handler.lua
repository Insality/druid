local event = require("druid.event")
local const = require("druid.const")
local component = require("druid.component")

---@class druid.back_handler: druid.base_component
---@field on_back druid.event Trigger on back handler action, fun(self, params)
---@field params any|nil Custom args to pass in the callback
local M = component.create("back_handler")


---@param callback function|nil
---@param params any|nil
function M:init(callback, params)
	self.params = params
	self.on_back = event.create(callback)
end


---@param action_id string
---@param action table
function M:on_input(action_id, action)
	if not action.released then
		return false
	end

	if action_id == const.ACTION_BACK or action_id == const.ACTION_BACKSPACE then
		self.on_back:trigger(self:get_context(), self.params)
		return true
	end

	return false
end


return M
