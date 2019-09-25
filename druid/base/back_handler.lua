--- Component to handle back key
-- @module base.back_handler

local data = require("druid.data")

local M = {}
M.interest = {
	data.ON_INPUT
}

--- Component init function
-- @tparam table self component instance
-- @tparam callback callback on back button
-- @tparam[opt] params callback argument
function M.init(self, callback, params)
	self.event = data.ACTION_BACK
	self.callback = callback
	self.params = params
end


--- Input handler for component
-- @tparam string action_id on_input action id
-- @tparam table action on_input action
function M.on_input(self, action_id, action)
	if action[data.RELEASED] then
		self.callback(self.parent.parent, self.params)
	end

	return true
end


return M