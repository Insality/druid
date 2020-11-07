--- Component to handle scroll content.
-- Scroll consist from two nodes: scroll parent and scroll input
-- Scroll input the user input zone, it's static
-- Scroll parent the scroll moving part, it will change position.
-- Setup initial scroll size by changing scroll parent size. If scroll parent
-- size will be less than scroll_input size, no scroll is available. For scroll
-- parent size should be more than input size
-- @module Scroll
-- @within BaseComponent
-- @alias druid.scroll


--- On scroll move callback(self, position)
-- @tfield druid_event on_scroll

--- On scroll_to function callback(self, target, is_instant)
-- @tfield druid_event on_scroll_to

--- On scroll_to_index function callback(self, index, point)
-- @tfield druid_event on_point_scroll

--- Scroll view node
-- @tfield node view_node

--- Scroll content node
-- @tfield node content_node

--- Flag, if scroll now moving by inertion
-- @tfield bool is_inert

--- Current inert speed
-- @tfield vector3 inertion

--- Current scroll posisition
-- @tfield vector3 position

--- Current scroll target position
-- @tfield vector3 target_position

--- Available position for content node: (min_x, max_y, max_x, min_y)
-- @tfield vector4 available_pos

--- Size of available positions: (width, height, 0)
-- @tfield vector3 available_size

--- Drag Druid component
-- @tfield Drag drag

--- Current index of points of interests
-- @tfield[opt] number selected

--- Flag, if scroll now animating by gui.animate
-- @tfield bool is_animate


local Event = require("druid.event")
local const = require("druid.const")
local helper = require("druid.helper")
local component = require("druid.component")

local Scroll = component.create("scroll", { const.ON_UPDATE, const.ON_LAYOUT_CHANGE })


local function inverse_lerp(min, max, current)
	return helper.clamp((current - min) / (max - min), 0, 1)
end


--- Update vector with next conditions:
-- Field x have to <= field z
-- Field y have to <= field w
local function get_border_vector(vector, offset)
	if vector.x > vector.z then
		vector.x, vector.z = vector.z, vector.x
	end
	if vector.y > vector.w then
		vector.y, vector.w = vector.w, vector.y
	end
	vector.x = vector.x - offset.x
	vector.z = vector.z - offset.x
	vector.y = vector.y - offset.y
	vector.w = vector.w - offset.y
	return vector
end


--- Return size from scroll border vector4
local function get_size_vector(vector)
	return vmath.vector3(vector.z - vector.x, vector.w - vector.y, 0)
end


--- Component style params.
-- You can override this component styles params in druid styles table
-- or create your own style
-- @table style
-- @tfield[opt=0] number FRICT Multiplier for free inertion
-- @tfield[opt=0] number FRICT_HOLD Multiplier for inertion, while touching
-- @tfield[opt=3] number INERT_THRESHOLD Scroll speed to stop inertion
-- @tfield[opt=30] number INERT_SPEED Multiplier for inertion speed
-- @tfield[opt=20] number POINTS_DEADZONE Speed to check points of interests in no_inertion mode
-- @tfield[opt=0.35] number BACK_SPEED Scroll back returning lerp speed
-- @tfield[opt=0.2] number ANIM_SPEED Scroll gui.animation speed for scroll_to function
-- @tfield[opt=0] number EXTRA_STRETCH_SIZE extra size in pixels outside of scroll (stretch effect)
-- @tfield[opt=false] bool SMALL_CONTENT_SCROLL If true, content node with size less than view node size can be scrolled
function Scroll.on_style_change(self, style)
	self.style = {}
	self.style.EXTRA_STRETCH_SIZE = style.EXTRA_STRETCH_SIZE or 0
	self.style.ANIM_SPEED = style.ANIM_SPEED or 0.2
	self.style.BACK_SPEED = style.BACK_SPEED or 0.35

	self.style.FRICT = style.FRICT or 0
	self.style.FRICT_HOLD = style.FRICT_HOLD or 0

	self.style.INERT_THRESHOLD = style.INERT_THRESHOLD or 3
	self.style.INERT_SPEED = style.INERT_SPEED or 30
	self.style.POINTS_DEADZONE = style.POINTS_DEADZONE or 20
	self.style.SMALL_CONTENT_SCROLL = style.SMALL_CONTENT_SCROLL or false

	self._is_inert = not (self.style.FRICT == 0 or
		self.style.FRICT_HOLD == 0 or
		self.style.INERT_SPEED == 0)
