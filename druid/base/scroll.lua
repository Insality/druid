-- Copyright (c) 2021 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Component to handle scroll content.
-- <b># Overview #</b>
--
-- The Scroll component is designed to handle scrollable content and consists of two nodes: the scroll parent and the scroll input.
--
-- The scroll input represents the user input zone and remains static.
--
-- The scroll parent is the movable part of the scroll and changes its position.
--
-- The initial scroll size can be set by adjusting the size of the scroll parent.
-- If the size of the scroll parent is smaller than the scroll input size, scrolling is not available.
--
-- <b># Notes #</b>
--
-- • By default, the scroll style includes inertia and extra size for a stretching effect.
-- These settings can be adjusted using the scroll style settings.
-- For more details, refer to the scroll style settings.
--
-- • "Points of interest" can be set up for the scroll.
-- The scroll will always be centered on the closest point of interest.
-- This feature allows creating a slider without inertia and with points of interest on each scroll element.
--
-- • The scroll content size can be adjusted using the scroll:set_size(node_size) method.
-- This method sets a new size for the _content node.
--
-- • Inertial scrolling mode can be enabled or disabled using the scroll:set_inert(state) method.
--
-- • The extra stretch size can be adjusted using the scroll:set_extra_stretch_size method.
--
-- • Multitouch is required for scrolling. The scroll component correctly handles
-- touch ID swaps while dragging the scroll.
--
-- <a href="https://insality.github.io/druid/druid/index.html?example=general_scroll" target="_blank"><b>Example Link</b></a>
-- @module Scroll
-- @within BaseComponent
-- @alias druid.scroll


--- On scroll move callback(self, position)
-- @tfield DruidEvent on_scroll @{DruidEvent}

--- On scroll_to function callback(self, target, is_instant)
-- @tfield DruidEvent on_scroll_to @{DruidEvent}

--- On scroll_to_index function callback(self, index, point)
-- @tfield DruidEvent on_point_scroll @{DruidEvent}

--- Scroll view node
-- @tfield node view_node

--- Scroll content node
-- @tfield node content_node

--- Flag, if scroll now moving by inertion
-- @tfield boolean _is_inert

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
-- @tfield Drag drag @{Drag}

--- Current index of points of interests
-- @tfield number|nil selected

--- Flag, if scroll now animating by gui.animate
-- @tfield boolean is_animate

---

local Event = require("druid.event")
local const = require("druid.const")
local helper = require("druid.helper")
local component = require("druid.component")

local Scroll = component.create("scroll")


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
-- @tfield number|nil FRICT Multiplier for free inertion. Default: 0
-- @tfield number|nil FRICT_HOLD Multiplier for inertion, while touching. Default: 0
-- @tfield number|nil INERT_THRESHOLD Scroll speed to stop inertion. Default: 3
-- @tfield number|nil INERT_SPEED Multiplier for inertion speed. Default: 30
-- @tfield number|nil POINTS_DEADZONE Speed to check points of interests in no_inertion mode. Default: 20
-- @tfield number|nil BACK_SPEED Scroll back returning lerp speed. Default: 35
-- @tfield number|nil ANIM_SPEED Scroll gui.animation speed for scroll_to function. Default: 2
-- @tfield number|nil EXTRA_STRETCH_SIZE extra size in pixels outside of scroll (stretch effect). Default: 0
-- @tfield boolean|nil SMALL_CONTENT_SCROLL If true, content node with size less than view node size can be scrolled. Default: false
-- @tfield boolean|nil WHEEL_SCROLL_SPEED The scroll speed via mouse wheel scroll or touchpad. Set to 0 to disable wheel scrolling. Default: 0
-- @tfield boolean|nil WHEEL_SCROLL_INVERTED If true, invert direction for touchpad and mouse wheel scroll. Default: false
-- @tfield boolean|nil WHEEL_SCROLL_BY_INERTION If true, wheel will add inertion to scroll. Direct set position otherwise.. Default: false
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
	self.style.WHEEL_SCROLL_SPEED = style.WHEEL_SCROLL_SPEED or 0
	self.style.WHEEL_SCROLL_INVERTED = style.WHEEL_SCROLL_INVERTED or false
	self.style.WHEEL_SCROLL_BY_INERTION = style.WHEEL_SCROLL_BY_INERTION or false

	self._is_inert = not (self.style.FRICT == 0 or
		self.style.FRICT_HOLD == 0 or
		self.style.INERT_SPEED == 0)
end


