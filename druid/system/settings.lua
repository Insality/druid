--- Druid settings file
-- @module settings
-- @local

local default_style = require("druid.styles.default.style")

local M = {}

M.default_style = default_style

function M.get_text(name)
	return "[Druid]: locales not inited"
end


function M.play_sound(name)
end


return M
