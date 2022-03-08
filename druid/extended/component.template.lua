-- Copyright (c) 2021 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Druid component template
-- @module druid.component
-- @local
local component = require("druid.component")

local Component = component.create("my_component_name")


-- Component constructor
function Component:init(...)
end


-- [OPTIONAL] Call every update step
function Component:update(dt)
end


-- [OPTIONAL] Call default on_input from gui script
function Component:on_input(action_id, action)
	return false
end


-- [OPTIONAL] Call on component creation and on component:set_style() function
function Component:on_style_change(style)
end


-- [OPTIONAL] Call default on_message from gui script
function Component:on_message(message_id, message, sender)
end


-- [OPTIONAL] Call if druid has triggered on_language_change
function Component:on_language_change()
end


-- [OPTIONAL] Call if game layout has changed and need to restore values in component
function Component:on_layout_change()
end


-- [OPTIONAL] Call, if input was capturing before this component
-- Example: scroll is start scrolling, so you need unhover button
function Component:on_input_interrupt()
end


-- [OPTIONAL] Call, if game lost focus
function Component:on_focus_lost()
end


-- [OPTIONAL] Call, if game gained focus
function Component:on_focus_gained()
end


-- [OPTIONAL] Call on component remove or on druid:final
function Component:on_remove()
end


return Component
