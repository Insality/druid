-- Copyright (c) 2021 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Druid constants
-- @local
-- @module DruidConst
-- @alias druid_const

local M = {}

M.ACTION_TEXT = hash(sys.get_config("druid.input_text", "text"))
M.ACTION_TOUCH = hash(sys.get_config("druid.input_touch", "touch"))
M.ACTION_MARKED_TEXT = hash(sys.get_config("druid.input_marked_text", "marked_text"))
M.ACTION_ESC = hash(sys.get_config("druid.input_key_esc", "key_esc"))
M.ACTION_BACK = hash(sys.get_config("druid.input_key_back", "key_back"))
M.ACTION_ENTER = hash(sys.get_config("druid.input_key_enter", "key_enter"))
M.ACTION_MULTITOUCH = hash(sys.get_config("druid.input_multitouch", "touch_multi"))
M.ACTION_BACKSPACE = hash(sys.get_config("druid.input_key_backspace", "key_backspace"))
M.ACTION_DEL = hash(sys.get_config("druid.input_key_del", "key_del"))
M.ACTION_SCROLL_UP = hash(sys.get_config("druid.input_scroll_up", "mouse_wheel_up"))
M.ACTION_SCROLL_DOWN = hash(sys.get_config("druid.input_scroll_down", "mouse_wheel_down"))
M.ACTION_LEFT = hash(sys.get_config("druid.input_key_left", "key_left"))
M.ACTION_RIGHT = hash(sys.get_config("druid.input_key_right", "key_right"))


M.IS_STENCIL_CHECK = not (sys.get_config("druid.no_stencil_check") == "1")

--- Component Interests
M.ON_INPUT = "on_input"
M.ON_UPDATE = "update"
M.ON_MESSAGE = "on_message"
M.ON_LATE_INIT = "on_late_init"
M.ON_FOCUS_LOST = "on_focus_lost"
M.ON_FOCUS_GAINED = "on_focus_gained"
M.ON_LAYOUT_CHANGE = "on_layout_change"
M.ON_MESSAGE_INPUT = "on_message_input"
M.ON_WINDOW_RESIZED = "on_window_resized"
M.ON_LANGUAGE_CHANGE = "on_language_change"

-- Components with higher priority value processed first
M.PRIORITY_INPUT = 10
M.PRIORITY_INPUT_HIGH = 20
M.PRIORITY_INPUT_MAX = 100

M.MESSAGE_INPUT = {
	BUTTON_CLICK = "button_click",
	BUTTON_LONG_CLICK = "button_long_click",
	BUTTON_DOUBLE_CLICK = "button_double_click",
	BUTTON_REPEATED_CLICK = "button_repeated_click",
	TEXT_SET = "text_set",
}

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

M.REVERSE_PIVOTS = {
	[gui.PIVOT_CENTER] = gui.PIVOT_CENTER,
	[gui.PIVOT_N] = gui.PIVOT_S,
	[gui.PIVOT_NE] = gui.PIVOT_SW,
	[gui.PIVOT_E] = gui.PIVOT_W,
	[gui.PIVOT_SE] = gui.PIVOT_NW,
	[gui.PIVOT_S] = gui.PIVOT_N,
	[gui.PIVOT_SW] = gui.PIVOT_NE,
	[gui.PIVOT_W] = gui.PIVOT_E,
	[gui.PIVOT_NW] = gui.PIVOT_SE,
}

M.LAYOUT_MODE = {
	STRETCH_X = "stretch_x",
	STRETCH_Y = "stretch_y",
	ZOOM_MIN = "zoom_min",
	ZOOM_MAX = "zoom_max",
	FIT = gui.ADJUST_FIT,
	STRETCH = gui.ADJUST_STRETCH,
}

M.VECTOR_ZERO = vmath.vector3(0)
M.SYS_INFO = sys.get_sys_info()
M.CURRENT_SYSTEM_NAME = M.SYS_INFO.system_name

M.OS = {
	ANDROID = "Android",
	IOS = "iPhone OS",
	MAC = "Darwin",
	LINUX = "Linux",
	WINDOWS = "Windows",
	BROWSER = "HTML5",
}

M.SHIFT = {
	NO_SHIFT = 0,
	LEFT = -1,
	RIGHT = 1,
}

M.TEXT_ADJUST = {
	DOWNSCALE = "downscale",
	TRIM = "trim",
	NO_ADJUST = "no_adjust",
	DOWNSCALE_LIMITED = "downscale_limited",
	SCROLL = "scroll",
	SCALE_THEN_SCROLL = "scale_then_scroll",
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

M.ERRORS = {
	GRID_DYNAMIC_ANCHOR = "The pivot of dynamic grid node should be West, East, South or North"
}

M.EMPTY_FUNCTION = function() end

return M
