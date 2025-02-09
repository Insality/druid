local mock = require("deftest.mock.mock")

local M = {}

-- Userdata type instead of script self
---@return vector3|vector4
function M.get_context()
	return vmath.vector({})
end


-- Callback for return value from function
function M.get_function(callback)
	local listener = {}
	listener.callback = function(...) if callback then return callback(...) end end
	mock.mock(listener)
	return function(...) return listener.callback(...) end, listener.callback
end

return M
