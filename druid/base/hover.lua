--- Component to handle hover node interaction
-- @module druid.hover
-- @within BaseComponent
-- @alias druid.hover

--- Component events
-- @table Events
-- @tfield druid_event on_hover On hover callback (Touch pressed)
-- @tfield druid_event on_mouse_hover On mouse hover callback (Touch over without action_id)

local Event = require("druid.event")
local const = require("druid.const")
local helper = require("druid.helper")
local component = require("druid.component")

local Hover = component.create("hover", { const.ON_INPUT })


--- Component init function
-- @function hover:init
-- @tparam node node Gui node
-- @tparam function on_hover_callback Hover callback
function Hover:init(node, on_hover_callback)
	self.node = self:get_node(node)

	self._is_hovered = false
	self._is_mouse_hovered = false

	self._is_enabled = true

	self.on_hover = Event(on_hover_callback)
	self.on_mouse_hover = Event()
end


function Hover:on_input(action_id, action)
	if action_id ~= const.ACTION_TOUCH and action_id ~= nil then
		return false
	end

	if not action_id and helper.is_mobile() then
		return false
	end

	if not helper.is_enabled(self.node) or not self._is_enabled then
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
end


function Hover:on_input_interrupt()
	self:set_hover(false)
end


--- Set hover state
-- @function hover:set_hover
-- @tparam bool state The hover state
function Hover:set_hover(state)
	if self._is_hovered ~= state then
		self._is_hovered = state
		self.on_hover:trigger(self:get_context(), state)
	end
end

--- Set mouse hover state
-- @function hover:set_mouse_hover
-- @tparam bool state The mouse hover state
function Hover:set_mouse_hover(state)
	if self._is_mouse_hovered ~= state then
		self._is_mouse_hovered = state
		self.on_mouse_hover:trigger(self:get_context(), state)
	end
end


--- Strict hover click area. Useful for
-- no click events outside stencil node
-- @function hover:set_click_zone
-- @tparam node zone Gui node
function Hover:set_click_zone(zone)
	self.click_zone = self:get_node(zone)
end


--- Set enable state of hover component.
-- If hover is not enabled, it will not generate
-- any hover events
-- @function hover:set_enabled
-- @tparam bool state The hover enabled state
function Hover:set_enabled(state)
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
-- @function hover:is_enabled
-- @treturn bool The hover enabled state
function Hover:is_enabled()
	return self._is_enabled
end


return Hover
