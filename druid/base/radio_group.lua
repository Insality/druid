--- Radio group module
-- @module druid.radio_group

--- Component events
-- @table Events
-- @tfield druid_event on_radio_click On any checkbox click

--- Component fields
-- @table Fields
-- @tfield table checkboxes Array of checkbox components

local Event = require("druid.event")
local component = require("druid.component")

local M = component.create("radio_group")


local function on_checkbox_click(self, index)
	for i = 1, #self.checkboxes do
		self.checkboxes[i]:set_state(i == index, true)
	end

	self.on_radio_click:trigger(self:get_context(), index)
end


--- Component init function
-- @function radio_group:init
-- @tparam node[] node Array of gui node
-- @tparam function callback Radio callback
-- @tparam[opt=node] node[] click node Array of trigger nodes, by default equals to nodes
function M.init(self, nodes, callback, click_nodes)
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
-- @function radio_group:set_state
-- @tparam bool[] state Array of checkbox state
function M.set_state(self, index)
	on_checkbox_click(self, index)
end


--- Return radio group state
-- @function radio_group:get_state
-- @treturn bool[] Array if checkboxes state
function M.get_state(self)
	local result = -1

	for i = 1, #self.checkboxes do
		if self.checkboxes[i]:get_state() then
			result = i
			break
		end
	end

	return result
end


return M
