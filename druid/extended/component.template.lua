--- Druid component template
-- @module druid.component
-- @local
local component = require("druid.component")

local Component = component.create("my_component_name", { component.ON_UPDATE })


-- Component constructor
function Component:init(...)
end


-- Call only if exist interest: component.ON_UPDATE
function Component:update(dt)
end


-- Call only if exist interest: component.ON_INPUT
function Component:on_input(action_id, action)
	return false
end


-- Call on component creation and on component:set_style() function
function Component:on_style_change(style)
end


-- Call only if exist interest: component.ON_MESSAGE
function Component:on_message(message_id, message, sender)
end


-- Call only if component with ON_LANGUAGE_CHANGE interest
function Component:on_language_change()
end


-- Call only if component with ON_LAYOUT_CHANGE interest
function Component:on_layout_change()
end


-- Call, if input was capturing before this component
-- Example: scroll is start scrolling, so you need unhover button
function Component:on_input_interrupt()
end


-- Call, if game lost focus. Need ON_FOCUS_LOST intereset
function Component:on_focus_lost()
end


-- Call, if game gained focus. Need ON_FOCUS_GAINED intereset
function Component:on_focus_gained()
end


-- Call on component remove or on druid:final
function Component:on_remove()
end


return Component
