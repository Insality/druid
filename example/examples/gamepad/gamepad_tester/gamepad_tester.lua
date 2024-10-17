local component = require("druid.component")
local progress = require("druid.extended.progress")

---@class gamepad_tester: druid.base_component
---@field root node
---@field buttons druid.button
---@field buttons_system druid.button
---@field button_left_bump druid.button
---@field button_right_bump druid.button
---@field druid druid_instance
local M = component.create("gamepad_tester")

local STICK_DISTANCE = 50

---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.root = self:get_node("root")

	self.button_left = self.druid:new_button("button_left/button"):set_key_trigger("gamepad_lpad_left")
	self.button_right = self.druid:new_button("button_right/button"):set_key_trigger("gamepad_lpad_right")
	self.button_up = self.druid:new_button("button_up/button"):set_key_trigger("gamepad_lpad_up")
	self.button_down = self.druid:new_button("button_down/button"):set_key_trigger("gamepad_lpad_down")

	self.button_x = self.druid:new_button("button_x/button"):set_key_trigger("gamepad_rpad_left")
	self.button_b = self.druid:new_button("button_b/button"):set_key_trigger("gamepad_rpad_right")
	self.button_y = self.druid:new_button("button_y/button"):set_key_trigger("gamepad_rpad_up")
	self.button_a = self.druid:new_button("button_a/button"):set_key_trigger("gamepad_rpad_down")

	self.button_l1 = self.druid:new_button("button_l1/button"):set_key_trigger("gamepad_lshoulder")
	self.button_r1 = self.druid:new_button("button_r1/button"):set_key_trigger("gamepad_rshoulder")

	self.button_stick_left = self.druid:new_button("stick_left/root"):set_key_trigger("gamepad_lstick_click")
	self.button_stick_right = self.druid:new_button("stick_right/root"):set_key_trigger("gamepad_rstick_click")

	self.button_start = self.druid:new_button("button_start/button"):set_key_trigger("gamepad_start")
	self.button_back = self.druid:new_button("button_back/button"):set_key_trigger("gamepad_back")

	self.trigger_l2 = self.druid:new(progress, "button_l2/fill", "x", 0) --[[@as druid.progress]]
	self.trigger_r2 = self.druid:new(progress, "button_r2/fill", "x", 0) --[[@as druid.progress]]

	self.stick_left = self:get_node("stick_left/stick_root")
	self.stick_right = self:get_node("stick_right/stick_root")
end


function M:on_input(action_id, action)
	if action_id == hash("gamepad_ltrigger") then
		self.trigger_l2:set_to(action.value)
	end
	if action_id == hash("gamepad_rtrigger") then
		self.trigger_r2:set_to(action.value)
	end

	-- Left Stick
	if action_id == hash("gamepad_lstick_left") then
		gui.set(self.stick_left, "position.x", -action.value * STICK_DISTANCE)
	end
	if action_id == hash("gamepad_lstick_right") then
		gui.set(self.stick_left, "position.x", action.value * STICK_DISTANCE)
	end
	if action_id == hash("gamepad_lstick_up") then
		gui.set(self.stick_left, "position.y", action.value * STICK_DISTANCE)
	end
	if action_id == hash("gamepad_lstick_down") then
		gui.set(self.stick_left, "position.y", -action.value * STICK_DISTANCE)
	end

	-- Right Stick
	if action_id == hash("gamepad_rstick_left") then
		gui.set(self.stick_right, "position.x", -action.value * STICK_DISTANCE)
	end
	if action_id == hash("gamepad_rstick_right") then
		gui.set(self.stick_right, "position.x", action.value * STICK_DISTANCE)
	end
	if action_id == hash("gamepad_rstick_up") then
		gui.set(self.stick_right, "position.y", action.value * STICK_DISTANCE)
	end
	if action_id == hash("gamepad_rstick_down") then
		gui.set(self.stick_right, "position.y", -action.value * STICK_DISTANCE)
	end
end


return M