end


--- Scroll constructor
-- @tparam Scroll self
-- @tparam node view_node GUI view scroll node
-- @tparam node content_node GUI content scroll node
function Scroll.init(self, view_node, content_node)
	self.druid = self:get_druid()

	self.view_node = self:get_node(view_node)
	self.content_node = self:get_node(content_node)

	self.position = gui.get_position(self.content_node)
	self.target_position = vmath.vector3(self.position)
	self.inertion = vmath.vector3(0)

	self.drag = self.druid:new_drag(view_node, self._on_scroll_drag)
	self.drag.on_touch_start:subscribe(self._on_touch_start)
	self.drag.on_touch_end:subscribe(self._on_touch_end)

	self.on_scroll = Event()
	self.on_scroll_to = Event()
	self.on_point_scroll = Event()

	self.selected = nil
	self.is_animate = false

	self._offset = vmath.vector3(0)
	self._is_horizontal_scroll = true
	self._is_vertical_scroll = true
	self._grid_on_change = nil
	self._grid_on_change_callback = nil

	self:_update_size()
end


function Scroll.on_layout_change(self)
	gui.set_position(self.content_node, self.position)
end


function Scroll.update(self, dt)
	if self.drag.is_drag then
		self:_update_hand_scroll(dt)
	else
		self:_update_free_scroll(dt)
	end
end


function Scroll.on_remove(self)
	self:bind_grid(nil)
end


--- Start scroll to target point.
-- @tparam Scroll self
-- @tparam vector3 point Target point
-- @tparam[opt] bool is_instant Instant scroll flag
-- @usage scroll:scroll_to(vmath.vector3(0, 50, 0))
-- @usage scroll:scroll_to(vmath.vector3(0), true)
function Scroll.scroll_to(self, point, is_instant)
	local b = self.available_pos
	local target = vmath.vector3(-point.x, -point.y, 0)
	target.x = helper.clamp(target.x, b.x, b.z)
	target.y = helper.clamp(target.y, b.y, b.w)

	self:_cancel_animate()

	self.is_animate = not is_instant

	if is_instant then
		self.target_position = target
		self:_set_scroll_position(target)
	else
		gui.animate(self.content_node, gui.PROP_POSITION, target, gui.EASING_OUTSINE, self.style.ANIM_SPEED, 0, function()
			self.is_animate = false
			self.target_position = target
			self:_set_scroll_position(target)
		end)
	end

	self.on_scroll_to:trigger(self:get_context(), target, is_instant)
end


