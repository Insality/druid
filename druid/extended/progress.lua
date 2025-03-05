local event = require("event.event")
local const = require("druid.const")
local helper = require("druid.helper")
local component = require("druid.component")

---@class druid.progress.style
---@field SPEED number|nil Progress bas fill rate. More -> faster. Default: 5
---@field MIN_DELTA number|nil Minimum step to fill progress bar. Default: 0.005

---@class druid.progress: druid.component
---@field node node
---@field on_change event
---@field style druid.progress.style
---@field key string
---@field prop hash
local M = component.create("progress")


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
	local other_side = self.key == const.SIDE.X and const.SIDE.Y or const.SIDE.X
	self.last_value = set_to

	local total_width = set_to * self.max_size[self.key]

	local scale = 1
	if self.slice_size[self.key] > 0 then
		scale = math.min(total_width / self.slice_size[self.key], 1)
	end
	local size = math.max(total_width, self.slice_size[self.key])

	do -- Scale other side
		-- Decrease other side of progress bar to match the oppotize slice_size
		local minimal_size = self.size[other_side] - self.slice_size[other_side]
		local maximum_size = self.size[other_side]
		local scale_diff = (maximum_size - minimal_size) / maximum_size
		local other_scale = 1 - (scale_diff * (1 - scale))
		self.scale[other_side] = other_scale
	end

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


---@param node string|node Node name or GUI Node itself.
---@param key string Progress bar direction: const.SIDE.X or const.SIDE.Y
---@param init_value number|nil Initial value of progress bar. Default: 1
function M:init(node, key, init_value)
	assert(key == const.SIDE.X or const.SIDE.Y, "Progress bar key should be 'x' or 'y'")

	self.key = key
	self.prop = hash("scale." .. self.key)

	self._init_value = init_value or 1
	self.node = self:get_node(node)
	self.scale = gui.get_scale(self.node)
	self.size = gui.get_size(self.node)
	self.max_size = gui.get_size(self.node)
	self.slice = gui.get_slice9(self.node)
	self.last_value = self._init_value

	self.slice_size = vmath.vector3(
		self.slice.x + self.slice.z,
		self.slice.y + self.slice.w,
		0
	)

	self.on_change = event.create()

	self:set_to(self.last_value)
end


---@param style druid.progress.style
function M:on_style_change(style)
	self.style = {
		SPEED = style.SPEED or 5,
		MIN_DELTA = style.MIN_DELTA or 0.005,
	}
end


function M:on_layout_change()
	self:set_to(self.last_value)
end


function M:on_remove()
	gui.set_size(self.node, self.max_size)
end


---@param dt number Delta time
function M:update(dt)
	if self.target then
		local prev_value = self.last_value
		local step = math.abs(self.last_value - self.target) * (self.style.SPEED * dt)
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


---Fill a progress bar and stop progress animation
function M:fill()
	set_bar_to(self, 1, true)
end


---Empty a progress bar
function M:empty()
	set_bar_to(self, 0, true)
end


---Instant fill progress bar to value
---@param to number Progress bar value, from 0 to 1
function M:set_to(to)
	to = helper.clamp(to, 0, 1)
	set_bar_to(self, to)
end


---Return current progress bar value
function M:get()
	return self.last_value
end


---Set points on progress bar to fire the callback
---@param steps number[] Array of progress bar values
---@param callback function Callback on intersect step value
function M:set_steps(steps, callback)
	self.steps = steps
	self.step_callback = callback
end


---Start animation of a progress bar
---@param to number value between 0..1
---@param callback function|nil Callback on animation ends
function M:to(to, callback)
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


---Set progress bar max node size
---@param max_size vector3 The new node maximum (full) size
---@return druid.progress Progress
function M:set_max_size(max_size)
	self.max_size[self.key] = max_size[self.key]
	self:set_to(self.last_value)
	return self
end


return M