--- The @{Scroll} constructor
-- @tparam Scroll self @{Scroll}
-- @tparam string|node view_node GUI view scroll node
-- @tparam string|node content_node GUI content scroll node
function Scroll.init(self, view_node, content_node)
	self.druid = self:get_druid()

	self.view_node = self:get_node(view_node)
	self.view_border = helper.get_border(self.view_node)
	self.content_node = self:get_node(content_node)

	self.view_size = helper.get_scaled_size(self.view_node)

	self.position = gui.get_position(self.content_node)
	self.target_position = vmath.vector3(self.position)
	self.inertion = vmath.vector3(0)

	self.drag = self.druid:new_drag(view_node, self._on_scroll_drag)
	self.drag.on_touch_start:subscribe(self._on_touch_start)
	self.drag.on_touch_end:subscribe(self._on_touch_end)

	self.hover = self.druid:new_hover(view_node)
	self.hover.on_mouse_hover:subscribe(self._on_mouse_hover)
	self._is_mouse_hover = false

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


function Scroll.on_late_init(self)
	if not self.click_zone and const.IS_STENCIL_CHECK then
		local stencil_node = helper.get_closest_stencil_node(self.node)
		if stencil_node then
			self:set_click_zone(stencil_node)
		end
	end
end


function Scroll.on_layout_change(self)
	gui.set_position(self.content_node, self.position)
end


function Scroll.update(self, dt)
	if self.is_animate then
		self.position.x = gui.get(self.content_node, "position.x")
		self.position.y = gui.get(self.content_node, "position.y")
		self.on_scroll:trigger(self:get_context(), self.position)
	end

	if self.drag.is_drag then
		self:_update_hand_scroll(dt)
	else
		self:_update_free_scroll(dt)
	end
end


function Scroll.on_input(self, action_id, action)
	return self:_process_scroll_wheel(action_id, action)
end


function Scroll.on_remove(self)
	self:bind_grid(nil)
end


--- Start scroll to target point.
-- @tparam Scroll self @{Scroll}
-- @tparam vector3 point Target point
-- @tparam boolean|nil is_instant Instant scroll flag
-- @usage scroll:scroll_to(vmath.vector3(0, 50, 0))
-- @usage scroll:scroll_to(vmath.vector3(0), true)
function Scroll.scroll_to(self, point, is_instant)
	local b = self.available_pos
	local target = vmath.vector3(
		self._is_horizontal_scroll and -point.x or self.target_position.x,
		self._is_vertical_scroll and -point.y or self.target_position.y,
		0)
	target.x = helper.clamp(target.x, b.x, b.z)
	target.y = helper.clamp(target.y, b.y, b.w)

	self:_cancel_animate()

	self.is_animate = not is_instant

	if is_instant then
		self.target_position = target
		self:_set_scroll_position(target.x, target.y)
	else
		gui.animate(self.content_node, gui.PROP_POSITION, target, gui.EASING_OUTSINE, self.style.ANIM_SPEED, 0, function()
			self.is_animate = false
			self.target_position = target
			self:_set_scroll_position(target.x, target.y)
		end)
	end

	self.on_scroll_to:trigger(self:get_context(), target, is_instant)
end


--- Scroll to item in scroll by point index.
-- @tparam Scroll self @{Scroll}
-- @tparam number index Point index
-- @tparam boolean|nil skip_cb If true, skip the point callback
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
-- @tparam Scroll self @{Scroll}
-- @tparam vector3 percent target percent
-- @tparam boolean|nil is_instant instant scroll flag
-- @usage scroll:scroll_to_percent(vmath.vector3(0.5, 0, 0))
function Scroll.scroll_to_percent(self, percent, is_instant)
	local border = self.available_pos

	local pos = vmath.vector3(
		-helper.lerp(border.x, border.z, 1 - percent.x),
		-helper.lerp(border.y, border.w, 1 - percent.y),
		0
	)

	if not self.drag.can_x then
		pos.x = self.position.x
	end
	if not self.drag.can_y then
		pos.y = self.position.y
	end

	self:scroll_to(pos, is_instant)
end


--- Return current scroll progress status.
-- Values will be in [0..1] interval
-- @tparam Scroll self @{Scroll}
-- @treturn vector3 New vector with scroll progress values
function Scroll.get_percent(self)
	local x_perc = 1 - inverse_lerp(self.available_pos.x, self.available_pos.z, self.position.x)
	local y_perc = inverse_lerp(self.available_pos.w, self.available_pos.y, self.position.y)

	return vmath.vector3(x_perc, y_perc, 0)
end


--- Set scroll content size.
-- It will change content gui node size
-- @tparam Scroll self @{Scroll}
-- @tparam vector3 size The new size for content node
-- @tparam vector3|nil offset Offset value to set, where content is starts
-- @treturn druid.scroll Current scroll instance
function Scroll.set_size(self, size, offset)
	if offset then
		self._offset = offset
	end
	gui.set_size(self.content_node, size)
	self:_update_size()

	return self
end


