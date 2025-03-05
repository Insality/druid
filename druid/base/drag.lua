local event = require("event.event")
local const = require("druid.const")
local helper = require("druid.helper")
local component = require("druid.component")

---@class druid.drag.style
---@field DRAG_DEADZONE number Distance in pixels to start dragging. Default: 10
---@field NO_USE_SCREEN_KOEF boolean If screen aspect ratio affects on drag values. Default: false

---@class druid.drag: druid.component
---@field node node
---@field on_touch_start event
---@field on_touch_end event
---@field on_drag_start event
---@field on_drag event
---@field on_drag_end event
---@field style druid.drag.style
---@field click_zone node|nil
---@field is_touch boolean
---@field is_drag boolean
---@field can_x boolean
---@field can_y boolean
---@field dx number
---@field dy number
---@field touch_id number
---@field x number
---@field y number
---@field screen_x number
---@field screen_y number
---@field touch_start_pos vector3
---@field private _is_enabled boolean
---@field private _x_koef number
---@field private _y_koef number
local M = component.create("drag", const.PRIORITY_INPUT_HIGH)


---@param node_or_node_id node|string
---@param on_drag_callback function
function M:init(node_or_node_id, on_drag_callback)
	self.druid = self:get_druid()
	self.node = self:get_node(node_or_node_id)
	self.hover = self.druid:new_hover(self.node)

	self.dx = 0
	self.dy = 0
	self.touch_id = 0
	self.x = 0
	self.y = 0
	self.screen_x = 0
	self.screen_y = 0
	self.is_touch = false
	self.is_drag = false
	self.touch_start_pos = vmath.vector3(0)
	self._is_enabled = true

	self.can_x = true
	self.can_y = true

	self._scene_scale = helper.get_scene_scale(self.node)

	self.click_zone = nil
	self.on_touch_start = event.create()
	self.on_touch_end = event.create()
	self.on_drag_start = event.create()
	self.on_drag = event.create(on_drag_callback)
	self.on_drag_end = event.create()

	self:on_window_resized()
	self:set_drag_cursors(true)
end


---@param style druid.drag.style
function M:on_style_change(style)
	self.style = {
		DRAG_DEADZONE = style.DRAG_DEADZONE or 10,
		NO_USE_SCREEN_KOEF = style.NO_USE_SCREEN_KOEF or false,
	}
end


---Set Drag component enabled state.
---@param is_enabled boolean
function M:set_drag_cursors(is_enabled)
	if defos and is_enabled then
		self.hover.style.ON_HOVER_CURSOR = defos.CURSOR_CROSSHAIR
		self.hover.style.ON_MOUSE_HOVER_CURSOR = defos.CURSOR_HAND
	else
		self.hover.style.ON_HOVER_CURSOR = nil
		self.hover.style.ON_MOUSE_HOVER_CURSOR = nil
	end
end


function M:on_late_init()
	if not self.click_zone then
		local stencil_node = helper.get_closest_stencil_node(self.node)
		if stencil_node then
			self:set_click_zone(stencil_node)
		end
	end
end


function M:on_window_resized()
	local x_koef, y_koef = helper.get_screen_aspect_koef()
	self._x_koef = x_koef
	self._y_koef = y_koef
	self._scene_scale = helper.get_scene_scale(self.node)
end


function M:on_input_interrupt()
	if self.is_drag or self.is_touch then
		self:_end_touch()
	end
end


