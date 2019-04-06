local helper = require("druid.helper")
local data = require("druid.data")
local settings = require("druid.settings").scroll

local M = {}

local SIDE_X = "x"
local SIDE_Y = "y"

M.interest = {
	data.ON_UPDATE,
	data.ON_SWIPE,
}

function M.set_border(self, border)
	self.border = border
	self.can_x = (border.x ~= border.z)
	self.can_y = (border.y ~= border.w)
end

function M.init(self, scroll_parent, input_zone, border)
	self.node = helper.get_node(scroll_parent)
	self.input_zone = helper.get_node(input_zone)
	self.zone_size = gui.get_size(self.input_zone)
	self:set_border(border)
	self.soft_size = settings.SOFT_ZONE_SIZE

	self.is_inert = true
	self.inert = vmath.vector3(0)
	self.pos = gui.get_position(self.node)
	self.target = vmath.vector3(self.pos)

	self.input = {
		touch = false,
		scroll = false,
		start_x = 0,
		start_y = 0,
		side = false,
	}
end


local function set_pos(self, pos)
	self.pos.x = pos.x
	self.pos.y = pos.y

	gui.set_position(self.node, self.pos)
end


local function check_soft_target(self)
	local t = self.target
	local b = self.border

	if t.y < b.y then
		t.y = helper.step(t.y, b.y, math.abs(t.y - b.y) * settings.BACK_SPEED)
	end
	if t.x < b.x then
		t.x = helper.step(t.x, b.x, math.abs(t.x - b.x) * settings.BACK_SPEED)
	end
	if t.y > b.w then
		t.y = helper.step(t.y, b.w, math.abs(t.y - b.w) * settings.BACK_SPEED)
	end
	if t.x > b.z then
		t.x = helper.step(t.x, b.z, math.abs(t.x - b.z) * settings.BACK_SPEED)
	end
end


local function update_hand_scroll(self, dt)
	local inert = self.inert
	local delta_x = self.target.x - self.pos.x
	local delta_y = self.target.y - self.pos.y

	if helper.sign(delta_x) ~= helper.sign(inert.x) then
		inert.x = 0
	end
	if helper.sign(delta_y) ~= helper.sign(inert.y) then
		inert.y = 0
	end

	inert.x = inert.x + delta_x
	inert.y = inert.y + delta_y

	inert.x = math.abs(inert.x) * helper.sign(delta_x)
	inert.y = math.abs(inert.y) * helper.sign(delta_y)

	inert.x = inert.x * settings.FRICT_HOLD
	inert.y = inert.y * settings.FRICT_HOLD

	set_pos(self, self.target)
end


local function get_zone_center(self)
	local pos = vmath.vector3(self.pos)
	pos.x = pos.x + self.zone_size.x/2
	pos.y = pos.y + self.zone_size.y/2
	return pos
end


local function check_points(self)
	if not self.points then
		return
	end

	local inert = self.inert
	if not self.is_inert then
		if math.abs(inert.x) > settings.DEADZONE then
			self:scroll_to_index(self.selected - helper.sign(inert.x))
			return
		end
		if math.abs(inert.y) > settings.DEADZONE then
			self:scroll_to_index(self.selected - helper.sign(inert.y))
			return
		end
	end

	local target = false
	local temp_dist = 99999
	local index = -1
	local pos = get_zone_center(self)
	for i = 1, #self.points do
		local p = self.points[i]
		local dist = helper.distance(pos.x, pos.y, p.x, p.y)
		local on_inert = true
		-- If inert ~= 0, scroll only by move direction
		if inert.x ~= 0 and helper.sign(inert.x) ~= helper.sign(p.x - pos.x) then
			on_inert = false
		end
		if inert.y ~= 0 and helper.sign(inert.y) ~= helper.sign(p.y - pos.y) then
			on_inert = false
		end
		if not target and on_inert then
			target = p
			index = i
			temp_dist = dist
		else
			if dist < temp_dist and on_inert then
				target = p
				index = i
				temp_dist = dist
			end
		end
	end
	self:scroll_to_index(index)
end


local function check_threshold(self)
	local inert = self.inert
	if math.abs(inert.x) + math.abs(inert.y) < settings.INERT_THRESHOLD or not self.is_inert then
		check_points(self)
		inert.x = 0
		inert.y = 0
	end
end


