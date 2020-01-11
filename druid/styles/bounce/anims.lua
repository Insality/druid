local ui_animate = require("druid.helper.druid_animate")


local M = {}


function M.back_scale_animation(self, node, target_scale)
	ui_animate.scale_to(self, node, target_scale)
end


function M.tap_scale_animation(self, node, target_scale)
	ui_animate.scale_to(self, node, target_scale,
		function()
			M.back_scale_animation(self, node, self.scale_from)
		end
	)
end


function M.hover_scale(self, target, time)
	ui_animate.scale(self, self.anim_node, target, time)
end


return M
