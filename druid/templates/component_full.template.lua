local component = require("druid.component")

---@class new_component: druid.component
local M = component.create("new_component")

-- Component constructor. Template name and nodes are optional. Pass it if you use it in your component
function M:init(template, nodes)
	-- If your component is gui template, pass the template name and set it
	-- If your component is cloned my gui.clone_tree, pass nodes to component and set it
	-- Use inner druid instance to create components inside this component
	self.druid = self:get_druid(template, nodes)

	-- self:get_node will auto process component template and nodes
	self.root = self:get_node("root")

end


-- [OPTIONAL] Call every update step
function M:update(dt)
end


-- [OPTIONAL] Call default on_input from gui script
function M:on_input(action_id, action)
	return false
end


-- [OPTIONAL] Call on component creation and on component:set_style() function
function M:on_style_change(style)
end


-- [OPTIONAL] Call default on_message from gui script
function M:on_message(message_id, message, sender)
end


-- [OPTIONAL] Call if druid has triggered on_language_change
function M:on_language_change()
end


-- [OPTIONAL] Call if game layout has changed and need to restore values in component
function M:on_layout_change()
end


-- [OPTIONAL] Call, if input was capturing before this component
-- Example: scroll is start scrolling, so you need unhover button
function M:on_input_interrupt()
end


-- [OPTIONAL] Call, if game lost focus
function M:on_focus_lost()
end


-- [OPTIONAL] Call, if game gained focus
function M:on_focus_gained()
end


-- [OPTIONAL] Call on component remove or on druid:final
function M:on_remove()
end


return M
