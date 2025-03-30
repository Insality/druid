---@class examples.basic_rich_text: druid.widget
---@field rich_text druid.rich_text
local M = {}


function M:init()
	self.druid:new_rich_text("text", "Hello, I'm a <font=text_bold><color=E48155>Rich Text</font></color>!")
end


return M
