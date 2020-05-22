local sprite_style = require("druid.styles.sprites.style")

local M = {}


local function usual_callback()
	print("Usual callback")
end

local function long_tap_callback(self, params, button, hold_time)
	print("Long tap callback", hold_time)
end

local function hold_callback(self, params, button, hold_time)
	print("On hold callback", hold_time)
end

local function repeated_callback(self, params, button, click_in_row)
	print("Repeated callback", click_in_row)
end

local function double_tap_callback(self, params, button, click_in_row)
	print("Double tap callback", click_in_row)
end


local function setup_buttons(self)
	self.druid:new_button("button_usual/button", usual_callback)

	local custom_style = self.druid:new_button("button_custom_style/button", usual_callback)
	custom_style:set_style(sprite_style)

	local long_button = self.druid:new_button("button_long_tap/button", usual_callback)
	long_button.on_hold_callback:subscribe(hold_callback)
	long_button.on_long_click:subscribe(long_tap_callback)
	self.druid:new_button("button_repeated_tap/button", usual_callback)
		.on_repeated_click:subscribe(repeated_callback)
	self.druid:new_button("button_double_tap/button", usual_callback)
		.on_double_click:subscribe(double_tap_callback)

	local button_space = self.druid:new_button("button_key_trigger/button", usual_callback)
	button_space:set_key_trigger("key_space")
	button_space.on_long_click:subscribe(long_tap_callback)
	button_space.on_double_click:subscribe(double_tap_callback)

	local button_shift_enter = self.druid:new_button("button_combo_key_trigger/button", usual_callback)
	button_shift_enter:set_key_combo_trigger("key_lshift", "key_enter")
	button_shift_enter.on_double_click:subscribe(double_tap_callback)

	-- Button with another node for animating
	self.druid:new_button("button_anim/button", usual_callback, nil, "anim_node_icon")
end


function M.setup_page(self)
	setup_buttons(self)
end


return M
