---@class druid.system.settings
local M = {}

M.default_style = nil

---@param text_id string
---@param ... string Optional params for string.format
function M.get_text(text_id, ...)
	return "[Druid]: locales not inited"
end

function M.play_sound(sound_id)
end

return M
