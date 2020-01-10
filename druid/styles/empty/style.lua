local M = {}


M.BUTTON = {
	BTN_SOUND = "click",
	BTN_SOUND_DISABLED = "click",
	DISABLED_COLOR = vmath.vector4(0, 0, 0, 1),
	ENABLED_COLOR = vmath.vector4(1),
	IS_HOVER = false,
}


M.SCROLL = {
	FRICT_HOLD = 0, -- mult. for inert, while touching
	FRICT = 0, -- mult for free inert
	INERT_THRESHOLD = 2, -- speed to stop inertion
	INERT_SPEED = 0, -- koef. of inert speed
	DEADZONE = 6, -- in px
	SOFT_ZONE_SIZE = 20, -- size of outside zone (back move)
	BACK_SPEED = 0, -- lerp speed
	ANIM_SPEED = 0, -- gui.animation speed to point
}


M.PROGRESS = {
	SPEED = 5, -- progress bar fill rate, more faster
	MIN_DELTA = 1
}


M.PROGRESS_RICH = {
	DELAY = 0, -- delay in seconds before main fill
}


M.CHECKBOX = {
	on_change_state = function(self, node, state)
		gui.set_enabled(node, state)
	end
}


return M
