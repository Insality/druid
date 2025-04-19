local on_screen_input = require("example.examples.gamepad.on_screen_control.on_screen_input")

---@class examples.on_screen_control: druid.widget
---@field on_screen_input examples.on_screen_input
---@field character node
---@field character_position vector3
---@field character_eye_left node
---@field character_eye_right node
local M = {}

local CHARACTER_SPEED = 700


function M:init()
	self.character = self:get_node("character")
	self.character_position = gui.get_position(self.character)

	self.character_eye_left = self:get_node("eye_left")
	self.character_eye_right = self:get_node("eye_right")

	self.on_screen_input = self.druid:new_widget(on_screen_input, "on_screen_input")

	self.on_screen_input.on_action:subscribe(self.on_action_button, self)
	self.on_screen_input.on_movement:subscribe(self.on_movement, self)
	self.on_screen_input.on_movement_stop:subscribe(self.on_movement_stop, self)
end


function M:on_action_button()
	gui.set_scale(self.character, vmath.vector3(1.5))
	gui.animate(self.character, gui.PROP_SCALE, vmath.vector3(1), gui.EASING_INSINE, 0.2)
end


function M:on_movement(x, y, dt)
	self.character_position.x = self.character_position.x + x * CHARACTER_SPEED * dt
	self.character_position.y = self.character_position.y + y * CHARACTER_SPEED * dt

	-- Clamp to -436, 436, area of the screen
	self.character_position.x = math.min(436, math.max(-436, self.character_position.x))
	self.character_position.y = math.min(436, math.max(-436, self.character_position.y))

	gui.set_position(self.character, self.character_position)

	-- Adjust angle of the eyes
	local angle = math.deg(math.atan2(y, x)) - 135
	gui.set(self.character_eye_left, "euler.z", angle)
	gui.set(self.character_eye_right, "euler.z", angle)
end


function M:on_movement_stop()
	gui.set(self.character_eye_left, "euler.z", 0)
	gui.set(self.character_eye_right, "euler.z", 0)
end


return M
