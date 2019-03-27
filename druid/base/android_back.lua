local data = require("druid.data")

local M = {}

M.interest = {
	data.ON_INPUT
}


function M.init(instance, params)
	-- TODO: first arg store as node. Find way to escape this
	local callback = instance.node
	instance.event = data.A_ANDR_BACK
	instance.callback = callback
	instance.params = params
end


--- input handler
-- @param action_id - input action id
-- @param action - input action
function M.on_input(instance, action_id, action)
	if action[data.RELEASED] then
		instance.callback(instance.parent.parent, instance.params)
	end
	return true
end


return M
