-- Copyright (c) 2021 Maxim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Druid checkbox component
-- @module Checkbox
-- @within BaseComponent
-- @alias druid.checkbox

--- On change state callback(self, state)
-- @tfield druid_event on_change_state

--- Visual node
-- @tfield node node

--- Button trigger node
-- @tfield[opt=node] node click_node

--- Button component from click_node
-- @tfield Button button

---

local Event = require("druid.event")
local component = require("druid.component")

local Checkbox = component.create("checkbox", { component.ON_LAYOUT_CHANGE })


local function on_click(self)
	self:set_state(not self.state)
end


--- Component style params.
-- You can override this component styles params in druid styles table
-- or create your own style
-- @table style
-- @tfield function on_change_state (self, node, state)
function Checkbox.on_style_change(self, style)
	self.style = {}

	self.style.on_change_state = style.on_change_state or function(_, node, state)
		gui.set_enabled(node, state)
	end
end


--- Component init function
-- @tparam Checkbox self
-- @tparam node node Gui node
-- @tparam function callback Checkbox callback
-- @tparam[opt=node] node click_node Trigger node, by default equals to node
-- @tparam[opt=false] boolean initial_state The initial state of checkbox, default - false
function Checkbox.init(self, node, callback, click_node, initial_state)
	self.druid = self:get_druid()
	self.node = self:get_node(node)
	self.click_node = self:get_node(click_node)

	self.button = self.druid:new_button(self.click_node or self.node, on_click)
	self:set_state(initial_state, true, true)

	self.on_change_state = Event(callback)
end


function Checkbox.on_layout_change(self)
	self:set_state(self.state, true)
end


--- Set checkbox state
-- @tparam Checkbox self
-- @tparam bool state Checkbox state
-- @tparam bool is_silent Don't trigger on_change_state if true
-- @tparam bool is_instant If instant checkbox change
function Checkbox.set_state(self, state, is_silent, is_instant)
	self.state = state
	self.style.on_change_state(self, self.node, state, is_instant)

	if not is_silent then
		self.on_change_state:trigger(self:get_context(), state)
	end

	return self
end


--- Return checkbox state
-- @tparam Checkbox self
-- @treturn bool Checkbox state
function Checkbox.get_state(self)
	return self.state
end


return Checkbox
