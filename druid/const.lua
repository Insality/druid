--- Druid constants
-- @local
-- @module const

local M = {}

M.ACTION_TEXT = hash("text")
M.ACTION_MARKED_TEXT = hash("marked_text")

M.ACTION_BACKSPACE = hash("key_backspace")
M.ACTION_ENTER = hash("key_enter")
M.ACTION_BACK = hash("key_back")
M.ACTION_ESC = hash("key_esc")

M.ACTION_TOUCH = hash("touch")
M.ACTION_SCROLL_UP = hash("scroll_up")
M.ACTION_MULTITOUCH = hash("multitouch")
M.ACTION_SCROLL_DOWN = hash("scroll_down")


M.RELEASED = "released"
M.PRESSED = "pressed"
M.STRING = "string"
M.TABLE = "table"
M.ZERO = "0"
M.ALL = "all"


--- Component Interests
M.ON_INPUT = hash("on_input")
M.ON_UPDATE = hash("on_update")
M.ON_MESSAGE = hash("on_message")
M.ON_INPUT_HIGH = hash("on_input_high")
M.ON_FOCUS_LOST = hash("on_focus_lost")
M.ON_FOCUS_GAINED = hash("on_focus_gained")
M.ON_LAYOUT_CHANGE = hash("on_layout_change")
M.ON_LANGUAGE_CHANGE = hash("on_language_change")


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


M.SPECIFIC_UI_MESSAGES = {
	[M.ON_FOCUS_LOST] = "on_focus_lost",
	[M.ON_FOCUS_GAINED] = "on_focus_gained",
	[M.ON_LAYOUT_CHANGE] = "on_layout_change",
	[M.ON_LANGUAGE_CHANGE] = "on_language_change",
}


M.UI_INPUT = {
	[M.ON_INPUT_HIGH] = true,
	[M.ON_INPUT] = true
}


M.OS = {
	ANDROID = "Android",
	IOS = "iPhone OS",
	MAC = "Darwin",
	LINUX = "Linux",
	WINDOWS = "Windows",
	BROWSER = "HTML5",
}


M.SIDE = {
	X = "x",
	Y = "y"
}


M.SWIPE = {
	UP = "up",
	DOWN = "down",
	LEFT = "left",
	RIGHT = "right",
}


M.EMPTY_FUNCTION = function() end
M.EMPTY_STRING = ""
M.SPACE_STRING = " "
M.EMPTY_TABLE = {}


return M
