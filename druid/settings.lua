--- Druid settings file
-- @module settings

local M = {}

-- TODO: to JSON?
M.is_debug = false
M.button = {
	IS_HOVER = true,
	IS_HOLD = true
}

M.progress = {
	SPEED = 5, -- progress bar fill rate, more faster
	MIN_DELTA = 0.005
}

M.progress_rich = {
	DELAY = 1, -- delay in seconds before main fill
}

M.scroll = {
	FRICT_HOLD = 0.8, -- mult. for inert, while touching
	FRICT = 0.93, -- mult for free inert
	INERT_THRESHOLD = 2, -- speed to stop inertion
	INERT_SPEED = 25, -- koef. of inert speed
	DEADZONE = 6, -- in px
	SOFT_ZONE_SIZE = 160, -- size of outside zone (back move)
	BACK_SPEED = 0.2, -- lerp speed
	ANIM_SPEED = 0.3, -- gui.animation speed to point
}

function M.get_text(name)
	-- override to get text for localized text
	return "[Druid]: locales not inited"
end


function M.play_sound(name)
	-- override to play sound with name
end


function M.log(...)
	if M.is_debug then
		print("[Druid]: ", ...)
	end
end


return M
