--- Component to handle drag action on node
-- @module druid.drag

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

local M = component.create("drag", { const.ON_INPUT_HIGH })


local function start_touch(self, touch)
	self.is_touch = true
	self.is_drag = false

	self.touch_start_pos.x = touch.x
	self.touch_start_pos.y = touch.y

	self.x = touch.x
	self.y = touch.y

	self.on_touch_start:trigger(self:get_context())
end


local function end_touch(self)
	if self.is_drag then
		self.on_drag_end:trigger(self:get_context())
	end

	self.is_drag = false
	self.is_touch = false
	self.on_touch_end:trigger(self:get_context())
	self:reset_input_priority()
	self.touch_id = 0
end


local function process_touch(self, touch)
	if not self.can_x then
		self.touch_start_pos.x = touch.x
	end
	if not self.can_y then
		self.touch_start_pos.y = touch.y
	end

	local distance = helper.distance(touch.x, touch.y, self.touch_start_pos.x, self.touch_start_pos.y)
	if not self.is_drag and distance >= self.drag_deadzone then
		self.is_drag = true
		self.on_drag_start:trigger(self:get_context())
		self:increase_input_priority()
	end
end


local function find_touch(action_id, action, touch_id)
	local act = helper.is_mobile() and const.ACTION_MULTITOUCH or const.ACTION_TOUCH

	if action_id ~= act then
		return
	end

	if action.touch then
		local touch = action.touch
		for i = 1, #touch do
			if touch[i].id == touch_id then
				return touch[i]
			end
		end
		return touch[1]
	else
		return action
	end
end


local function on_touch_release(self, action_id, action)
	if #action.touch >= 2 then
		-- Find next unpressed touch
		local next_touch
		for i = 1, #action.touch do
			if not action.touch[i].released then
				next_touch = action.touch[i]
				break
			end
		end

		if next_touch then
			self.x = next_touch.x
			self.y = next_touch.y
			self.touch_id = next_touch.id
		else
			end_touch(self)
		end
	elseif #action.touch == 1 then
		end_touch(self)
	end
end


--- Component init function
-- @function drag:init
function M.init(self, node, on_drag_callback)
	self.style = self:get_style()
	self.node = self:get_node(node)

	self.drag_deadzone = self.style.DRAG_DEADZONE or 10

	self.dx = 0
	self.dy = 0
	self.touch_id = 0
	self.x = 0
	self.y = 0
	self.is_touch = false
	self.is_drag = false
	self.touch_start_pos = vmath.vector3(0)

	self.can_x = true
	self.can_y = true

	self.click_zone = nil
	self.on_touch_start = Event()
	self.on_touch_end = Event()
	self.on_drag_start = Event()
	self.on_drag = Event(on_drag_callback)
	self.on_drag_end = Event()
end


function M.on_input_interrupt(self)
	if self.is_drag or self.is_touch then
		end_touch(self)
	end
end


function M.on_input(self, action_id, action)
	if action_id ~= const.ACTION_TOUCH and action_id ~= const.ACTION_MULTITOUCH then
		return
	end

	if not helper.is_enabled(self.node) then
		return false
	end

	local is_pick = gui.pick_node(self.node, action.x, action.y)
	if self.click_zone then
		is_pick = is_pick and gui.pick_node(self.click_zone, action.x, action.y)
	end

	if not is_pick and not self.is_drag then
		end_touch(self)
		return false
	end

	self.dx = 0
	self.dy = 0

	local touch = find_touch(action_id, action, self.touch_id)
	if not touch then
		return false
	end

	if touch.id then
		self.touch_id = touch.id
	end

	if touch.pressed and not self.is_touch then
		start_touch(self, touch)
	end

	if touch.released and self.is_touch then
		if action.touch then
			-- Mobile
			on_touch_release(self, action_id, action)
		else
			-- PC
			end_touch(self)
		end
	end

	if self.is_touch then
		process_touch(self, touch)
	end

	local touch_modified = find_touch(action_id, action, self.touch_id)
	if touch_modified and self.is_drag then
		self.dx = touch_modified.x - self.x
		self.dy = touch_modified.y - self.y
	end

	if touch_modified then
		self.x = touch_modified.x
		self.y = touch_modified.y
	end

	if self.is_drag then
		self.on_drag:trigger(self:get_context(), self.dx, self.dy)
	end

	return self.is_drag
end


--- Strict drag click area. Useful for
-- restrict events outside stencil node
-- @function drag:set_click_zone
-- @tparam node zone Gui node
function M.set_click_zone(self, zone)
	self.click_zone = self:get_node(zone)
end


return M
