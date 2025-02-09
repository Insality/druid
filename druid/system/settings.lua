---@class druid.system.settings
local M = {}

M.default_style = nil

---@param text_id string
---@vararg any
function M.get_text(text_id, ...)
	return "[Druid]: locales not inited"
end

function M.play_sound(sound_id)
end

return M
