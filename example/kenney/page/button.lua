local sprite_change_style = {}

local M = {}


local function setup_buttons(self)
	self.druid:new_button("button_usual/button")

	local custom_style = self.druid:new_button("button_custom_style/button")
	custom_style:set_style(sprite_change_style)

	-- HOVER_IMAGE and DEFAULT_IMAGE - from our custom style params
	custom_style.HOVER_IMAGE = "button_yellow"
	custom_style.DEFAULT_IMAGE = "button_blue"
end


function M.setup_page(self)
	setup_buttons(self)
end


return M
