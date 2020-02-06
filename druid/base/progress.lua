--- Basic progress bar component
-- @module druid.progress

local const = require("druid.const")
local helper = require("druid.helper")
local component = require("druid.component")

local M = component.create("progress", { const.ON_UPDATE })


--- Component init function
-- @function progress:init
-- @tparam table self Component instance
-- @tparam string|node node Progress bar fill node or node name
-- @tparam string key Progress bar direction (x or y)
-- @tparam number init_value Initial value of progress bar
function M.init(self, node, key, init_value)
	assert(key == const.SIDE.X or const.SIDE.Y, "Progress bar key should be 'x' or 'y'")

	self.prop = hash("scale."..key)
	self.key = key

	self.style = self:get_style()
	self.node = self:get_node(node)
	self.scale = gui.get_scale(self.node)
	self.size = gui.get_size(self.node)
	self.max_size = self.size[self.key]
	self.slice = gui.get_slice9(self.node)
	if key == const.SIDE.X then
		self.slice_size = self.slice.x + self.slice.z
	else
		self.slice_size = self.slice.y + self.slice.w
	end

	self:set_to(init_value or 1)
end


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


local function set_bar_to(self, set_to, is_silence)
	local prev_value = self.last_value
	self.last_value = set_to

	local total_width = set_to * self.max_size

	local scale = math.min(total_width / self.slice_size, 1)
	local size = math.max(total_width, self.slice_size)

	self.scale[self.key] = scale
	gui.set_scale(self.node, self.scale)
	self.size[self.key] = size
	gui.set_size(self.node, self.size)

	if not is_silence then
		check_steps(self, prev_value, set_to)
	end
end


--- Fill a progress bar and stop progress animation
-- @function progress:empty
-- @tparam table self Component instance
function M.fill(self)
	set_bar_to(self, 1, true)
end


--- Empty a progress bar
-- @function progress:empty
-- @tparam table self Component instance
function M.empty(self)
	set_bar_to(self, 0, true)
end


--- Instant fill progress bar to value
-- @function progress:set_to
-- @tparam table self Component instance
-- @tparam number to Progress bar value, from 0 to 1
function M.set_to(self, to)
	set_bar_to(self, to)
end


--- Return current progress bar value
-- @function progress:get
-- @tparam table self Component instance
function M.get(self)
	return self.last_value
end


--- Set points on progress bar to fire the callback
-- @function progress:set_steps
-- @tparam table self Component instance
-- @tparam table steps Array of progress bar values
-- @tparam function callback Callback on intersect step value
function M.set_steps(self, steps, callback)
	self.steps = steps
	self.step_callback = callback
end


--- Start animation of a progress bar
-- @function progress:to
-- @tparam table self Component instance
-- @tparam number to value between 0..1
-- @tparam[opt] function callback Callback on animation ends
function M.to(self, to, callback)
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


function M.update(self, dt)
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


return M
