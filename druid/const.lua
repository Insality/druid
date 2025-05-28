---@class druid.system.const
local M = {}

M.ACTION_TEXT = hash(sys.get_config_string("druid.input_text", "text"))
M.ACTION_TOUCH = hash(sys.get_config_string("druid.input_touch", "touch"))
M.ACTION_MARKED_TEXT = hash(sys.get_config_string("druid.input_marked_text", "marked_text"))
M.ACTION_ESC = hash(sys.get_config_string("druid.input_key_esc", "key_esc"))
M.ACTION_BACK = hash(sys.get_config_string("druid.input_key_back", "key_back"))
M.ACTION_ENTER = hash(sys.get_config_string("druid.input_key_enter", "key_enter"))
M.ACTION_MULTITOUCH = hash(sys.get_config_string("druid.input_multitouch", "touch_multi"))
M.ACTION_BACKSPACE = hash(sys.get_config_string("druid.input_key_backspace", "key_backspace"))
M.ACTION_SCROLL_UP = hash(sys.get_config_string("druid.input_scroll_up", "mouse_wheel_up"))
M.ACTION_SCROLL_DOWN = hash(sys.get_config_string("druid.input_scroll_down", "mouse_wheel_down"))
M.ACTION_LEFT = hash(sys.get_config_string("druid.input_key_left", "key_left"))
M.ACTION_RIGHT = hash(sys.get_config_string("druid.input_key_right", "key_right"))
M.ACTION_LSHIFT = hash(sys.get_config_string("druid.input_key_lshift", "key_lshift"))
M.ACTION_LCTRL = hash(sys.get_config_string("druid.input_key_lctrl", "key_lctrl"))
M.ACTION_LCMD = hash(sys.get_config_string("druid.input_key_lsuper", "key_lsuper"))

M.ON_INPUT = "on_input"
M.ON_UPDATE = "update"
M.ON_MESSAGE = "on_message"
M.ON_LATE_INIT = "on_late_init"
M.ON_FOCUS_LOST = "on_focus_lost"
M.ON_FOCUS_GAINED = "on_focus_gained"
M.ON_LAYOUT_CHANGE = "on_layout_change"
M.ON_WINDOW_RESIZED = "on_window_resized"
M.ON_LANGUAGE_CHANGE = "on_language_change"

M.ALL_INTERESTS = {
	M.ON_INPUT,
	M.ON_UPDATE,
	M.ON_MESSAGE,
	M.ON_LATE_INIT,
	M.ON_FOCUS_LOST,
	M.ON_FOCUS_GAINED,
	M.ON_LAYOUT_CHANGE,
	M.ON_WINDOW_RESIZED,
	M.ON_LANGUAGE_CHANGE,
}

M.MSG_LAYOUT_CHANGED = hash("layout_changed")

-- Components with higher priority value processed first
M.PRIORITY_INPUT = 10
M.PRIORITY_INPUT_HIGH = 20
M.PRIORITY_INPUT_MAX = 100

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
	FIT = "fit",
	STRETCH = "stretch",
}

M.CURRENT_SYSTEM_NAME = sys.get_sys_info().system_name

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
	NO_ADJUST = "no_adjust",
	DOWNSCALE_LIMITED = "downscale_limited",
	SCROLL = "scroll",
	TRIM = "trim",
	TRIM_LEFT = "trim_left",
	SCALE_THEN_TRIM = "scale_then_trim",
	SCALE_THEN_TRIM_LEFT = "scale_then_trim_left",
	SCALE_THEN_SCROLL = "scale_then_scroll",
}

M.SIDE = {
	X = "x",
	Y = "y"
}

return M
