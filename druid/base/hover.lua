--- Component to handle hover node interaction
-- @module druid.input

local Event = require("druid.event")
local const = require("druid.const")
local helper = require("druid.helper")
local component = require("druid.component")

local M = component.create("hover", { const.ON_INPUT })


--- Component init function
-- @function hover:init
-- @tparam table self Component instance
-- @tparam node node Gui node
-- @tparam function on_hover_callback Hover callback
function M.init(self, node, on_hover_callback)
	self.style = self:get_style()
	self.node = self:get_node(node)

	self._is_hovered = false
	self.on_hover = Event()
	if on_hover_callback then
		self.on_hover:subscribe(on_hover_callback)
	end
end


local function set_hover(self, state)
	if self._is_hovered ~= state then
		self._is_hovered = state
		self.on_hover:trigger(state)
	end
end


function M.on_input(self, action_id, action)
	if action_id ~= const.ACTION_TOUCH then
		return
	end

	if not helper.is_enabled(self.node) then
		return false
	end

	local is_pick = gui.pick_node(self.node, action.x, action.y)

	if not is_pick then
		set_hover(self, false)
		return false
	end

	if action.released then
		set_hover(self, false)
	else
		set_hover(self, true)
	end
end


function M.on_swipe(self)
	set_hover(self, false)
end


--- Strict button click area. Useful for
-- no click events outside stencil node
-- @function button:set_click_zone
-- @tparam table self Component instance
-- @tparam node zone Gui node
function M.set_click_zone(self, zone)
	self.click_zone = self:get_node(zone)
end


return M
