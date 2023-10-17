-- Copyright (c) 2021 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Druid slider component
--
-- <a href="https://insality.github.io/druid/druid/index.html?example=general_sliders" target="_blank"><b>Example Link</b></a>
-- @module Slider
-- @within BaseComponent
-- @alias druid.slider

--- On change value callback(self, value)
-- @tfield DruidEvent on_change_value @{DruidEvent}

--- Slider pin node
-- @tfield node node

--- Start pin node position
-- @tfield vector3 start_pos

--- Current pin node position
-- @tfield vector3 pos

--- Targer pin node position
-- @tfield vector3 target_pos

--- End pin node position
-- @tfield vector3 end_pos

--- Length between start and end position
-- @tfield number dist

--- Current drag state
-- @tfield boolean is_drag

--- Current slider value
-- @tfield number value

---


local Event = require("druid.event")
local helper = require("druid.helper")
local const = require("druid.const")
local component = require("druid.component")

local Slider = component.create("slider", const.PRIORITY_INPUT_HIGH)


local function on_change_value(self)
	self.on_change_value:trigger(self:get_context(), self.value)
end


local function set_position(self, value)
	value = helper.clamp(value, 0, 1)
	gui.set_position(self.node, self.start_pos + self.dist * value)
end


--- The @{Slider} constructor
-- @tparam Slider self @{Slider}
-- @tparam node node Gui pin node
-- @tparam vector3 end_pos The end position of slider
-- @tparam[opt] function callback On slider change callback
function Slider.init(self, node, end_pos, callback)
	self.node = self:get_node(node)

	self.start_pos = gui.get_position(self.node)
	self.pos = gui.get_position(self.node)
	self.target_pos = vmath.vector3(self.pos)
	self.end_pos = end_pos

	self.dist = self.end_pos - self.start_pos
	self.is_drag = false
	self.value = 0

	self.on_change_value = Event(callback)
	self:on_window_resized()

	assert(self.dist.x == 0 or self.dist.y == 0, "Slider for now can be only vertical or horizontal")
end


function Slider.on_layout_change(self)
	self:set(self.value)
end


function Slider.on_window_resized(self)
	local x_koef, y_koef = helper.get_screen_aspect_koef()
	self._x_koef = x_koef
	self._y_koef = y_koef
	self._scene_scale = helper.get_scene_scale(self.node)
end


function Slider.on_input(self, action_id, action)
	if action_id ~= const.ACTION_TOUCH then
		return false
	end

	if gui.pick_node(self.node, action.x, action.y) then
		if action.pressed then
			self.pos = gui.get_position(self.node)
			self._scene_scale = helper.get_scene_scale(self.node)
			self.is_drag = true
		end
	end

	if not self.is_drag and self._input_node and gui.pick_node(self._input_node, action.x, action.y) then
		if action.pressed and gui.screen_to_local then
			self._scene_scale = helper.get_scene_scale(self.node)
			self.pos = gui.screen_to_local(self.node, vmath.vector3(action.screen_x, action.screen_y, 0))
			self.pos.x = helper.clamp(self.pos.x / self._scene_scale.x, self.start_pos.x, self.end_pos.x)
			self.pos.y = helper.clamp(self.pos.y / self._scene_scale.y, self.start_pos.y, self.end_pos.y)

			gui.set_position(self.node, self.pos)
			self.is_drag = true
		end
	end

	if self.is_drag and not action.pressed then
		-- move
		self.pos.x = self.pos.x + action.dx * self._x_koef / self._scene_scale.x
		self.pos.y = self.pos.y + action.dy * self._y_koef / self._scene_scale.y

		local prev_x = self.target_pos.x
		local prev_y = self.target_pos.y

		self.target_pos.x = helper.clamp(self.pos.x, self.start_pos.x, self.end_pos.x)
		self.target_pos.y = helper.clamp(self.pos.y, self.start_pos.y, self.end_pos.y)

		if prev_x ~= self.target_pos.x or prev_y ~= self.target_pos.y then
			local prev_value = self.value

			if self.dist.x > 0 then
				self.value = (self.target_pos.x - self.start_pos.x) / self.dist.x
			end

			if self.dist.y > 0 then
				self.value = (self.target_pos.y - self.start_pos.y) / self.dist.y
			end

			if self.steps then
				local closest_dist = 1000
				local closest = nil
				for i = 1, #self.steps do
					local dist = math.abs(self.value - self.steps[i])
					if dist < closest_dist then
						closest = self.steps[i]
						closest_dist = dist
					end
				end
				if closest then
					self.value = closest
				end
			end

			if prev_value ~= self.value then
				on_change_value(self)
			end
		end

		set_position(self, self.value)
	end

	if action.released then
		self.is_drag = false
	end

	return self.is_drag
end


--- Set value for slider
-- @tparam Slider self @{Slider}
-- @tparam number value Value from 0 to 1
-- @tparam[opt] boolean is_silent Don't trigger event if true
function Slider.set(self, value, is_silent)
	value = helper.clamp(value, 0, 1)
	set_position(self, value)
	self.value = value
	if not is_silent then
		on_change_value(self)
	end
end


--- Set slider steps. Pin node will
-- apply closest step position
-- @tparam Slider self @{Slider}
-- @tparam number[] steps Array of steps
-- @usage slider:set_steps({0, 0.2, 0.6, 1})
-- @treturn Slider @{Slider}
function Slider.set_steps(self, steps)
	self.steps = steps
	return self
end


--- Set input zone for slider.
-- User can touch any place of node, pin instantly will
-- move at this position and node drag will start.
-- This function require the Defold version 1.3.0+
-- @tparam Slider self @{Slider}
-- @tparam node input_node
-- @treturn Slider @{Slider}
function Slider.set_input_node(self, input_node)
	self._input_node = self:get_node(input_node)
	return self
end


return Slider
