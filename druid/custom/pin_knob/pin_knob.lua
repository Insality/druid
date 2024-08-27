-- Copyright (c) 2022 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Druid pin knob custom component.
-- It's simple rotating input element
-- @module PinKnob
-- @within BaseComponent
-- @alias druid.pin_knob

--- The component druid instance
-- @tfield DruidInstance druid @{DruidInstance}

--- Is currently under user control
-- @tfield boolean is_drag

--- The pin node
-- @tfield node node

---

local const = require("druid.const")
local component = require("druid.component")

local PinKnob = component.create("druid.pin_knob", { const.ON_INPUT })

local SCHEME = {
	ROOT = "root",
	PIN = "pin",
}


local function update_visual(self)
	local rotation = vmath.vector3(0, 0, self.angle)
	gui.set_euler(self.node, rotation)
end


local function set_angle(self, value)
	local prev_value = self.angle

	self.angle = value
	self.angle = math.min(self.angle, self.angle_max)
	self.angle = math.max(self.angle, self.angle_min)
	update_visual(self)

	if prev_value ~= self.angle and self.callback then
		local output_value = self.angle
		if output_value ~= 0 then
			output_value = -output_value
		end
		self.callback(self:get_context(), output_value)
	end
end


--- The @{PinKnob} constructor
-- @tparam PinKnob self @{PinKnob}
-- @tparam function callback Callback(self, value) on value changed
-- @tparam string template The template string name
-- @tparam table nodes Nodes table from gui.clone_tree
function PinKnob.init(self, callback, template, nodes)
	self:set_template(template)
	self:set_nodes(nodes)
	self.druid = self:get_druid()
	self.node = self:get_node(SCHEME.PIN)
	self.is_drag = false

	self.callback = callback
	self:set_angle(0, -100, 100)
	self._friction = 0.75
end


--- Set current and min/max angles for component
-- @tparam PinKnob self @{PinKnob}
-- @tparam number cur_value The new value for pin knob
-- @tparam number min The minimum value for pin knob
-- @tparam number max The maximum value for pin knob
-- @treturn PinKnob @{PinKnob}
function PinKnob.set_angle(self, cur_value, min, max)
	self.angle_min = min or self.angle_min
	self.angle_max = max or self.angle_max
	set_angle(self, cur_value)

	return self
end


--- Set current and min/max angles for component
-- @tparam PinKnob self @{PinKnob}
-- @tparam number|nil value The spin speed multiplier. Default: 1
-- @treturn PinKnob @{PinKnob}
function PinKnob.set_friction(self, value)
	self._friction = value or 1

	return self
end


function PinKnob.on_input(self, action_id, action)
	if action_id ~= const.ACTION_TOUCH then
		return false
	end

	if gui.pick_node(self.node, action.x, action.y) then
		if action.pressed then
			self.pos = gui.get_position(self.node)
			self.is_drag = true
		end
	end

	if self.is_drag and not action.pressed then
		set_angle(self, self.angle - action.dx * self._friction - action.dy * self._friction)
	end

	if action.released then
		self.is_drag = false
	end

	return self.is_drag
end


return PinKnob
