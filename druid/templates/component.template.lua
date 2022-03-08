local component = require("druid.component")

local Component = component.create("component_name")

local SCHEME = {
    ROOT = "root",
    BUTTON = "button",
}


function Component:init(template, nodes)
    self:set_template(template)
    self:set_nodes(nodes)
    self.root = self:get_node(SCHEME.ROOT)
    self.druid = self:get_druid()

    self.button = self.druid:new_button(SCHEME.BUTTON, function() end)
end


function Component:on_remove()
end


return Component
