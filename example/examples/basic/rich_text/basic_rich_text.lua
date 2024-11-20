local component = require("druid.component")

---@class basic_rich_text: druid.base_component
---@field druid druid_instance
---@field rich_text druid.rich_text
local M = component.create("basic_rich_text")


---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)
	self.druid:new_rich_text("text", "Hello, I'm a <font=text_bold><color=E48155>Rich Text</font></color>!")
end


return M
