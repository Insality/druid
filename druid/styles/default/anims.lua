local M = {}


local function scale_to(self, node, to, callback, time, delay, easing)
	easing = easing or gui.EASING_INSINE
	time = time or M.SCALE_ANIMATION_TIME
	delay = delay or 0
	time = time or 0.10
	gui.animate(node, gui.PROP_SCALE, to, easing, time, delay,
		function()
			if callback then
				callback(self, node)
			end
		end
	)
end


function M.back_scale_animation(self, node, target_scale)
	scale_to(self, node, target_scale)
end


function M.tap_scale_animation(self, node, target_scale)
	scale_to(self, node, target_scale,
		function()
			M.back_scale_animation(self, node, self.start_scale)
		end
	)
end


function M.hover_scale(self, target, time)
	gui.animate(self.anim_node, "scale", target, gui.EASING_OUTSINE, time)
end


return M
