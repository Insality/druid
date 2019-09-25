--- Component to handle progress bars
-- @module base.progress

local data = require("druid.data")
local helper = require("druid.helper")
local settings = require("druid.settings")
local p_settings = settings.progress

local M = {}

M.interest = {
	data.ON_UPDATE,
}

local PROP_Y = "y"
local PROP_X = "x"


function M.init(self, name, key, init_value)
	if key ~= PROP_X and key ~= PROP_Y then
		settings.log("progress component: key must be 'x' or 'y'. Passed:", key)
		key = PROP_X
	end

	self.prop = hash("scale."..key)
	self.key = key

	self.node = helper.get_node(name)
	self.scale = gui.get_scale(self.node)
	self.size = gui.get_size(self.node)
	self.max_size = self.size[self.key]
	self.slice = gui.get_slice9(self.node)
	if key == PROP_X then
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
			self.step_callback(self.parent.parent, step)
		end
		if exactly and exactly == step then
			self.step_callback(self.parent.parent, step)
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
function M.fill(self)
	set_bar_to(self, 1, true)
end


--- To empty a progress bar
function M.empty(self)
	set_bar_to(self, 0, true)
end


--- Set fill a progress bar to value
-- @param to - value between 0..1
function M.set_to(self, to)
	set_bar_to(self, to)
end


function M.get(self)
	return self.last_value
end


function M.set_steps(self, steps, step_callback)
	self.steps = steps
	self.step_callback = step_callback
end


--- Start animation of a progress bar
-- @param to - value between 0..1
-- @param callback - callback when progress ended if need
function M.to(self, to, callback)
	to = helper.clamp(to, 0, 1)
	-- cause of float error
	local value = helper.round(to, 5)
	if value ~= self.last_value then
		self.target = value
		self.target_callback = callback
	else
		if callback then
			callback(self.parent.parent, to)
		end
	end
end


function M.update(self, dt)
	if self.target then
		local prev_value = self.last_value
		local step = math.abs(self.last_value - self.target) * (p_settings.SPEED*dt)
		step = math.max(step, p_settings.MIN_DELTA)
		self:set_to(helper.step(self.last_value, self.target, step))

		if self.last_value == self.target then
			check_steps(self, prev_value, self.target, self.target)

			if self.target_callback then
				self.target_callback(self.parent.parent, self.target)
			end

			self.target = nil
		end
	end
end


return M
