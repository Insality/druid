--- 
-- @module druid.scroll

--- Components fields
-- @table Fields

--- Component events
-- @table Events

--- Component style params
-- @table Style

local Event = require("druid.event")
local const = require("druid.const")
local helper = require("druid.helper")
local component = require("druid.component")

local M = component.create("scroll", { const.ON_UPDATE })


local function on_scroll_drag(self, dx, dy)
	dy = -dy
	local t = self.target_pos
	local b = self.available_soft_pos
	local soft = 100

	-- Handle soft zones
	-- Percent - multiplier for delta. Less if outside of scroll zone
	local x_perc = 1
	local y_perc = 1

	if t.x < b.x and dx < 0 then
		x_perc = (soft - (b.x - t.x)) / soft
	end
	if t.x > b.z and dx > 0 then
		x_perc = (soft - (t.x - b.z)) / soft
	end
	-- If disabled scroll by x
	if not self.can_x then
		x_perc = 0
	end

	if t.y > b.y and dy < 0 then
		y_perc = (soft - (t.y - b.y)) / soft
	end
	if t.y < b.w and dy > 0 then
		y_perc = (soft - (b.w - t.y)) / soft
	end
	-- If disabled scroll by y
	if not self.can_y then
		y_perc = 0
	end

	-- Reset inert if outside of scroll zone
	if x_perc ~= 1 then
		self.inertion.x = 0
	end
	if y_perc ~= 1 then
		self.inertion.y = 0
	end

	t.x = t.x + dx * x_perc
	t.y = t.y - dy * y_perc
end


local function set_pos(self, position)
	if self.current_pos.x ~= position.x or self.current_pos.y ~= position.y then
		self.current_pos.x = position.x
		self.current_pos.y = position.y
		gui.set_position(self.content_node, position)

		self.on_scroll:trigger(self:get_context(), self.current_pos)
	end
end


local function update_hand_scroll(self, dt)
	local dx = self.target_pos.x - self.current_pos.x
	local dy = self.target_pos.y - self.current_pos.y

	if helper.sign(dx) ~= helper.sign(self.inertion.x) then
		self.inertion.x = 0
	end
	if helper.sign(dy) ~= helper.sign(self.inertion.y) then
		self.inertion.y = 0
	end

	self.inertion.x = self.inertion.x + dx
	self.inertion.y = self.inertion.y + dy

	self.inertion.x = math.abs(self.inertion.x) * helper.sign(dx)
	self.inertion.y = math.abs(self.inertion.y) * helper.sign(dy)

	self.inertion.x = self.inertion.x * self.style.FRICT_HOLD
	self.inertion.y = self.inertion.y * self.style.FRICT_HOLD

	set_pos(self, self.target_pos)
end


local function check_soft_zone(self)
	local t = self.target_pos
	local b = self.available_soft_pos

	if t.y > b.y then
		t.y = helper.step(t.y, b.y, math.abs(t.y - b.y) * self.style.BACK_SPEED)
	end
	if t.x < b.x then
		t.x = helper.step(t.x, b.x, math.abs(t.x - b.x) * self.style.BACK_SPEED)
	end
	if t.y < b.w then
		t.y = helper.step(t.y, b.w, math.abs(t.y - b.w) * self.style.BACK_SPEED)
	end
	if t.x > b.z then
		t.x = helper.step(t.x, b.z, math.abs(t.x - b.z) * self.style.BACK_SPEED)
	end
end


local function check_threshold(self)
	if vmath.length(self.inertion) < self.style.INERT_THRESHOLD then
		self.inertion.x = 0
		self.inertion.y = 0
	end
end


local function update_free_scroll(self, dt)
	local target = self.target_pos

	-- Inertion apply
	target.x = self.current_pos.x + self.inertion.x * self.style.INERT_SPEED * dt
	target.y = self.current_pos.y + self.inertion.y * self.style.INERT_SPEED * dt

	-- Inertion friction
	self.inertion = self.inertion * self.style.FRICT

	check_threshold(self)
	check_soft_zone(self)
	set_pos(self, target)
end


local function on_touch_start(self)
	self.inertion.x = 0
	self.inertion.y = 0
	self.target_pos.x = self.current_pos.x
	self.target_pos.y = self.current_pos.y
end


