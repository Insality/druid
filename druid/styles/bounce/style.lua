local settings = require("druid.settings")
local anims = require("druid.styles.bounce.anims")
local const = require("druid.styles.bounce.const")

local M = {}


M.BUTTON = {
	on_hover = function(self, node, state)
		if self.hover_anim then
			local scale_to = self.scale_from + const.BUTTON.HOVER_SCALE

			local target_scale = state and scale_to or self.scale_from
			anims.hover_scale(self, target_scale, const.BUTTON.HOVER_TIME)
		end
	end,

	on_click = function(self, node)
		local scale_to = self.scale_from + const.BUTTON.SCALE_CHANGE
		anims.tap_scale_animation(self, node, scale_to)
		settings.play_sound(const.BUTTON.BTN_SOUND)
	end,

	on_click_disabled = function(self, node)
		settings.play_sound(const.BUTTON.BTN_SOUND_DISABLED)
	end,

	on_set_enabled = function(self, node, state)
		if state then
			gui.set_color(node, const.BUTTON.ENABLED_COLOR)
		else
			gui.set_color(node, const.BUTTON.DISABLED_COLOR)
		end
	end
}

return M
