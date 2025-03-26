local panthera = require("panthera.panthera")

local basic_animation_panthera = require("example.examples.panthera.basic_animation.basic_animation_panthera")

---@class examples.basic_animation: druid.widget
---@field animation panthera.instance
---@field button druid.button
local M = {}


function M:init()
	self.animation = panthera.create_gui(basic_animation_panthera, self:get_template(), self:get_nodes())

	self.button = self.druid:new_button("button/root", function()
		panthera.play(self.animation, "on_click", {
			is_skip_init = true
		})
	end)
	self.button:set_style(nil) -- Reset all button style animations

	self.button.hover.on_mouse_hover:subscribe(function(_, is_hover)
		if is_hover then
			panthera.play(self.animation, "on_hover")
		else
			panthera.play(self.animation, "reset", {
				is_skip_init = true
			})
		end
	end)
end


return M
