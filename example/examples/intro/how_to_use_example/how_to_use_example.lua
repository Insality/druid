local component = require("druid.component")
local panthera = require("panthera.panthera")

---@class how_to_use_example: druid.component
---@field root node
local M = component.create("how_to_use_example")

---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)
	self.root = self:get_node("root")

	self.druid:new_rich_text("text_hello", "He<color=#E48155>ll</color>o!")

	self.druid:new_button("sponsor_github", self.open_link, "https://github.com/sponsors/insality")
	self.druid:new_button("sponsor_coffee", self.open_link, "https://www.buymeacoffee.com/insality")
	self.druid:new_button("sponsor_kofi", self.open_link, "https://ko-fi.com/insality")

	self.druid:new_layout("sponsor")
		:add("sponsor_github")
		:add("sponsor_coffee")
		:add("sponsor_kofi")
		:set_margin(8, 0)
end


function M:open_link(link)
	sys.open_url(link, { target = "_blank" })
end


return M
