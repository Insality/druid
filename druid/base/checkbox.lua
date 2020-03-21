--- Druid checkbox component
-- @module druid.checkbox

--- Component events
-- @table Events
-- @tfield druid_event on_change_state On change state callback

--- Component fields
-- @table Fields
-- @tfield node node Visual node
-- @tfield[opt=node] node click_node Button trigger node
-- @tfield druid.button button Button component from click_node

--- Component style params
-- @table Style
-- @tfield function on_change_state (self, node, state)

local Event = require("druid.event")
local component = require("druid.component")

local M = component.create("checkbox")


local function on_click(self)
	M.set_state(self, not self.state)
end


--- Component init function
-- @function checkbox:init
-- @tparam node node Gui node
-- @tparam function callback Checkbox callback
-- @tparam[opt=node] node click node Trigger node, by default equals to node
function M.init(self, node, callback, click_node)
	self.style = self:get_style()
	self.druid = self:get_druid()
	self.node = self:get_node(node)
	self.click_node = self:get_node(click_node)

	self.button = self.druid:new_button(self.click_node or self.node, on_click)
	M.set_state(self, false, true)

	self.on_change_state = Event(callback)
end


--- Set checkbox state
-- @function checkbox:set_state
-- @tparam bool state Checkbox state
-- @tparam bool is_silent Don't trigger on_change_state if true
function M.set_state(self, state, is_silent)
	if self.state == state then
		return
	end

	self.state = state
	if self.style.on_change_state then
		self.style.on_change_state(self, self.node, state)
	end

	if not is_silent then
		self.on_change_state:trigger(self:get_context(), state)
	end
end


--- Return checkbox state
-- @function checkbox:get_state
-- @treturn bool Checkbox state
function M.get_state(self)
	return self.state
end


return M
