--- Druid constants
-- @module constants

local M = {}

-- Actions
M.ACTION_TOUCH = hash("touch")
M.ACTION_TEXT = hash("text")
M.ACTION_BACKSPACE = hash("backspace")
M.ACTION_ENTER = hash("enter")
M.ACTION_BACK = hash("back")

M.RELEASED = "released"
M.PRESSED = "pressed"
M.STRING = "string"

--- Interests
M.ON_MESSAGE = hash("on_message")
M.ON_UPDATE = hash("on_update")

-- Input
M.ON_SWIPE = hash("on_swipe")
M.ON_INPUT = hash("on_input")

M.PIVOTS = {
	[gui.PIVOT_CENTER] = vmath.vector3(0),
	[gui.PIVOT_N] = vmath.vector3(0, 0.5, 0),
	[gui.PIVOT_NE] = vmath.vector3(0.5, 0.5, 0),
	[gui.PIVOT_E] = vmath.vector3(0.5, 0, 0),
	[gui.PIVOT_SE] = vmath.vector3(0.5, -0.5, 0),
	[gui.PIVOT_S] = vmath.vector3(0, -0.5, 0),
	[gui.PIVOT_SW] = vmath.vector3(-0.5, -0.5, 0),
	[gui.PIVOT_W] = vmath.vector3(-0.5, 0, 0),
	[gui.PIVOT_NW] = vmath.vector3(-0.5, -0.5, 0),
}

M.ui_input = {
	[M.ON_SWIPE] = true,
	[M.ON_INPUT] = true
}

-- UI messages
M.ON_CHANGE_LANGUAGE = hash("on_change_language")
M.ON_LAYOUT_CHANGED = hash("on_layout_changed")

M.SPECIFIC_UI_MESSAGES = {
	[M.ON_CHANGE_LANGUAGE] = "on_change_language",
	[M.ON_LAYOUT_CHANGED] = "on_layout_changed"
}

return M