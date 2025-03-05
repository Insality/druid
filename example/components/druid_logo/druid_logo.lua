local panthera = require("panthera.panthera")
local component = require("druid.component")

local druid_logo_panthera = require("example.components.druid_logo.druid_logo_panthera")

---@class druid_logo: druid.component
---@field root druid.container
---@field text_description druid.text
---@field druid druid.instance
local DruidLogo = component.create("druid_logo")


---@param template string
---@param nodes table<hash, node>
function DruidLogo:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.root = self.druid:new_container("root") --[[@as druid.container]]
	self.root:add_container("E_Anchor")
	self.root:add_container("W_Anchor")

	self.druid:new_button("root", self.on_click):set_style(nil)

	self.animation = panthera.create_gui(druid_logo_panthera, self:get_template(), nodes)
	panthera.play(self.animation, "idle", { is_loop = true })

	self.animation_hover = panthera.clone_state(self.animation)
	self.hover = self.druid:new_hover("root")
	self.hover.on_mouse_hover:subscribe(self.on_mouse_hover)
end


function DruidLogo:on_click()
	sys.open_url("https://github.com/Insality/druid", { target = "_blank" })
end


function DruidLogo:on_mouse_hover(is_hover)
	if is_hover then
		panthera.play(self.animation_hover, "on_hover_in")
	else
		panthera.play(self.animation_hover, "on_hover_out", { is_skip_init = true })
	end
end


return DruidLogo
