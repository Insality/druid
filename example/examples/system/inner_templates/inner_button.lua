local component = require("druid.component")

---@class inner_button : druid.base_component
local InnerButton = component.create("inner_button")

local SCHEME = {
	ROOT = "root",
	BUTTON = "button",
	TEXT = "text",
}


function InnerButton:init(template, nodes)
    self:set_template(template)
    self:set_nodes(nodes)
    self.root = self:get_node(SCHEME.ROOT)
    self.druid = self:get_druid()

    local value = math.random(0, 99)
    self.button = self.druid:new_button(SCHEME.BUTTON, function() print(value) end)
    self.text = self.druid:new_text(SCHEME.TEXT, value)
end


return InnerButton
