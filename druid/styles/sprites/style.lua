local M = {}


M["button"] = {
	LONGTAP_TIME = 0.4,
	DOUBLETAP_TIME = 0.4,

	HOVER_MOUSE_IMAGE = "button_yellow",
	DEFAULT_IMAGE = "button_blue",
	HOVER_IMAGE = "button_red",

	on_hover = function(self, node, state)
		local anim = state and M.button.HOVER_IMAGE or M.button.DEFAULT_IMAGE
		gui.play_flipbook(node, anim)
	end,

	on_mouse_hover = function(self, node, state)
		local anim = state and M.button.HOVER_MOUSE_IMAGE or M.button.DEFAULT_IMAGE
		gui.play_flipbook(node, anim)
	end
}


return M