---@param action_id hash
---@param action table
function M:on_input(action_id, action)
	if action_id ~= const.ACTION_TOUCH and action_id ~= const.ACTION_MULTITOUCH then
		return false
	end

	if not self._is_enabled or not gui.is_enabled(self.node, true) then
		return false
	end

	local is_pick = helper.pick_node(self.node, action.x, action.y, self.click_zone)
	if not is_pick and not self.is_drag then
		self:_end_touch()
		return false
	end


	local touch = self:_find_touch(action_id, action, self.touch_id)
	if not touch then
		return false
	end

	if touch.id then
		self.touch_id = touch.id
	end

	self.dx = 0
	self.dy = 0

	if touch.pressed and not self.is_touch then
		self:_start_touch(touch)
	end

	if touch.released and self.is_touch then
		if action.touch then
			-- Mobile
			self:_on_touch_release(action_id, action)
		else
			-- PC
			self:_end_touch(touch)
		end
	end

	if self.is_touch then
		self:_process_touch(touch)
	end

	local touch_modified = self:_find_touch(action_id, action, self.touch_id)
	if touch_modified and self.is_drag then
		self.dx = touch_modified.x - self.x
		self.dy = touch_modified.y - self.y
	end

	if touch_modified then
		self.x = touch_modified.x
		self.y = touch_modified.y

		self.screen_x = touch_modified.screen_x
		self.screen_y = touch_modified.screen_y
	end

	if self.is_drag and (self.dx ~= 0 or self.dy ~= 0) then
		local x_koef, y_koef = self._x_koef, self._y_koef
		if self.style.NO_USE_SCREEN_KOEF then
			x_koef, y_koef = 1, 1
		end

		self.on_drag:trigger(self:get_context(),
			self.dx * x_koef / self._scene_scale.x,
			self.dy * y_koef / self._scene_scale.y,
			(self.x - self.touch_start_pos.x) * x_koef / self._scene_scale.x,
			(self.y - self.touch_start_pos.y) * y_koef / self._scene_scale.y, touch_modified)
	end

	return self.is_drag
end


---Set Drag click zone
---@param node node|string|nil
---@return druid.drag self Current instance
function M:set_click_zone(node)
	self.click_zone = node and self:get_node(node) or nil

	return self
end


---Set Drag component enabled state.
---@param is_enabled boolean
---@return druid.drag self Current instance
function M:set_enabled(is_enabled)
	self._is_enabled = is_enabled

	return self
end


---Check if Drag component is capture input
---@return boolean
function M:is_enabled()
	return self._is_enabled
end


function M:_start_touch(touch)
	self.is_touch = true
	self.is_drag = false

	self.touch_start_pos.x = touch.x
	self.touch_start_pos.y = touch.y

	self.x = touch.x
	self.y = touch.y

	self.screen_x = touch.screen_x
	self.screen_y = touch.screen_y

	self._scene_scale = helper.get_scene_scale(self.node)

	self.on_touch_start:trigger(self:get_context(), touch)
end


---@param touch touch|nil
function M:_end_touch(touch)
	if self.is_drag then
		self.on_drag_end:trigger(
			self:get_context(),
			self.x - self.touch_start_pos.x,
			self.y - self.touch_start_pos.y,
			touch
		)
	end

	self.is_drag = false
	if self.is_touch then
		self.is_touch = false
		self.on_touch_end:trigger(self:get_context(), touch)
	end
	self:reset_input_priority()
	self.touch_id = 0
end


---@param touch touch
function M:_process_touch(touch)
	if not self.can_x then
		self.touch_start_pos.x = touch.x
	end

	if not self.can_y then
		self.touch_start_pos.y = touch.y
	end

	local distance = helper.distance(touch.x, touch.y, self.touch_start_pos.x, self.touch_start_pos.y)
	if not self.is_drag and distance >= self.style.DRAG_DEADZONE then
		self.is_drag = true
		self.on_drag_start:trigger(self:get_context(), touch)
		self:set_input_priority(const.PRIORITY_INPUT_MAX, true)
	end
end


---Return current touch action from action input data
---If touch_id stored - return exact this touch action
---@param action_id hash Action id from on_input
---@param action table Action from on_input
---@param touch_id number Touch id
---@return table|nil Touch action
function M:_find_touch(action_id, action, touch_id)
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


---Process on touch release. We should to find, if any other
---touches exists to switch to another touch.
---@param action_id hash Action id from on_input
---@param action table Action from on_input
function M:_on_touch_release(action_id, action)
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
			self:_end_touch()
		end
	elseif #action.touch == 1 then
		self:_end_touch()
	end
end


return M
