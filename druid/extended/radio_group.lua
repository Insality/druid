-- Copyright (c) 2021 Maxim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Radio group module
-- @module RadioGroup
-- @within BaseComponent
-- @alias druid.radio_group

--- On any checkbox click
-- @tfield druid_event on_radio_click

--- Array of checkbox components
-- @tfield Checkbox[] checkboxes

---

local Event = require("druid.event")
local component = require("druid.component")

local RadioGroup = component.create("radio_group")


local function on_checkbox_click(self, index, is_instant)
	for i = 1, #self.checkboxes do
		self.checkboxes[i]:set_state(i == index, true, is_instant)
	end

	self.on_radio_click:trigger(self:get_context(), index)
end


--- Component init function
-- @tparam RadioGroup self
-- @tparam node[] nodes Array of gui node
-- @tparam function callback Radio callback
-- @tparam[opt=node] node[] click_nodes Array of trigger nodes, by default equals to nodes
function RadioGroup.init(self, nodes, callback, click_nodes)
	self.druid = self:get_druid()
	self.checkboxes = {}

	self.on_radio_click = Event(callback)

	for i = 1, #nodes do
		local click_node = click_nodes and click_nodes[i] or nil
		local checkbox = self.druid:new_checkbox(nodes[i], function()
			on_checkbox_click(self, i)
		end, click_node)

		table.insert(self.checkboxes, checkbox)
	end
end


--- Set radio group state
-- @tparam RadioGroup self
-- @tparam number index Index in radio group
-- @tparam boolean is_instant If is instant state change
function RadioGroup.set_state(self, index, is_instant)
	on_checkbox_click(self, index, is_instant)
end


--- Return radio group state
-- @tparam RadioGroup self
-- @treturn number Index in radio group
function RadioGroup.get_state(self)
	local result = -1

	for i = 1, #self.checkboxes do
		if self.checkboxes[i]:get_state() then
			result = i
			break
		end
	end

	return result
end


return RadioGroup
