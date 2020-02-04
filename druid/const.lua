--- Druid constants
-- @module const

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
M.TABLE = "table"
M.ZERO = "0"
M.ALL = "all"


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
	[gui.PIVOT_NW] = vmath.vector3(-0.5, 0.5, 0),
}


M.SIDE = {
	X = "x",
	Y = "y"
}


M.UI_INPUT = {
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


-- Basic druid components
M.COMPONENTS = {
	BUTTON = "button",
	BLOCKER = "blocker",
	BACK_HANDLER = "back_handler",
	TEXT = "text",
	LOCALE = "locale",
	TIMER = "timer",
	PROGRESS = "progress",
	GRID = "grid",
	SCROLL = "scroll",
	SLIDER = "slider",
	CHECKBOX = "checkbox",
	CHECKBOX_GROUP = "checkbox_group",
	RADIO_GROUP = "radio_group",
}


M.EMPTY_FUNCTION = function() end
M.EMPTY_STRING = ""
M.EMPTY_TABLE = {}


return M