local function update_free_inert(self, dt)
	local inert = self.inert
	if inert.x ~= 0 or inert.y ~= 0 then
		self.target.x = self.pos.x + (inert.x * dt * settings.INERT_SPEED)
		self.target.y = self.pos.y + (inert.y * dt * settings.INERT_SPEED)

		inert.x = inert.x * settings.FRICT
		inert.y = inert.y * settings.FRICT

		-- stop, when low inert speed
		check_threshold(self)
	end

	check_soft_target(self)
	set_pos(self, self.target)
end


local function cancel_animate(self)
	if self.animate then
		self.target = gui.get_position(self.node)
		self.pos.x = self.target.x
		self.pos.y = self.target.y
		gui.cancel_animation(self.node, gui.PROP_POSITION)
		self.animate = false
	end
end


function M.update(self, dt)
	if self.input.touch then
		if self.input.scroll then
			update_hand_scroll(self, dt)
		else
			return false
		end
	else
		update_free_inert(self, dt)
	end
end


local function add_delta(self, dx, dy)
	local t = self.target
	local b = self.border
	local soft = self.soft_size
	-- TODO: Can we calc it more easier?

	-- soft zones
	local x_perc = 1
	if t.x < b.x and dx < 0 then
		x_perc = (soft - (b.x - t.x)) / soft
	end
	if t.x > b.z and dx > 0 then
		x_perc = (soft - (t.x - b.z)) / soft
	end
	-- if no scroll by x
	if not self.can_x then
		x_perc = 0
	end
	t.x = t.x + dx * x_perc

	local y_perc = 1
	if t.y < b.y and dy < 0 then
		y_perc = (soft - (b.y - t.y)) / soft
	end
	if t.y > b.w and dy > 0 then
		y_perc = (soft - (t.y - b.w)) / soft
	end
	-- if no scroll by y
	if not self.can_y then
		y_perc = 0
	end
	t.y = t.y + dy * y_perc

	if x_perc ~= 1 then
		self.inert.x = 0
	end
	if y_perc ~= 1 then
		self.inert.y = 0
	end
end


function M.on_input(self, action_id, action)
	if action_id ~= data.A_TOUCH then
		return false
	end
	local inp = self.input
	local inert = self.inert
	local result = false

	if gui.pick_node(self.input_zone, action.x, action.y) then
		if not inp.touch then
			cancel_animate(self)
			inp.touch = true
			inp.start_x = action.x
			inp.start_y = action.y
			inert.x = 0
			inert.y = 0
			self.target.x = self.pos.x
			self.target.y = self.pos.y
		else
			local dist = helper.distance(action.x, action.y, inp.start_x, inp.start_y)
			if not inp.scroll and dist >= settings.DEADZONE then
				inp.scroll = true
				local dx = math.abs(inp.start_x - action.x)
				local dy = math.abs(inp.start_y - action.y)
				if dx > dy then
					inp.side = SIDE_X
				else
					inp.side = SIDE_Y
				end
			end
			if inp.scroll then
				if self.can_x and inp.side == SIDE_X or
					self.can_y and inp.side == SIDE_Y then
					add_delta(self, action.dx, action.dy)
				else
					result = false
				end
			end
		end
	end

	if action.released then
		self.input.touch = false
		self.input.scroll = false
		self.input.side = false
		check_threshold(self)
	end

	return result
end


function M.scroll_to(self, point)
	local b = self.border
	local target = vmath.vector3(point)
	-- TODO: possibly calculace from anchor of node zone
	target.x = helper.clamp(point.x - self.zone_size.x/2, b.x, b.z)
	target.y = helper.clamp(point.y - self.zone_size.y/2, b.y, b.w)

	cancel_animate(self)

	self.animate = true
	gui.animate(self.node, gui.PROP_POSITION, target, gui.EASING_OUTSINE, 0.3, 0, function()
		self.animate = false
		self.target = target
	end)
end


function M.scroll_to_index(self, index, skip_cb)
	index = helper.clamp(index, 1, #self.points)
	self.selected = index
	-- TODO: Call two times from menu gui and from local check_points
	self:scroll_to(self.points[index])

	if not skip_cb and self.on_point_callback then
		self.on_point_callback(self.parent.parent, index, self.points[index])
	end
end


--- Set points of interest
function M.set_points(self, points)
	self.points = points
	self.selected = false
	for i = 1, #self.points do
		self.points[i].y = -self.points[i].y
	end
end


function M.set_inert(self, state)
	self.is_inert = state
end


function M.on_point_move(self, callback)
	self.on_point_callback = callback
end


return M