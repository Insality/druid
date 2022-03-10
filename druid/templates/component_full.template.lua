local component = require("druid.component")

---@class component_name : druid.base_component
local Component = component.create("component_name")

-- Scheme of component gui nodes
local SCHEME = {
	ROOT = "root",
	BUTTON = "button",
}


-- Component constructor
function Component:init(template, nodes)
	-- If your component is gui template, pass the template name and set it
	self:set_template(template)

	-- If your component is cloned my gui.clone_tree, pass nodes to component and set it
	self:set_nodes(nodes)

	-- self:get_node will auto process component template and nodes
	self.root = self:get_node(SCHEME.ROOT)

	-- Use inner druid instance to create components inside this component
	self.druid = self:get_druid()
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
