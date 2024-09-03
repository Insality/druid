-- Copyright (c) 2021 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Component to handle hover node interaction
-- @module Hover
-- @within BaseComponent
-- @alias druid.hover

--- Hover node
-- @tfield node node

--- On hover callback(self, state, hover_instance)
-- @tfield DruidEvent on_hover @{DruidEvent}

--- On mouse hover callback(self, state, hover_instance)
-- @tfield DruidEvent on_mouse_hover @{DruidEvent}

---

local Event = require("druid.event")
local const = require("druid.const")
local helper = require("druid.helper")
local component = require("druid.component")

local Hover = component.create("hover")


--- The @{Hover} constructor
-- @tparam Hover self @{Hover}
-- @tparam node node Gui node
-- @tparam function on_hover_callback Hover callback
-- @tparam function on_mouse_hover On mouse hover callback
function Hover.init(self, node, on_hover_callback, on_mouse_hover)
	self.node = self:get_node(node)

	self._is_hovered = false
	self._is_mouse_hovered = false
	self._is_enabled = true
	self._is_mobile = helper.is_mobile()

	self.on_hover = Event(on_hover_callback)
	self.on_mouse_hover = Event(on_mouse_hover)
end


function Hover.on_late_init(self)
	if not self.click_zone and const.IS_STENCIL_CHECK then
		local stencil_node = helper.get_closest_stencil_node(self.node)
		if stencil_node then
			self:set_click_zone(stencil_node)
		end
	end
end


--- Component style params.
-- You can override this component styles params in druid styles table
-- or create your own style
-- @table style
-- @tfield[opt] string ON_HOVER_CURSOR Mouse hover style on node hover
-- @tfield[opt] string ON_MOUSE_HOVER_CURSOR Mouse hover style on node mouse hover
function Hover.on_style_change(self, style)
	self.style = {}
	self.style.ON_HOVER_CURSOR = style.ON_HOVER_CURSOR or nil
	self.style.ON_MOUSE_HOVER_CURSOR = style.ON_MOUSE_HOVER_CURSOR or nil
end


function Hover.on_input(self, action_id, action)
	if action_id ~= const.ACTION_TOUCH and action_id ~= nil then
		return false
	end

	-- Disable nil (it's mouse) hover or mobile platforms
	if self._is_mobile and not action_id then
		return false
	end

	if not gui.is_enabled(self.node, true) or not self._is_enabled then
		self:set_hover(false)
		self:set_mouse_hover(false)
		return false
	end

	local is_pick = helper.pick_node(self.node, action.x, action.y, self.click_zone)
	local hover_function = action_id and self.set_hover or self.set_mouse_hover

	if not is_pick then
		hover_function(self, false)
		return false
	end

	if action.released then
		hover_function(self, false)
	else
		hover_function(self, true)
	end

	return false
end


function Hover.on_input_interrupt(self)
	self:set_hover(false)
end


--- Set hover state
-- @tparam Hover self @{Hover}
-- @tparam boolean|nil state The hover state
function Hover.set_hover(self, state)
	if self._is_hovered ~= state then
		self._is_hovered = state
		self.on_hover:trigger(self:get_context(), state, self)

		if defos and self.style.ON_HOVER_CURSOR then
			self:_set_cursor(3, state and self.style.ON_HOVER_CURSOR or nil)
		end
	end
end


--- Return current hover state. True if touch action was on the node at current time
-- @tparam Hover self @{Hover}
-- @treturn boolean The current hovered state
function Hover.is_hovered(self)
	return self._is_hovered
end


--- Set mouse hover state
-- @tparam Hover self @{Hover}
-- @tparam boolean|nil state The mouse hover state
function Hover.set_mouse_hover(self, state)
	if self._is_mouse_hovered ~= state then
		self._is_mouse_hovered = state
		self.on_mouse_hover:trigger(self:get_context(), state, self)

		if defos and self.style.ON_MOUSE_HOVER_CURSOR then
			self:_set_cursor(2, state and self.style.ON_MOUSE_HOVER_CURSOR or nil)
		end
	end
end


--- Return current hover state. True if nil action_id (usually desktop mouse) was on the node at current time
-- @tparam Hover self @{Hover}
-- @treturn boolean The current hovered state
function Hover.is_mouse_hovered(self)
	return self._is_mouse_hovered
end


--- Strict hover click area. Useful for
-- no click events outside stencil node
-- @tparam Hover self @{Hover}
-- @tparam node|string|nil zone Gui node
function Hover.set_click_zone(self, zone)
	self.click_zone = self:get_node(zone)
end


--- Set enable state of hover component.
-- If hover is not enabled, it will not generate
-- any hover events
-- @tparam Hover self @{Hover}
-- @tparam boolean|nil state The hover enabled state
function Hover.set_enabled(self, state)
	self._is_enabled = state

	if not state then
		if self._is_hovered then
			self:set_hover(false)
		end
		if self._is_mouse_hovered then
			self:set_mouse_hover(false)
		end
	end
end


--- Return current hover enabled state
-- @tparam Hover self @{Hover}
-- @treturn boolean The hover enabled state
function Hover.is_enabled(self)
	return self._is_enabled
end


-- Internal cursor stack
local cursor_stack = {}
function Hover:_set_cursor(priority, cursor)
	if not defos then
		return
	end

	local uid = self:get_uid()
	cursor_stack[uid] = cursor_stack[uid] or {}
	cursor_stack[uid][priority] = cursor

	-- set cursor with high priority via pairs
	local priority = nil
	local cursor_to_set = nil
	for _, stack in pairs(cursor_stack) do
		for priority, _ in pairs(stack) do
			if priority > (priority or 0) then
				priority = priority
				cursor_to_set = stack[priority]
			end
		end
	end

	defos.set_cursor(cursor_to_set)
end


return Hover
