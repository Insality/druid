local M = {}

M.is_debug = false

M.button = {
	IS_HOVER = true,
	IS_HOLD = true,
	BTN_SOUND = "click",
	BTN_SOUND_DISABLED = "click_disabled",
	HOVER_SCALE = vmath.vector3(-0.025, -0.025, 1),
	HOVER_TIME = 0.05,
	SCALE_CHANGE = vmath.vector3(-0.05, - 0.05, 1),
}



function M.get_text(name)
  -- override to get text for localized text
  return "locales not inited"
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