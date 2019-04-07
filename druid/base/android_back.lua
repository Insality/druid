local data = require("druid.data")

local M = {}
M.interest = {
	data.ON_INPUT
}


function M.init(self, callback, params)
	self.event = data.A_ANDR_BACK
	self.callback = callback
	self.params = params
end


--- input handler
-- @param action_id - input action id
-- @param action - input action
function M.on_input(self, action_id, action)
	if action[data.RELEASED] then
		self.callback(self.parent.parent, self.params)
	end
	return true
end


return M