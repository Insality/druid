local component = require("druid.component")

local InnerButton = require("example.examples.system.inner_templates.inner_button")

---@class inner_panel : druid.base_component
local InnerPanel = component.create("inner_panel")

local SCHEME = {
	ROOT = "root",
	BACKGROUND = "background",
	INNER_BUTTON_1 = "inner_button_1",
	INNER_BUTTON_2 = "inner_button_2",
	INNER_BUTTON_PREFAB = "inner_button_prefab",
	INNER_BUTTON_PREFAB_ROOT = "inner_button_prefab/root",
}


function InnerPanel:init(template, nodes)
    self:set_template(template)
    self:set_nodes(nodes)
    self.root = self:get_node(SCHEME.ROOT)
    self.druid = self:get_druid()

    self.button1 = self.druid:new(InnerButton, SCHEME.INNER_BUTTON_1, nodes)
    self.button2 = self.druid:new(InnerButton, SCHEME.INNER_BUTTON_2, nodes)

    local prefab = self:get_node(SCHEME.INNER_BUTTON_PREFAB_ROOT)
    local button_nodes = gui.clone_tree(prefab)
    self.button3 = self.druid:new(InnerButton, SCHEME.INNER_BUTTON_PREFAB, button_nodes)

    gui.set_enabled(prefab, false)
end


function InnerPanel:on_remove()
end


return InnerPanel
