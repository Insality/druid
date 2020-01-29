--- Component to handle back key (android, backspace)
-- @module base.back_handler

local const = require("druid.const")
local component = require("druid.system.component")

local M = component.new("back_handler", { const.ON_INPUT })


--- Component init function
-- @function back_handler:init
-- @tparam table self Component instance
-- @tparam callback callback On back button
-- @tparam[opt] params Callback argument
function M.init(self, callback, params)
	self.event = const.ACTION_BACK
	self.callback = callback
	self.params = params
end


--- Input handler for component
-- @function back_handler:on_input
-- @tparam string action_id on_input action id
-- @tparam table action on_input action
function M.on_input(self, action_id, action)
	if action[const.RELEASED] then
		self.callback(self:get_context(), self.params)
	end

	return true
end


return M