--- Set new scroll view size in case the node size was changed.
-- @tparam Scroll self @{Scroll}
-- @tparam vector3 size The new size for view node
-- @treturn druid.scroll Current scroll instance
function Scroll.set_view_size(self, size)
	gui.set_size(self.view_node, size)
	self.view_size = size
	self.view_border = helper.get_border(self.view_node)
	self:_update_size()

	return self
end


--- Enable or disable scroll inert.
-- If disabled, scroll through points (if exist)
-- If no points, just simple drag without inertion
-- @tparam Scroll self @{Scroll}
-- @tparam boolean|nil state Inert scroll state
-- @treturn druid.scroll Current scroll instance
function Scroll.set_inert(self, state)
	self._is_inert = state

	return self
end


--- Return if scroll have inertion.
-- @tparam Scroll self @{Scroll}
-- @treturn boolean @If scroll have inertion
function Scroll.is_inert(self)
	return self._is_inert
end


--- Set extra size for scroll stretching.
-- Set 0 to disable stretching effect
-- @tparam Scroll self @{Scroll}
-- @tparam number|nil stretch_size Size in pixels of additional scroll area
-- @treturn druid.scroll Current scroll instance
function Scroll.set_extra_stretch_size(self, stretch_size)
	self.style.EXTRA_STRETCH_SIZE = stretch_size or 0
	self:_update_size()

	return self
end


--- Return vector of scroll size with width and height.
-- @tparam Scroll self @{Scroll}
-- @treturn vector3 Available scroll size
function Scroll.get_scroll_size(self)
	return self.available_size
end


--- Set points of interest.
-- Scroll will always centered on closer points
-- @tparam Scroll self @{Scroll}
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
-- @tparam Scroll self @{Scroll}
-- @tparam boolean|nil state True, if horizontal scroll is enabled
-- @treturn druid.scroll Current scroll instance
function Scroll.set_horizontal_scroll(self, state)
	self._is_horizontal_scroll = state
	self.drag.can_x = self.available_size.x > 0 and state
	return self
end


--- Lock or unlock vertical scroll
-- @tparam Scroll self @{Scroll}
-- @tparam boolean|nil state True, if vertical scroll is enabled
-- @treturn druid.scroll Current scroll instance
function Scroll.set_vertical_scroll(self, state)
	self._is_vertical_scroll = state
	self.drag.can_y = self.available_size.y > 0 and state
	return self
end


--- Check node if it visible now on scroll.
-- Extra border is not affected. Return true for elements in extra scroll zone
-- @tparam Scroll self @{Scroll}
-- @tparam node node The node to check
-- @treturn boolean True if node in visible scroll area
function Scroll.is_node_in_view(self, node)
	local node_offset_for_view = gui.get_position(node)
	local parent = gui.get_parent(node)
	local is_parent_of_view = false
	while parent do
		if parent ~= self.view_node then
			local parent_pos = gui.get_position(parent)
			node_offset_for_view.x = node_offset_for_view.x + parent_pos.x
			node_offset_for_view.y = node_offset_for_view.y + parent_pos.y
			parent = gui.get_parent(parent)
		else
			is_parent_of_view = true
			parent = nil
		end
	end
	if not is_parent_of_view then
		error("The node to check is_node_in_view should be child if scroll view")
		return false
	end

	local node_border = helper.get_border(node, node_offset_for_view)

	-- Check is vertical outside (Left or Right):
	if node_border.z < self.view_border.x or node_border.x > self.view_border.z then
		return false
	end

	-- Check is horizontal outside (Up or Down):
	if node_border.w > self.view_border.y or node_border.y < self.view_border.w then
		return false
	end

	return true
end


--- Bind the grid component (Static or Dynamic) to recalculate
-- scroll size on grid changes
-- @tparam Scroll self @{Scroll}
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
		local size = grid:get_size()
		local offset = grid:get_offset()
		self:set_size(size, offset)
	end)
	self:set_size(grid:get_size(), grid:get_offset())

	return self
end


--- Strict drag scroll area. Useful for
-- restrict events outside stencil node
-- @tparam Drag self
-- @tparam node|string node Gui node
function Scroll.set_click_zone(self, node)
	self.drag:set_click_zone(node)
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


-- Cancel animation on other animation or input touch
function Scroll._cancel_animate(self)
	self.inertion.x = 0
	self.inertion.y = 0

	if self.is_animate then
		self.target_position = gui.get_position(self.content_node)
		self.position.x = self.target_position.x
		self.position.y = self.target_position.y
		gui.cancel_animation(self.content_node, gui.PROP_POSITION)
		self.is_animate = false
	end
end


