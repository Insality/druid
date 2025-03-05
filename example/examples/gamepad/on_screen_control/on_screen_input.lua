local const = require("druid.const")
local event = require("event.event")
local helper = require("druid.helper")
local component = require("druid.component")

---@class on_screen_input: druid.component
---@field druid druid.instance
---@field on_action event @()
---@field on_movement event @(x: number, y: number, dt: number) X/Y values are in range -1..1
---@field on_movement_stop event @()
local M = component.create("on_screen_input")

local STICK_DISTANCE = 80

---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.button_action = self:get_node("on_screen_button")
	self.on_screen_control = self:get_node("on_screen_stick/root")

	self.stick_root = self:get_node("on_screen_stick/stick_root")
	self.stick_position = gui.get_position(self.stick_root)

	self.on_action = event.create()
	self.on_movement = event.create()
	self.on_movement_stop = event.create()

	self.is_multitouch = helper.is_multitouch_supported()
end


---@param action_id hash
---@param action action
function M:on_input(action_id, action)
	if self.is_multitouch then
		if action_id == const.ACTION_MULTITOUCH then
			for _, touch in ipairs(action.touch) do
				self:process_touch(touch)
			end
		end
	else
		if action_id == const.ACTION_TOUCH then
			self:process_touch(action)
		end
	end

	return false
end


---@param action action|touch
function M:process_touch(action)
	if action.pressed and gui.pick_node(self.button_action, action.x, action.y) then
		self.on_action:trigger()

		gui.animate(self.button_action, gui.PROP_SCALE, vmath.vector3(1.2), gui.EASING_OUTSINE, 0.1, 0, function()
			gui.animate(self.button_action, gui.PROP_SCALE, vmath.vector3(1), gui.EASING_INSINE, 0.2, 0.05)
		end)
	end

	if gui.pick_node(self.on_screen_control, action.x, action.y) then
		self._is_stick_drag = action.id or true
	end

	local is_the_same_touch_id = not action.id or action.id == self._is_stick_drag
	if self._is_stick_drag and is_the_same_touch_id then
		-- action.dx and action.dy are broken inside touches for some reason, manual calculations seems fine
		local dx = action.x - (self._prev_x or action.x)
		local dy = action.y - (self._prev_y or action.y)
		self._prev_x = action.x
		self._prev_y = action.y

		self.stick_position.x = self.stick_position.x + dx
		self.stick_position.y = self.stick_position.y + dy

		-- Limit to STICK_DISTANCE
		local length = vmath.length(self.stick_position)
		if length > STICK_DISTANCE then
			self.stick_position.x = self.stick_position.x / length * STICK_DISTANCE
			self.stick_position.y = self.stick_position.y / length * STICK_DISTANCE
		end

		gui.set_position(self.stick_root, self.stick_position)
	end

	if action.released and is_the_same_touch_id then
		self._is_stick_drag = false
		self.stick_position.x = 0
		self.stick_position.y = 0
		self._prev_x = nil
		self._prev_y = nil
		gui.animate(self.stick_root, gui.PROP_POSITION, self.stick_position, gui.EASING_OUTBACK, 0.3)
		self.on_movement_stop:trigger()
	end
end


function M:update(dt)
	if self.stick_position.x ~= 0 or self.stick_position.y ~= 0 then
		self.on_movement:trigger(self.stick_position.x / STICK_DISTANCE, self.stick_position.y / STICK_DISTANCE, dt)
	end
end


return M
