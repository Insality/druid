-- Copyright (c) 2021 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Component to handle swipe gestures on node.
-- Swipe will be triggered, if swipe was started and
-- ended on one node
--
-- <a href="https://insality.github.io/druid/druid/index.html?example=general_swipe" target="_blank"><b>Example Link</b></a>
-- @module Swipe
-- @within BaseComponent
-- @alias druid.swipe

--- Swipe node
-- @tparam node node

--- Restriction zone
-- @tparam[opt] node click_zone

--- Trigger on swipe event(self, swipe_side, dist, delta_time)
-- @tfield DruidEvent on_swipe) @{DruidEvent}

---

local Event = require("druid.event")
local const = require("druid.const")
local helper = require("druid.helper")
local component = require("druid.component")

local Swipe = component.create("swipe")


local function start_swipe(self, action)
	self._swipe_start_time = socket.gettime()
	self._start_pos.x = action.x
	self._start_pos.y = action.y
end


local function reset_swipe(self, action)
	self._swipe_start_time = false
end


local function check_swipe(self, action)
	local dx = action.x - self._start_pos.x
	local dy = action.y - self._start_pos.y
	local dist = helper.distance(self._start_pos.x, self._start_pos.y, action.x, action.y)
	local delta_time = socket.gettime() - self._swipe_start_time
	local is_swipe = self.style.SWIPE_THRESHOLD <= dist and delta_time <= self.style.SWIPE_TIME

	if is_swipe then
		local is_x_swipe = math.abs(dx) >= math.abs(dy)
		local swipe_side = false

		if is_x_swipe and dx > 0 then
			swipe_side = const.SWIPE.RIGHT
		end
		if is_x_swipe and dx < 0 then
			swipe_side = const.SWIPE.LEFT
		end
		if not is_x_swipe and dy > 0 then
			swipe_side = const.SWIPE.UP
		end
		if not is_x_swipe and dy < 0 then
			swipe_side = const.SWIPE.DOWN
		end

		self.on_swipe:trigger(self:get_context(), swipe_side, dist, delta_time)
		reset_swipe(self)
	end
end


--- Component style params.
-- You can override this component styles params in druid styles table
-- or create your own style
-- @table style
-- @tfield[opt=0.4] number SWIPE_TIME Maximum time for swipe trigger
-- @tfield[opt=50] number SWIPE_THRESHOLD Minimum distance for swipe trigger
-- @tfield[opt=false] boolean SWIPE_TRIGGER_ON_MOVE If true, trigger on swipe moving, not only release action
function Swipe.on_style_change(self, style)
	self.style = {}
	self.style.SWIPE_TIME = style.SWIPE_TIME or 0.4
	self.style.SWIPE_THRESHOLD = style.SWIPE_THRESHOLD or 50
	self.style.SWIPE_TRIGGER_ON_MOVE = style.SWIPE_TRIGGER_ON_MOVE or false
end


--- The @{Swipe} constructor
-- @tparam Swipe self @{Swipe}
-- @tparam node node Gui node
-- @tparam function on_swipe_callback Swipe callback for on_swipe_end event
function Swipe.init(self, node, on_swipe_callback)
	self._trigger_on_move = self.style.SWIPE_TRIGGER_ON_MOVE
	self.node = self:get_node(node)

	self._swipe_start_time = false
	self._start_pos = vmath.vector3(0)

	self.click_zone = nil
	self.on_swipe = Event(on_swipe_callback)
end


function Swipe.on_late_init(self)
	if not self.click_zone and const.IS_STENCIL_CHECK then
		local stencil_node = helper.get_closest_stencil_node(self.node)
		if stencil_node then
			self:set_click_zone(stencil_node)
		end
	end
end


function Swipe.on_input(self, action_id, action)
	if action_id ~= const.ACTION_TOUCH then
		return false
	end

	if not gui.is_enabled(self.node, true) then
		return false
	end

	local is_pick = helper.pick_node(self.node, action.x, action.y, self.click_zone)
	if not is_pick then
		reset_swipe(self, action)
		return false
	end

	if self._swipe_start_time and (self._trigger_on_move or action.released) then
		check_swipe(self, action)
	end

	if action.pressed then
		start_swipe(self, action)
	end

	if action.released then
		reset_swipe(self, action)
	end

	return true
end


function Swipe.on_input_interrupt(self)
	reset_swipe(self)
end


--- Strict swipe click area. Useful for
-- restrict events outside stencil node
-- @tparam Swipe self @{Swipe}
-- @tparam node zone Gui node
function Swipe.set_click_zone(self, zone)
	self.click_zone = self:get_node(zone)
end


return Swipe
