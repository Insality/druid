-- Copyright (c) 2023 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Component with event on back and backspace button.
-- <b># Overview #</b>
--
-- Back Handler is recommended to put in every game window to close it
-- or in main screen to call settings window.
--
-- <b># Notes #</b>
--
-- • Back Handler inheritance @{BaseComponent}, you can use all of its methods in addition to those described here.
--
-- • Back Handler react on release action ACTION_BACK or ACTION_BACKSPACE
-- @usage
-- local callback = function(self, params) ... end
--
-- local params = {}
-- local back_handler = self.druid:new_back_handler(callback, [params])
-- @module BackHandler
-- @within BaseComponent
-- @alias druid.back_handler

--- The @{DruidEvent} Event on back handler action.
--
-- Trigger on input action ACTION_BACK or ACTION_BACKSPACE
-- @usage
-- -- Subscribe additional callbacks:
-- back_handler.on_back:subscribe(callback)
-- @tfield DruidEvent on_back @{DruidEvent}

--- Custom args to pass in the callback
-- @usage
-- -- Replace params on runtime:
-- back_handler.params = { ... }
-- @tfield[opt] any params

---

local Event = require("druid.event")
local const = require("druid.const")
local component = require("druid.component")

local BackHandler = component.create("back_handler")


--- The @{BackHandler} constructor
-- @tparam BackHandler self @{BackHandler}
-- @tparam callback callback On back button
-- @tparam[opt] any custom_args Button events custom arguments
-- @local
function BackHandler.init(self, callback, custom_args)
	self.params = custom_args
	self.freezed_keyboard_input = false
	self.on_back = Event(callback)
end


--- Component input handler
-- @tparam BackHandler self @{BackHandler}
-- @tparam string action_id on_input action id
-- @tparam table action on_input action
-- @local
function BackHandler.on_input(self, action_id, action)
	if not self.freezed_keyboard_input then	
		if not action.released then
			return false
		end

		if action_id == const.ACTION_BACK or action_id == const.ACTION_BACKSPACE then
			self.on_back:trigger(self:get_context(), self.params)
			return true
		end
	end

	return false
end


function BackHandler.on_freeze_keyboard_input(self)
	self.freezed_keyboard_input = true
end


function BackHandler.on_unfreeze_keyboard_input(self)
	self.freezed_keyboard_input = false
end

return BackHandler