function Scroll._set_scroll_position(self, position_x, position_y)
	local available_extra = self.available_pos_extra
	position_x = helper.clamp(position_x, available_extra.x, available_extra.z)
	position_y = helper.clamp(position_y, available_extra.w, available_extra.y)

	if self.position.x ~= position_x or self.position.y ~= position_y then
		self.position.x = position_x
		self.position.y = position_y
		gui.set_position(self.content_node, self.position)

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
			self:scroll_to_index(self.selected + helper.sign(inert.x))
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
	local index = -1
	local index_on_inert = -1
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

	if index_on_inert >= 0 then
		self:scroll_to_index(index_on_inert)
	else
		self:scroll_to_index(index)
	end
end


function Scroll._check_threshold(self)
	local is_stopped = false

	if self.drag.can_x and math.abs(self.inertion.x) < self.style.INERT_THRESHOLD then
		is_stopped = true
		self.inertion.x = 0
	end
	if self.drag.can_y and math.abs(self.inertion.y) < self.style.INERT_THRESHOLD then
		is_stopped = true
		self.inertion.y = 0
	end

	if is_stopped or not self._is_inert then
		self:_check_points()
	end
end


function Scroll._update_free_scroll(self, dt)
	if self.is_animate then
		return
	end

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
		self:_set_scroll_position(target.x, target.y)
	end
end


function Scroll._update_hand_scroll(self, dt)
	if self.is_animate then
		self:_cancel_animate()
	end

	local dx = self.target_position.x - self.position.x
	local dy = self.target_position.y - self.position.y

	self.inertion.x = (self.inertion.x + dx) * self.style.FRICT_HOLD
	self.inertion.y = (self.inertion.y + dy) * self.style.FRICT_HOLD

	self:_set_scroll_position(self.target_position.x, self.target_position.y)
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
	local content_border = helper.get_border(self.content_node)
	local content_size = helper.get_scaled_size(self.content_node)

	self.available_pos = get_border_vector(self.view_border - content_border, self._offset)
	self.available_size = get_size_vector(self.available_pos)

	self.drag.can_x = self.available_size.x > 0 and self._is_horizontal_scroll
	self.drag.can_y = self.available_size.y > 0 and self._is_vertical_scroll

	-- Extra content size calculation
	-- We add extra size only if scroll is available
	-- Even the content zone size less than view zone size
	local content_border_extra = helper.get_border(self.content_node)
	local stretch_size = self.style.EXTRA_STRETCH_SIZE

	local sign_x = content_size.x > self.view_size.x and 1 or -1
	content_border_extra.x = content_border_extra.x - stretch_size * sign_x
	content_border_extra.z = content_border_extra.z + stretch_size * sign_x

	local sign_y = content_size.y > self.view_size.y and 1 or -1
	content_border_extra.y = content_border_extra.y + stretch_size * sign_y
	content_border_extra.w = content_border_extra.w - stretch_size * sign_y

	if not self.style.SMALL_CONTENT_SCROLL then
		self.drag.can_x = content_size.x > self.view_size.x and self._is_horizontal_scroll
		self.drag.can_y = content_size.y > self.view_size.y and self._is_vertical_scroll
	end

	self.available_pos_extra = get_border_vector(self.view_border - content_border_extra, self._offset)
	self.available_size_extra = get_size_vector(self.available_pos_extra)

	self:_set_scroll_position(self.position.x, self.position.y)
	self.target_position.x = self.position.x
	self.target_position.y = self.position.y
end


function Scroll._process_scroll_wheel(self, action_id, action)
	if not self._is_mouse_hover or self.style.WHEEL_SCROLL_SPEED == 0 then
		return false
	end

	if action_id ~= const.ACTION_SCROLL_UP and action_id ~= const.ACTION_SCROLL_DOWN then
		return false
	end

	local koef = (action_id == const.ACTION_SCROLL_UP) and 1 or -1
	if self.style.WHEEL_SCROLL_INVERTED then
		koef = -koef
	end

	if self.style.WHEEL_SCROLL_BY_INERTION then
		if self.drag.can_y then
			self.inertion.y = (self.inertion.y + self.style.WHEEL_SCROLL_SPEED * koef) * self.style.FRICT_HOLD
		elseif self.drag.can_x then
			self.inertion.x = (self.inertion.x + self.style.WHEEL_SCROLL_SPEED * koef) * self.style.FRICT_HOLD
		end
	else
		if self.drag.can_y then
			self.target_position.y = self.target_position.y + self.style.WHEEL_SCROLL_SPEED * koef
			self.inertion.y = 0
		elseif self.drag.can_x then
			self.target_position.x = self.target_position.x + self.style.WHEEL_SCROLL_SPEED * koef
			self.inertion.x = 0
		end

		self:_set_scroll_position(self.target_position.x, self.target_position.y)
	end

	return true
end


function Scroll._on_mouse_hover(self, state)
	self._is_mouse_hover = state
end


return Scroll
