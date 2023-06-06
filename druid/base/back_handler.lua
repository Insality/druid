-- Copyright (c) 2023 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Component with event on back and backspace button.
-- # Overview #
--
-- Back Handler is recommended to put in every game window to close it
-- or in main screen to call settings window.
--
-- # Tech Info #
--
-- Back Handler react on release action ACTION_BACK or ACTION_BACKSPACE
--
-- # Notes #
--
-- • Back Handler inheritance @{BaseComponent}, you can use all of its methods in addition to those described here.
-- @usage
-- local callback = function(self, params) ... end
--
-- local params = {}
-- local back_handler = self.druid:new_back_handler(callback, [params])
-- @module BackHandler
-- @within BaseComponent
-- @alias druid.back_handler

--- @{DruidEvent} function(self, [params]) .
--
-- Trigger on input action ACTION_BACK or ACTION_BACKSPACE
-- @usage
-- -- Subscribe additional callbacks:
-- back_handler.on_back:subscribe(callback)
-- @tfield DruidEvent on_back @{DruidEvent}

--- Params to pass in the callback
-- @usage
-- -- Replace params on runtime:
-- back_handler.params = { ... }
-- @tfield[opt] any params

---

local Event = require("druid.event")
local const = require("druid.const")
local component = require("druid.component")

local BackHandler = component.create("back_handler")


--- Component initialize function
-- @tparam BackHandler self @{BackHandler}
-- @tparam callback callback On back button
-- @tparam[opt] any params Callback argument
-- @local
function BackHandler.init(self, callback, params)
	self.params = params
	self.on_back = Event(callback)
end


--- Component input handler
-- @tparam BackHandler self @{BackHandler}
-- @tparam string action_id on_input action id
-- @tparam table action on_input action
-- @local
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
