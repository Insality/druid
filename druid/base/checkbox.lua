--- Druid checkbox component
-- @module base.checkbox

local helper = require("druid.helper")

local M = {}


local function state_animate(node, state)
	local target = state and 1 or 0
	gui.animate(node, "color.w", target, gui.EASING_OUTSINE, 0.1)
end


function M.set_state(self, state, is_silence)
	if self.state == state then
		return
	end

	self.state = state
	state_animate(self.node, state)

	if not is_silence and self.callback then
		self.callback(self.parent.parent, state)
	end
end


-- TODO: pass self as first parameter
local function on_click(context, self)
	M.set_state(self, not self.state)
end


function M.init(self, node, callback, click_node)
	self.node = helper.get_node(node)
	self.click_node = helper.get_node(click_node)
	self.callback = callback
	self.button = self.parent:new_button(self.click_node or self.node, on_click, self)
	M.set_state(self, false, true)
end


return M
