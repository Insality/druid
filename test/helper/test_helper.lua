local mock = require("deftest.mock.mock")

local M = {}

-- Userdata type instead of script self
function M.get_context()
	return vmath.vector()
end


function M.get_function()
	local listener = {}
	listener.callback = function() end
	mock.mock(listener)
	return function(...) listener.callback(...) end, listener.callback
end

return M
