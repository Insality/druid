--- For component interest functions
--- see https://github.com/Insality/druid/blob/develop/docs_md/02-creating_custom_components.md
--- Require this component in you gui file:
--- local {COMPONENT_NAME} = require("{COMPONENT_PATH}")
--- And create this component via:
--- self.{COMPONENT_TYPE} = self.druid:new({COMPONENT_NAME}, template, nodes)

local component = require("druid.component")

---@class {COMPONENT_TYPE}: druid.base_component{COMPONENT_ANNOTATIONS}
local {COMPONENT_NAME} = component.create("{COMPONENT_TYPE}")

local SCHEME = {
{SCHEME_LIST}
}
{COMPONENT_FUNCTIONS}
---@param template string
---@param nodes table<hash, node>
function {COMPONENT_NAME}:init(template, nodes)
	self:set_template(template)
	self:set_nodes(nodes)
	self.root = self:get_node(SCHEME.ROOT)
	self.druid = self:get_druid(){COMPONENT_DEFINE}
end


function {COMPONENT_NAME}:on_remove()
end


return {COMPONENT_NAME}
