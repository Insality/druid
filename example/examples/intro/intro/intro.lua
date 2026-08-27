local panthera = require("panthera.panthera")
local intro_panthera = require("example.examples.intro.intro.intro_panthera")

---@class examples.intro: druid.widget
---@field root node
---@field animation panthera.animation
local M = {}


function M:init()
	self.root = self:get_node("root")

	self.druid:new_rich_text("text_hello", "He<color=#E48155>ll</color>o!")

	self.druid:new_rich_text("text_description", table.concat({
		"Pick an example on the <color=#E48155>left</color>.",
		"Each example is a GUI file with <color=#E48155>.lua</color> code nearby.",
		"The right panel is a short note and a <color=#A1D7F5>link to the code</color>. Some examples may have <color=#8ED59E>tweak controls</color>.",
	}, "<br/><br/>"))

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

	local click_options = { is_detached = true, is_skip_init = true }
	self.druid:new_button("icon_druid_left", function()
		panthera.play(self.animation, "click_left", click_options)
	end):set_style(nil)
	self.druid:new_button("icon_druid_right", function()
		panthera.play(self.animation, "click_right", click_options)
	end):set_style(nil)
end


function M:open_link(link)
	sys.open_url(link, { target = "_blank" })
end


function M:on_remove()
	panthera.stop(self.animation)
end


return M
