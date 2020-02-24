local sprite_change_style = {}

local M = {}


local function usual_callback()
	print("Usual callback")
end

local function long_tap_callback()
	print("Long tap callback")
end

local function repeated_callback(self, params, button)
	print("Repeated callback", button.click_in_row)
end

local function double_tap_callback(self, params, button)
	print("Double tap callback", button.click_in_row)
end


local function setup_buttons(self)
	self.druid:new_button("button_usual/button", usual_callback)

	local custom_style = self.druid:new_button("button_custom_style/button", usual_callback)
	custom_style:set_style(sprite_change_style)
	-- HOVER_IMAGE and DEFAULT_IMAGE - from our custom style params
	custom_style.HOVER_IMAGE = "button_yellow"
	custom_style.DEFAULT_IMAGE = "button_blue"


	self.druid:new_button("button_long_tap/button", usual_callback)
		.on_long_click:subscribe(long_tap_callback)
	self.druid:new_button("button_repeated_tap/button", usual_callback)
		.on_repeated_click:subscribe(repeated_callback)
	self.druid:new_button("button_double_tap/button", usual_callback)
		.on_double_click:subscribe(double_tap_callback)
end


function M.setup_page(self)
	setup_buttons(self)
end


return M
