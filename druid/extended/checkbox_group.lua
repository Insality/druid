--- Checkbox group module
-- @module CheckboxGroup
-- @within BaseComponent
-- @alias druid.checkbox_group

--- On any checkbox click callback(self, index)
-- @tfield druid_event on_checkbox_click

--- Array of checkbox components
-- @tfield table checkboxes

---

local Event = require("druid.event")
local component = require("druid.component")

local CheckboxGroup = component.create("checkbox_group")


--- Component init function
-- @tparam CheckboxGroup self
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
-- @tparam CheckboxGroup self
-- @tparam bool[] indexes Array of checkbox state
function CheckboxGroup.set_state(self, indexes)
	for i = 1, #indexes do
		if self.checkboxes[i] then
			self.checkboxes[i]:set_state(indexes[i], true)
		end
	end
end


--- Return checkbox group state
-- @tparam CheckboxGroup self
-- @treturn bool[] Array if checkboxes state
function CheckboxGroup.get_state(self)
	local result = {}

	for i = 1, #self.checkboxes do
		table.insert(result, self.checkboxes[i]:get_state())
	end

	return result
end


return CheckboxGroup
