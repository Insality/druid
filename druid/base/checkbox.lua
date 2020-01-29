--- Druid checkbox component
-- @module base.checkbox

local helper = require("druid.helper")

local M = {}


function M.set_state(self, state, is_silence)
	if self.state == state then
		return
	end

	self.state = state
	if self.style.on_change_state then
		self.style.on_change_state(self, self.node, state)
	end

	if not is_silence and self.callback then
		self.callback(self.context, state)
	end
end


function M.get_state(self)
	return self.state
end


local function on_click(self)
	M.set_state(self, not self.state)
end


function M.init(self, node, callback, click_node)
	self.style = helper.get_style(self, "CHECKBOX")
	self.druid = helper.get_druid(self)
	self.node = helper.get_node(node)
	self.click_node = helper.get_node(click_node)
	self.callback = callback

	self.button = self.druid:new_button(self.click_node or self.node, on_click)
	M.set_state(self, false, true)
end


return M
