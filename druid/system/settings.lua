--- Druid settings file
-- @module settings

local M = {}

M.is_debug = false
M.default_style = nil


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
