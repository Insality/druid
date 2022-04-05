-- Copyright (c) 2021 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Component to handle back key (android, backspace)
-- @module BackHandler
-- @within BaseComponent
-- @alias druid.back_handler

--- On back handler callback(self, params)
-- @tfield DruidEvent on_back @{DruidEvent}

--- Params to back callback
-- @tfield any params

---

local Event = require("druid.event")
local const = require("druid.const")
local component = require("druid.component")

local BackHandler = component.create("back_handler")


--- Component init function
-- @tparam BackHandler self @{BackHandler}
-- @tparam callback callback On back button
-- @tparam[opt] any params Callback argument
function BackHandler.init(self, callback, params)
	self.params = params
	self.on_back = Event(callback)
end


function BackHandler.on_internal_remove(self)
	component.on_internal_remove(self)
	self.on_back:clear()
end


--- Input handler for component
-- @tparam BackHandler self @{BackHandler}
-- @tparam string action_id on_input action id
-- @tparam table action on_input action
function BackHandler.on_input(self, action_id, action)
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
