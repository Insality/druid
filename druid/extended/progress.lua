-- Copyright (c) 2021 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Basic progress bar component.
-- For correct progress bar init it should be in max size from gui
-- @module Progress
-- @within BaseComponent
-- @alias druid.progress

--- On progress bar change callback(self, new_value)
-- @tfield DruidEvent on_change @{DruidEvent}

--- Progress bar fill node
-- @tfield node node

--- The progress bar direction
-- @tfield string key

--- Current progress bar scale
-- @tfield vector3 scale

--- Current progress bar size
-- @tfield vector3 size

--- Maximum size of progress bar
-- @tfield number max_size

--- Progress bar slice9 settings
-- @tfield vector4 slice

---

local Event = require("druid.event")
local const = require("druid.const")
local helper = require("druid.helper")
local component = require("druid.component")

local Progress = component.create("progress")


local function check_steps(self, from, to, exactly)
	if not self.steps then
		return
	end

	for i = 1, #self.steps do
		local step = self.steps[i]
		local v1, v2 = from, to
		if v1 > v2 then
			v1, v2 = v2, v1
		end

		if v1 < step and step < v2 then
			self.step_callback(self:get_context(), step)
		end
		if exactly and exactly == step then
			self.step_callback(self:get_context(), step)
		end
	end
end


local function set_bar_to(self, set_to, is_silent)
	local prev_value = self.last_value
	self.last_value = set_to

	local total_width = set_to * self.max_size

	local scale = math.min(total_width / self.slice_size, 1)
	local size = math.max(total_width, self.slice_size)

	self.scale[self.key] = scale
	gui.set_scale(self.node, self.scale)
	self.size[self.key] = size
	gui.set_size(self.node, self.size)

	if not is_silent then
		check_steps(self, prev_value, set_to)
		if prev_value ~= self.last_value then
			self.on_change:trigger(self:get_context(), self.last_value)
		end
	end
end


--- Component style params.
-- You can override this component styles params in druid styles table
-- or create your own style
-- @table style
-- @tfield[opt=5] number SPEED Progress bas fill rate. More -> faster
-- @tfield[opt=0.005] number MIN_DELTA Minimum step to fill progress bar
function Progress.on_style_change(self, style)
	self.style = {}
	self.style.SPEED = style.SPEED or 5
	self.style.MIN_DELTA = style.MIN_DELTA or 0.005
end


--- Component init function
-- @tparam Progress self @{Progress}
-- @tparam string|node node Progress bar fill node or node name
-- @tparam string key Progress bar direction: const.SIDE.X or const.SIDE.Y
-- @tparam[opt=1] number init_value Initial value of progress bar
function Progress.init(self, node, key, init_value)
	assert(key == const.SIDE.X or const.SIDE.Y, "Progress bar key should be 'x' or 'y'")

	self.prop = hash("scale."..key)
	self.key = key

	self._init_value = init_value or 1
	self.node = self:get_node(node)
	self.scale = gui.get_scale(self.node)
	self.size = gui.get_size(self.node)
	self.max_size = self.size[self.key]
	self.slice = gui.get_slice9(self.node)
	self.last_value = self._init_value

	if key == const.SIDE.X then
		self.slice_size = self.slice.x + self.slice.z
	else
		self.slice_size = self.slice.y + self.slice.w
	end

	self.on_change = Event()

	self:set_to(self.last_value)
end


function Progress.on_layout_change(self)
	self:set_to(self.last_value)
end


function Progress.update(self, dt)
	if self.target then
		local prev_value = self.last_value
		local step = math.abs(self.last_value - self.target) * (self.style.SPEED*dt)
		step = math.max(step, self.style.MIN_DELTA)
		self:set_to(helper.step(self.last_value, self.target, step))

		if self.last_value == self.target then
			check_steps(self, prev_value, self.target, self.target)

			if self.target_callback then
				self.target_callback(self:get_context(), self.target)
			end

			self.target = nil
		end
	end
end


--- Fill a progress bar and stop progress animation
-- @tparam Progress self @{Progress}
function Progress.fill(self)
	set_bar_to(self, 1, true)
end


--- Empty a progress bar
-- @tparam Progress self @{Progress}
function Progress.empty(self)
	set_bar_to(self, 0, true)
end


--- Instant fill progress bar to value
-- @tparam Progress self @{Progress}
-- @tparam number to Progress bar value, from 0 to 1
function Progress.set_to(self, to)
	to = helper.clamp(to, 0, 1)
	set_bar_to(self, to)
end


--- Return current progress bar value
-- @tparam Progress self @{Progress}
function Progress.get(self)
	return self.last_value
end


--- Set points on progress bar to fire the callback
-- @tparam Progress self @{Progress}
-- @tparam number[] steps Array of progress bar values
-- @tparam function callback Callback on intersect step value
-- @usage progress:set_steps({0, 0.3, 0.6, 1}, function(self, step) end)
function Progress.set_steps(self, steps, callback)
	self.steps = steps
	self.step_callback = callback
end


--- Start animation of a progress bar
-- @tparam Progress self @{Progress}
-- @tparam number to value between 0..1
-- @tparam[opt] function callback Callback on animation ends
function Progress.to(self, to, callback)
	to = helper.clamp(to, 0, 1)
	-- cause of float error
	local value = helper.round(to, 5)
	if value ~= self.last_value then
		self.target = value
		self.target_callback = callback
	else
		if callback then
			callback(self:get_context(), to)
		end
	end
end


--- Set progress bar max node size
-- @tparam Progress self @{Progress}
-- @tparam vector3 max_size The new node maximum (full) size
-- @treturn Progress @{Progress}
function Progress.set_max_size(self, max_size)
	self.max_size = max_size[self.key]
	self:set_to(self.last_value)
	return self
end


return Progress