local function update_size(self)
	self.view_size = helper.get_border(self.view_node)
	self.content_soft_size = helper.get_border(self.content_node)

	self.available_soft_pos = vmath.vector4(
		self.content_soft_size.x - self.view_size.x,
		self.content_soft_size.y - self.view_size.y,
		self.content_soft_size.z - self.view_size.z,
		self.content_soft_size.w - self.view_size.w
	)

	self.can_x = math.abs(self.available_soft_pos.x - self.available_soft_pos.z) > 0
	self.can_y = math.abs(self.available_soft_pos.y - self.available_soft_pos.w) > 0

	self.drag.can_x = self.can_x
	self.drag.can_y = self.can_y

	self.content_size = helper.get_border(self.content_node)

	if self.can_x then
		self.content_size.x = self.content_size.x + self.style.EXTRA_STRECH_SIZE.x
		self.content_size.z = self.content_size.z + self.style.EXTRA_STRECH_SIZE.z
	end

	if self.can_y then
		self.content_size.y = self.content_size.y + self.style.EXTRA_STRECH_SIZE.y
		self.content_size.w = self.content_size.w + self.style.EXTRA_STRECH_SIZE.w
	end

	self.available_pos = vmath.vector4(
		self.content_size.x - self.view_size.x,
		self.content_size.y - self.view_size.y,
		self.content_size.z - self.view_size.z,
		self.content_size.w - self.view_size.w
	)

	print("view", self.view_size)
	print("soft size", self.content_soft_size)
	print("content size", self.content_size)
	print(self.can_x, self.can_y)
	print("available pos", self.available_pos)
	print("current pos", self.current_pos)
end


--- Cancel animation on other animation or input touch
local function cancel_animate(self)
	if self.animate then
		self.target_pos = gui.get_position(self.content_node)
		self.current_pos.x = self.target_pos.x
		self.current_pos.y = self.target_pos.y
		gui.cancel_animation(self.content_node, gui.PROP_POSITION)
		self.animate = false
	end
end


--- Component init function
-- @function swipe:init
-- @tparam node node Gui node
-- @tparam function on_swipe_callback Swipe callback for on_swipe_end event
function M.init(self, view_zone, content_zone)
	self.druid = self:get_druid()
	self.style = self:get_style()

	self.view_node = self:get_node(view_zone)
	self.content_node = self:get_node(content_zone)


	self.current_pos = gui.get_position(self.content_node)
	self.target_pos = vmath.vector3(self.current_pos)
	self.inertion = vmath.vector3()

	self.drag = self.druid:new_drag(view_zone, on_scroll_drag)
	self.drag.on_touch_start:subscribe(on_touch_start)

	self.on_scroll = Event()
	self.on_scroll_to = Event()
	self.on_point_scroll = Event()

	update_size(self)
end


function M.set_size(self, size)
	gui.set_size(self.content_node, size)
	update_size(self)
end


function M.update(self, dt)
	if self.drag.is_drag then
		update_hand_scroll(self, dt)
	else
		update_free_scroll(self, dt)
	end
end


--- Start scroll to target point
-- @function scroll:scroll_to
-- @tparam point vector3 target point
-- @tparam[opt] bool is_instant instant scroll flag
-- @usage scroll:scroll_to(vmath.vector3(0, 50, 0))
-- @usage scroll:scroll_to(vmath.vector3(0), true)
function M.scroll_to(self, point, is_instant)
	local b = self.border
	local target = vmath.vector3(point)
	target.x = helper.clamp(point.x - self.center_offset.x, b.x, b.z)
	target.y = helper.clamp(point.y - self.center_offset.y, b.y, b.w)

	cancel_animate(self)

	self.animate = not is_instant

	if is_instant then
		self.target = target
		set_pos(self, target)
	else
		gui.animate(self.node, gui.PROP_POSITION, target, gui.EASING_OUTSINE, self.style.ANIM_SPEED, 0, function()
			self.animate = false
			self.target = target
			set_pos(self, target)
		end)
	end

	self.on_scroll_to:trigger(self:get_context(), target, is_instant)
end


function M.scroll_to_percent(self, percent, is_instant)
	local border = self.border

	local size_x = math.abs(border.z - border.x)
	if size_x == 0 then
		size_x = 1
	end
	local size_y = math.abs(border.w - border.y)
	if size_y == 0 then
		size_y = 1
	end

	local pos = vmath.vector3(
		-size_x * percent.x + border.x,
		-size_y * percent.y + border.y,
		0)
	M.scroll_to(self, pos, is_instant)
end


function M.get_percent(self)
	local y_dist = self.available_soft_pos.y - self.available_soft_pos.w
	local y_perc = y_dist ~= 0 and (self.current_pos.y - self.available_soft_pos.w) / y_dist or 1

	local x_dist = self.available_soft_pos.z - self.available_soft_pos.x
	local x_perc = x_dist ~= 0 and (self.current_pos.x - self.available_soft_pos.z) / x_dist or 1

	return vmath.vector3(x_perc, y_perc, 0)
end


return M
