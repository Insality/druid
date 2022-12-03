-- Copyright (c) 2021 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Component to handle hover node interaction
-- @module Hover
-- @within BaseComponent
-- @alias druid.hover

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


--- Component init function
-- @tparam Hover self @{Hover}
-- @tparam node node Gui node
-- @tparam function on_hover_callback Hover callback
function Hover.init(self, node, on_hover_callback)
	self.node = self:get_node(node)

	self._is_hovered = false
	self._is_mouse_hovered = false
	self._is_enabled = true
	self._is_mobile = helper.is_mobile()

	self.on_hover = Event(on_hover_callback)
	self.on_mouse_hover = Event()
end


function Hover.on_late_init(self)
	if not self.click_zone and const.IS_STENCIL_CHECK then
		local stencil_node = helper.get_closest_stencil_node(self.node)
		if stencil_node then
			self:set_click_zone(stencil_node)
		end
	end
end


function Hover.on_input(self, action_id, action)
	if action_id ~= const.ACTION_TOUCH and action_id ~= nil then
		return false
	end

	-- Disable nil (it's mouse) hover or mobile platforms
	if self._is_mobile and not action_id then
		return false
	end

	if not helper.is_enabled(self.node) or not self._is_enabled then
		self:set_hover(false)
		self:set_mouse_hover(false)
		return false
	end

	local is_pick = gui.pick_node(self.node, action.x, action.y)
	if self.click_zone then
		is_pick = is_pick and gui.pick_node(self.click_zone, action.x, action.y)
	end

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
-- @tparam bool state The hover state
function Hover.set_hover(self, state)
	if self._is_hovered ~= state then
		self._is_hovered = state
		self.on_hover:trigger(self:get_context(), state, self)
	end
end

--- Set mouse hover state
-- @tparam Hover self @{Hover}
-- @tparam bool state The mouse hover state
function Hover.set_mouse_hover(self, state)
	if self._is_mouse_hovered ~= state then
		self._is_mouse_hovered = state
		self.on_mouse_hover:trigger(self:get_context(), state, self)
	end
end


--- Strict hover click area. Useful for
-- no click events outside stencil node
-- @tparam Hover self @{Hover}
-- @tparam node zone Gui node
function Hover.set_click_zone(self, zone)
	self.click_zone = self:get_node(zone)
end


--- Set enable state of hover component.
-- If hover is not enabled, it will not generate
-- any hover events
-- @tparam Hover self @{Hover}
-- @tparam bool state The hover enabled state
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
-- @treturn bool The hover enabled state
function Hover.is_enabled(self)
	return self._is_enabled
end


return Hover
