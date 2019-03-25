local M = {}

local ADD_FOCUS = hash("acquire_input_focus")
local REMOVE_FOCUS = hash("release_input_focus")
local PATH_OBJ = "."

M.A_CLICK = hash("click")
M.A_TEXT = hash("text")
M.A_BACKSPACE = hash("backspace")
M.A_ENTER = hash("enter")
M.A_ANDR_BACK = hash("back")

M.RELEASED = "released"
M.PRESSED = "pressed"

function M.focus()
  msg.post(PATH_OBJ, ADD_FOCUS)
end

function M.remove()
  msg.post(PATH_OBJ, REMOVE_FOCUS)
end

return M
