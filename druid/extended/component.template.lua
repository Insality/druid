local const = require("druid.const")
local component = require("druid.component")

local M = component.create("my_component_name", { const.ON_UPDATE })


-- Component constructor
function M.init(self, ...)
end


-- Call only if exist interest: const.ON_UPDATE
function M.update(self, dt)
end


-- Call only if exist interest: const.ON_INPUT or const.ON_INPUT_HIGH
function M.on_input(self, action_id, action)
	return false
end


-- Call on component creation and on component:set_style() function
function M.on_style_change(self, style)
end


-- Call only if exist interest: const.ON_MESSAGE
function M.on_message(self, message_id, message, sender)
end


-- Call only if component with ON_LANGUAGE_CHANGE interest
function M.on_language_change(self)
end


-- Call only if component with ON_LAYOUT_CHANGE interest
function M.on_layout_change(self)
end


-- Call, if input was capturing before this component
-- Example: scroll is start scrolling, so you need unhover button
function M.on_input_interrupt(self)
end


-- Call, if game lost focus. Need ON_FOCUS_LOST intereset
function M.on_focus_lost(self)
end


-- Call, if game gained focus. Need ON_FOCUS_GAINED intereset
function M.on_focus_gained(self)
end


-- Call on component remove or on druid:final
function M.on_remove(self)
end


return M
