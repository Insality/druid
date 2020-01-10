local settings = require("druid.settings")
local anims = require("druid.styles.bounce.anims")

local M = {}


M.BUTTON = {
	HOVER_SCALE = vmath.vector3(-0.025, -0.025, 1),
	HOVER_TIME = 0.05,
	SCALE_CHANGE = vmath.vector3(-0.05, - 0.05, 1),
	BTN_SOUND = "click",
	BTN_SOUND_DISABLED = "click",
	DISABLED_COLOR = vmath.vector4(0, 0, 0, 1),
	ENABLED_COLOR = vmath.vector4(1),
	IS_HOVER = true,

	on_hover = function(self, node, state)
		if self.hover_anim then
			local scale_to = self.scale_from + M.BUTTON.HOVER_SCALE

			local target_scale = state and scale_to or self.scale_from
			anims.hover_scale(self, target_scale, M.BUTTON.HOVER_TIME)
		end
	end,

	on_click = function(self, node)
		local scale_to = self.scale_from + M.BUTTON.SCALE_CHANGE
		anims.tap_scale_animation(self, node, scale_to)
		settings.play_sound(M.BUTTON.BTN_SOUND)
	end,

	on_click_disabled = function(self, node)
		settings.play_sound(M.BUTTON.BTN_SOUND_DISABLED)
	end,

	on_set_enabled = function(self, node, state)
		if state then
			gui.set_color(node, M.BUTTON.ENABLED_COLOR)
		else
			gui.set_color(node, M.BUTTON.DISABLED_COLOR)
		end
	end
}


M.SCROLL = {
	FRICT_HOLD = 0.8, -- mult. for inert, while touching
	FRICT = 0.93, -- mult for free inert
	INERT_THRESHOLD = 2, -- speed to stop inertion
	INERT_SPEED = 25, -- koef. of inert speed
	DEADZONE = 6, -- in px
	SOFT_ZONE_SIZE = 160, -- size of outside zone (back move)
	BACK_SPEED = 0.2, -- lerp speed
	ANIM_SPEED = 0.3, -- gui.animation speed to point
}

M.PROGRESS = {
	SPEED = 5, -- progress bar fill rate, more faster
	MIN_DELTA = 0.005
}

M.PROGRESS_RICH = {
	DELAY = 1, -- delay in seconds before main fill
}

return M
