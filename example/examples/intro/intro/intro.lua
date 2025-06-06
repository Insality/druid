local panthera = require("panthera.panthera")
local intro_panthera = require("example.examples.intro.intro.intro_panthera")

---@class examples.intro: druid.widget
---@field root node
---@field animation panthera.animation
local M = {}


function M:init()
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

	self.animation = panthera.create_gui(intro_panthera, self:get_template(), self:get_nodes())
	panthera.play(self.animation, "idle", { is_loop = true })
end


function M:open_link(link)
	sys.open_url(link, { target = "_blank" })
end


function M:on_remove()
	panthera.stop(self.animation)
end


return M
