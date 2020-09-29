--- Component to handle back key (android, backspace)
-- @module druid.back_handler

--- Component events
-- @table Events
-- @tfield druid_event on_back On back handler callback

--- Component fields
-- @table Fields
-- @tfield any params Params to click callbacks

local Event = require("druid.event")
local const = require("druid.const")
local component = require("druid.component")

local BackHandler = component.create("back_handler", { const.ON_INPUT })


--- Component init function
-- @function back_handler:init
-- @tparam callback callback On back button
-- @tparam[opt] params Callback argument
function BackHandler:init(callback, params)
	self.params = params

	self.on_back = Event(callback)
end


--- Input handler for component
-- @function back_handler:on_input
-- @tparam string action_id on_input action id
-- @tparam table action on_input action
function BackHandler:on_input(action_id, action)
	if not action[const.RELEASED] then
		return false
	end

	if action_id == const.ACTION_BACK or action_id == const.ACTION_BACKSPACE then
		self.on_back:trigger(self:get_context(), self.params)
		return true
	end

	return false
end


return BackHandler
