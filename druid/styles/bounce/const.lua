local M = {}


M.BUTTON = {
	HOVER_SCALE = vmath.vector3(-0.025, -0.025, 1),
	HOVER_TIME = 0.05,
	SCALE_CHANGE = vmath.vector3(-0.05, - 0.05, 1),
	BTN_SOUND = "click",
	BTN_SOUND_DISABLED = "click",
	DISABLED_COLOR = vmath.vector4(0, 0, 0, 1),
	ENABLED_COLOR = vmath.vector4(1),
}

return M
