--- Component to handle swipe gestures on node.
-- Swipe will be triggered, if swipe was started and
-- ended on one node
-- @module druid.swipe

--- Components fields
-- @table Fields
-- @tparam node node Swipe node
-- @tparam[opt] node click_zone Restriction zone

--- Component events
-- @table Events
-- @tfield druid_event on_swipe Trigger on swipe event

--- Component style params
-- @table Style
-- @tfield number SWIPE_TIME Maximum time for swipe trigger
-- @tfield number SWIPE_THRESHOLD Minimum distance for swipe trigger
-- @tfield bool SWIPE_TRIGGER_ON_MOVE If true, trigger on swipe moving, not only release action

local Event = require("druid.event")
local const = require("druid.const")
local helper = require("druid.helper")
local component = require("druid.component")

local M = component.create("swipe", { const.ON_INPUT })


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


--- Component init function
-- @function swipe:init
-- @tparam node node Gui node
-- @tparam function on_swipe_callback Swipe callback for on_swipe_end event
function M.init(self, node, on_swipe_callback)
	self.style = self:get_style()
	self._trigger_on_move = self.style.SWIPE_TRIGGER_ON_MOVE
	self.node = self:get_node(node)

	self._swipe_start_time = false
	self._start_pos = vmath.vector3(0)

	self.click_zone = nil
	self.on_swipe = Event(on_swipe_callback)
end


function M.on_input(self, action_id, action)
	if action_id ~= const.ACTION_TOUCH then
		return
	end

	if not helper.is_enabled(self.node) then
		return false
	end

	local is_pick = gui.pick_node(self.node, action.x, action.y)
	if self.click_zone then
		is_pick = is_pick and gui.pick_node(self.click_zone, action.x, action.y)
	end

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
end


function M.on_input_interrupt(self)
	reset_swipe(self)
end


--- Strict swipe click area. Useful for
-- restrict events outside stencil node
-- @function swipe:set_click_zone
-- @tparam node zone Gui node
function M.set_click_zone(self, zone)
	self.click_zone = self:get_node(zone)
end


return M