--- Scroll to item in scroll by point index.
-- @tparam Scroll self
-- @tparam number index Point index
-- @tparam[opt] bool skip_cb If true, skip the point callback
function Scroll.scroll_to_index(self, index, skip_cb)
	if not self.points then
		return
	end

	index = helper.clamp(index, 1, #self.points)

	if self.selected ~= index then
		self.selected = index

		if not skip_cb then
			self.on_point_scroll:trigger(self:get_context(), index, self.points[index])
		end
	end

	self:scroll_to(self.points[index])
end


--- Start scroll to target scroll percent
-- @tparam Scroll self
-- @tparam vector3 percent target percent
-- @tparam[opt] bool is_instant instant scroll flag
-- @usage scroll:scroll_to_percent(vmath.vector3(0.5, 0, 0))
function Scroll.scroll_to_percent(self, percent, is_instant)
	local border = self.available_pos

	local pos = vmath.vector3(
		-helper.lerp(border.x, border.z, 1 - percent.x),
		-helper.lerp(border.w, border.y, 1 - percent.y),
		0
	)

	self:scroll_to(pos, is_instant)
end


--- Return current scroll progress status.
-- Values will be in [0..1] interval
-- @tparam Scroll self
-- @treturn vector3 New vector with scroll progress values
function Scroll.get_percent(self)
	local x_perc = 1 - inverse_lerp(self.available_pos.x, self.available_pos.z, self.position.x)
	local y_perc = inverse_lerp(self.available_pos.w, self.available_pos.y, self.position.y)

	return vmath.vector3(x_perc, y_perc, 0)
end


--- Set scroll content size.
-- It will change content gui node size
-- @tparam Scroll self
-- @tparam vector3 size The new size for content node
-- @treturn druid.scroll Current scroll instance
function Scroll.set_size(self, size, offset)
	if offset then
		self._offset = offset
	end
	gui.set_size(self.content_node, size)
	self:_update_size()

	return self
end


--- Enable or disable scroll inert.
-- If disabled, scroll through points (if exist)
-- If no points, just simple drag without inertion
-- @tparam Scroll self
-- @tparam bool state Inert scroll state
-- @treturn druid.scroll Current scroll instance
function Scroll.set_inert(self, state)
	self._is_inert = state

	return self
end


--- Return if scroll have inertion.
-- @tparam Scroll self
-- @treturn bool If scroll have inertion
function Scroll.is_inert(self)
	return self._is_inert
end


--- Set extra size for scroll stretching.
-- Set 0 to disable stretching effect
-- @tparam Scroll self
-- @tparam[opt=0] number stretch_size Size in pixels of additional scroll area
-- @treturn druid.scroll Current scroll instance
function Scroll.set_extra_stretch_size(self, stretch_size)
	self.style.EXTRA_STRETCH_SIZE = stretch_size or 0
	self:_update_size()

	return self
end


--- Return vector of scroll size with width and height.
-- @tparam Scroll self
-- @treturn vector3 Available scroll size
function Scroll.get_scroll_size(self)
	return self.available_size
end


--- Set points of interest.
-- Scroll will always centered on closer points
-- @tparam Scroll self
-- @tparam table points Array of vector3 points
-- @treturn druid.scroll Current scroll instance
function Scroll.set_points(self, points)
	self.points = points

	table.sort(self.points, function(a, b)
		return a.x > b.x or a.y < b.y
	end)

	self:_check_threshold()

	return self
end


--- Lock or unlock horizontal scroll
-- @tparam Scroll self
-- @tparam bool state True, if horizontal scroll is enabled
-- @treturn druid.scroll Current scroll instance
function Scroll.set_horizontal_scroll(self, state)
	self._is_horizontal_scroll = state
	self.drag.can_x = self.available_size.x > 0 and state
	return self
end


--- Lock or unlock vertical scroll
-- @tparam Scroll self
-- @tparam bool state True, if vertical scroll is enabled
-- @treturn druid.scroll Current scroll instance
function Scroll.set_vertical_scroll(self, state)
	self._is_vertical_scroll = state
	self.drag.can_y = self.available_size.y > 0 and state
	return self
end



--- Bind the grid component (Static or Dynamic) to recalculate
-- scroll size on grid changes
-- @tparam Scroll self
-- @tparam StaticGrid|DynamicGrid grid Druid grid component
-- @treturn druid.scroll Current scroll instance
function Scroll.bind_grid(self, grid)
	if self._grid_on_change then
		self._grid_on_change:unsubscribe(self._grid_on_change_callback)

		self._grid_on_change = nil
		self._grid_on_change_callback = nil
	end

	if not grid then
		return
	end

	self._grid_on_change = grid.on_change_items
	self._grid_on_change_callback = self._grid_on_change:subscribe(function()
		self:set_size(grid:get_size(), grid:get_offset())
	end)
	self:set_size(grid:get_size(), grid:get_offset())

	return self
end


function Scroll._on_scroll_drag(self, dx, dy)
	local t = self.target_position
	local b = self.available_pos
	local eb = self.available_pos_extra

	-- Handle soft zones
	-- Percent - multiplier for delta. Less if outside of scroll zone
	local x_perc = 1
	local y_perc = 1

	-- Right border (minimum x)
	if t.x < b.x and dx < 0 then
		x_perc = inverse_lerp(eb.x, b.x, t.x)
	end
	-- Left border (maximum x)
	if t.x > b.z and dx > 0 then
		x_perc = inverse_lerp(eb.z, b.z, t.x)
	end
	-- Disable x scroll
	if not self.drag.can_x then
		x_perc = 0
	end

	-- Top border (minimum y)
	if t.y < b.y and dy < 0 then
		y_perc = inverse_lerp(eb.y, b.y, t.y)
	end
	-- Bot border (maximum y)
	if t.y > b.w and dy > 0 then
		y_perc = inverse_lerp(eb.w, b.w, t.y)
	end
	-- Disable y scroll
	if not self.drag.can_y then
		y_perc = 0
	end

	t.x = t.x + dx * x_perc
	t.y = t.y + dy * y_perc
end


function Scroll._check_soft_zone(self)
	local target = self.target_position
	local border = self.available_pos
	local speed = self.style.BACK_SPEED

	-- Right border (minimum x)
	if target.x < border.x then
		local step = math.max(math.abs(target.x - border.x) * speed, 1)
		target.x = helper.step(target.x, border.x, step)
	end
	-- Left border (maximum x)
	if target.x > border.z then
		local step = math.max(math.abs(target.x - border.z) * speed, 1)
		target.x = helper.step(target.x, border.z, step)
	end
	-- Top border (maximum y)
	if target.y < border.y then
		local step = math.max(math.abs(target.y - border.y) * speed, 1)
		target.y = helper.step(target.y, border.y, step)
	end
	-- Bot border (minimum y)
	if target.y > border.w then
		local step = math.max(math.abs(target.y - border.w) * speed, 1)
		target.y = helper.step(target.y, border.w, step)
	end
end


--- Cancel animation on other animation or input touch
function Scroll._cancel_animate(self)
	if self.is_animate then
		self.target_position = gui.get_position(self.content_node)
		self.position.x = self.target_position.x
		self.position.y = self.target_position.y
		gui.cancel_animation(self.content_node, gui.PROP_POSITION)
		self.is_animate = false
	end
end


function Scroll._set_scroll_position(self, position)
	local available_extra = self.available_pos_extra
	position.x = helper.clamp(position.x, available_extra.x, available_extra.z)
	position.y = helper.clamp(position.y, available_extra.w, available_extra.y)

	if self.position.x ~= position.x or self.position.y ~= position.y then
		self.position.x = position.x
		self.position.y = position.y
		gui.set_position(self.content_node, position)

		self.on_scroll:trigger(self:get_context(), self.position)
	end
end


--- Find closer point of interest
-- if no inert, scroll to next point by scroll direction
-- if inert, find next point by scroll director
-- @local
function Scroll._check_points(self)
	if not self.points then
		return
	end

	local inert = self.inertion
	if not self._is_inert then
		if math.abs(inert.x) > self.style.POINTS_DEADZONE then
			self:scroll_to_index(self.selected - helper.sign(inert.x))
			return
		end
		if math.abs(inert.y) > self.style.POINTS_DEADZONE then
			self:scroll_to_index(self.selected + helper.sign(inert.y))
			return
		end
	end

	-- Find closest point and point by scroll direction
	-- Scroll to one of them (by scroll direction in priority)

	local temp_dist = math.huge
	local temp_dist_on_inert = math.huge
	local index = false
	local index_on_inert = false
	local pos = self.position

	for i = 1, #self.points do
		local p = self.points[i]
		local dist = helper.distance(pos.x, pos.y, -p.x, -p.y)
		local on_inert = true
		-- If inert ~= 0, scroll only by move direction
		if inert.x ~= 0 and helper.sign(inert.x) ~= helper.sign(-p.x - pos.x) then
			on_inert = false
		end
		if inert.y ~= 0 and helper.sign(inert.y) ~= helper.sign(-p.y - pos.y) then
			on_inert = false
		end

		if dist < temp_dist then
			index = i
			temp_dist = dist
		end
		if on_inert and dist < temp_dist_on_inert then
			index_on_inert = i
			temp_dist_on_inert = dist
		end
	end

	self:scroll_to_index(index_on_inert or index)
end


function Scroll._check_threshold(self)
	local is_stopped = false

	if self.inertion.x ~= 0 and math.abs(self.inertion.x) < self.style.INERT_THRESHOLD then
		is_stopped = true
		self.inertion.x = 0
	end
	if self.inertion.y ~= 0 and math.abs(self.inertion.y) < self.style.INERT_THRESHOLD then
		is_stopped = true
		self.inertion.y = 0
	end

	if is_stopped or not self._is_inert then
		self:_check_points()
	end
end


function Scroll._update_free_scroll(self, dt)
	local target = self.target_position

	if self._is_inert and (self.inertion.x ~= 0 or self.inertion.y ~= 0) then
		-- Inertion apply
		target.x = self.position.x + self.inertion.x * self.style.INERT_SPEED * dt
		target.y = self.position.y + self.inertion.y * self.style.INERT_SPEED * dt

		self:_check_threshold()
	end

	-- Inertion friction
	self.inertion = self.inertion * self.style.FRICT

	self:_check_soft_zone()
	if self.position.x ~= target.x or self.position.y ~= target.y then
		self:_set_scroll_position(target)
	end
end


function Scroll._update_hand_scroll(self, dt)
	local dx = self.target_position.x - self.position.x
	local dy = self.target_position.y - self.position.y

	self.inertion.x = (self.inertion.x + dx) * self.style.FRICT_HOLD
	self.inertion.y = (self.inertion.y + dy) * self.style.FRICT_HOLD

	self:_set_scroll_position(self.target_position)
end


function Scroll._on_touch_start(self)
	self.inertion.x = 0
	self.inertion.y = 0
	self.target_position.x = self.position.x
	self.target_position.y = self.position.y
end


function Scroll._on_touch_end(self)
	self:_check_threshold()
end


function Scroll._update_size(self)
	local view_border = helper.get_border(self.view_node)
	local view_size = vmath.mul_per_elem(gui.get_size(self.view_node), gui.get_scale(self.view_node))

	local content_border = helper.get_border(self.content_node)
	local content_size = vmath.mul_per_elem(gui.get_size(self.content_node), gui.get_scale(self.content_node))

	self.available_pos = get_border_vector(view_border - content_border, self._offset)
	self.available_size = get_size_vector(self.available_pos)

	self.drag.can_x = self.available_size.x > 0 and self._is_horizontal_scroll
	self.drag.can_y = self.available_size.y > 0 and self._is_vertical_scroll

	-- Extra content size calculation
	-- We add extra size only if scroll is available
	-- Even the content zone size less than view zone size
	local content_border_extra = helper.get_border(self.content_node)
	local stretch_size = self.style.EXTRA_STRETCH_SIZE

	if self.drag.can_x then
		local sign = content_size.x > view_size.x and 1 or -1
		content_border_extra.x = content_border_extra.x - stretch_size * sign
		content_border_extra.z = content_border_extra.z + stretch_size * sign
	end

	if self.drag.can_y then
		local sign = content_size.y > view_size.y and 1 or -1
		content_border_extra.y = content_border_extra.y + stretch_size * sign
		content_border_extra.w = content_border_extra.w - stretch_size * sign
	end

	if not self.style.SMALL_CONTENT_SCROLL then
		self.drag.can_x = content_size.x > view_size.x
		self.drag.can_y = content_size.y > view_size.y
	end

	self.available_pos_extra = get_border_vector(view_border - content_border_extra, self._offset)
	self.available_size_extra = get_size_vector(self.available_pos_extra)
end


return Scroll
