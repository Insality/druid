local M = {}

local ADD_FOCUS = hash("acquire_input_focus")
local REMOVE_FOCUS = hash("release_input_focus")
local PATH_OBJ = "."


function M.focus()
	msg.post(PATH_OBJ, ADD_FOCUS)
end


function M.remove()
	msg.post(PATH_OBJ, REMOVE_FOCUS)
end


return M
