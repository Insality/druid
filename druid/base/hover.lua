--- Component to handle hover node interaction
-- @module druid.hover

--- Component events
-- @table Events
-- @tfield druid_event on_hover On hover callback

local Event = require("druid.event")
local const = require("druid.const")
local helper = require("druid.helper")
local component = require("druid.component")

local M = component.create("hover", { const.ON_INPUT })


--- Component init function
-- @function hover:init
-- @tparam node node Gui node
-- @tparam function on_hover_callback Hover callback
function M.init(self, node, on_hover_callback)
	self.style = self:get_style()
	self.node = self:get_node(node)

	self._is_hovered = false

	self.on_hover = Event(on_hover_callback)
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
		M.set_hover(self, false)
		return false
	end

	if action.released then
		M.set_hover(self, false)
	else
		M.set_hover(self, true)
	end
end


function M.on_input_interrupt(self)
	M.set_hover(self, false)
end


--- Set hover state
-- @function hover:set_hover
-- @tparam bool state The hover state
function M.set_hover(self, state)
	if self._is_hovered ~= state then
		self._is_hovered = state
		self.on_hover:trigger(self:get_context(), state)
	end
end


--- Strict hover click area. Useful for
-- no click events outside stencil node
-- @function hover:set_click_zone
-- @tparam node zone Gui node
function M.set_click_zone(self, zone)
	self.click_zone = self:get_node(zone)
end


return M
