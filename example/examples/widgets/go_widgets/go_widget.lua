local panthera = require("panthera.panthera")

local animation = require("example.examples.widgets.go_widgets.go_widget_panthera")

---@class examples.widget.go_widget: druid.widget
local M = {}


function M:init()
	self.root = self:get_node("root")
	self.circle = self:get_node("circle")
	self.animation = panthera.create_gui(animation)
	self.counter = 0
	self.text_counter = self:get_node("text")
	gui.set_text(self.text_counter, 0)
end


function M:play_animation()
	panthera.play(self.animation, "default", {
		is_loop = true,
		callback = function()
			self.counter = self.counter + 1
			gui.set_text(self.text_counter, self.counter)
		end
	})
end


---@param position vector3 The position to set
function M:set_position(position)
	gui.set_position(self.root, position)
end

return M
