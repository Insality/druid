--- For component interest functions
--- see https://github.com/Insality/druid/blob/develop/docs_md/02-creating_custom_components.md

local component = require("druid.component")

---@class {COMPONENT_TYPE} : druid.base_component
local {COMPONENT_NAME} = component.create("{COMPONENT_TYPE}")

local SCHEME = {
{SCHEME_LIST}
}


--- Create this component via druid:new({COMPONENT_NAME}, template, nodes)
---@param template string
---@param nodes table<hash, node>
function {COMPONENT_NAME}:init(template, nodes)
    self:set_template(template)
    self:set_nodes(nodes)
    self.root = self:get_node(SCHEME.ROOT)
    self.druid = self:get_druid()
end


function {COMPONENT_NAME}:on_remove()
end


return {COMPONENT_NAME}
