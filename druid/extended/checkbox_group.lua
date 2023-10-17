-- Copyright (c) 2021 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Checkbox group module
--
-- <a href="https://insality.github.io/druid/druid/index.html?example=general_checkboxes" target="_blank"><b>Example Link</b></a>
-- @module CheckboxGroup
-- @within BaseComponent
-- @alias druid.checkbox_group

--- On any checkbox click callback(self, index)
-- @tfield DruidEvent on_checkbox_click @{DruidEvent}

--- Array of checkbox components
-- @tfield table checkboxes @{Checkbox}

---

local Event = require("druid.event")
local component = require("druid.component")

local CheckboxGroup = component.create("checkbox_group")


--- The @{CheckboxGroup} constructor
-- @tparam CheckboxGroup self @{CheckboxGroup}
-- @tparam node[] nodes Array of gui node
-- @tparam function callback Checkbox callback
-- @tparam[opt=node] node[] click_nodes Array of trigger nodes, by default equals to nodes
function CheckboxGroup.init(self, nodes, callback, click_nodes)
	self.druid = self:get_druid()
	self.checkboxes = {}

	self.on_checkbox_click = Event(callback)

	for i = 1, #nodes do
		local click_node = click_nodes and click_nodes[i] or nil
		local checkbox = self.druid:new_checkbox(nodes[i], function()
			self.on_checkbox_click:trigger(self:get_context(), i)
		end, click_node)

		table.insert(self.checkboxes, checkbox)
	end
end


--- Set checkbox group state
-- @tparam CheckboxGroup self @{CheckboxGroup}
-- @tparam boolean[] indexes Array of checkbox state
-- @tparam boolean|nil is_instant If instant state change
function CheckboxGroup.set_state(self, indexes, is_instant)
	for i = 1, #indexes do
		if self.checkboxes[i] then
			self.checkboxes[i]:set_state(indexes[i], true, is_instant)
		end
	end
end


--- Return checkbox group state
-- @tparam CheckboxGroup self @{CheckboxGroup}
-- @treturn boolean[] Array if checkboxes state
function CheckboxGroup.get_state(self)
	local result = {}

	for i = 1, #self.checkboxes do
		table.insert(result, self.checkboxes[i]:get_state())
	end

	return result
end


return CheckboxGroup
