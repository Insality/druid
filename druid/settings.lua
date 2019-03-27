local M = {}


M.button = {
	IS_HOVER = true,
	IS_HOLD = true,
	BTN_SOUND = "click",
	BTN_SOUND_DISABLED = "button_click_disabled",
	HOVER_SCALE = vmath.vector3(-0.025, -0.025, 1),
	HOVER_TIME = 0.05,
	SCALE_CHANGE = vmath.vector3(-0.05, - 0.05, 1),
}



function M.get_text(name)
  -- override to get text for localized text
end


function M.play_sound(name)
  -- override to play sound with name
end


return M