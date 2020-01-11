local lang = require("example.kenney.lang")

local M = {}


local function empty_callback(self, param)
	print("Empty callback. Param", param)
end


local function random_progress(progress, text)
	local rnd = math.random()

	gui.set_text(text, math.ceil(rnd * 100) .. "%")
	progress:to(rnd)
end


local function setup_button(self)
	local b = self.druid:new_button("button_simple", lang.toggle_locale, "button_param")
	self.druid:new_button("button_template/button", function()
		print(b:get_enabled())
		b:set_enabled(not b:get_enabled())
	end, "button_param")
end


local function setup_texts(self)
	self.druid:new_locale("text_button", "ui_section_button")
	self.druid:new_locale("text_text", "ui_section_text")
	self.druid:new_locale("text_timer", "ui_section_timer")
	self.druid:new_locale("text_progress", "ui_section_progress")
	self.druid:new_locale("text_slider", "ui_section_slider")
	self.druid:new_locale("text_radio", "ui_section_radio")
	self.druid:new_locale("text_checkbox", "ui_section_checkbox")

	self.druid:new_locale("text_translated", "ui_text_example")
	self.druid:new_locale("text_button_lang", "ui_text_change_lang")
	self.druid:new_text("text_simple", "Simple")
end


local function setup_progress(self)
	self.progress = self.druid:new_progress("progress_fill", "x", 0.4)
	random_progress(self.progress, gui.get_node("text_progress"))
	timer.delay(2, true, function()
		random_progress(self.progress, gui.get_node("text_progress_amount"))
	end)
end


local function setup_grid(self)
	local grid = self.druid:new_grid("grid", "button_template/button", 3)

	for i = 1, 12 do
		local nodes = gui.clone_tree(gui.get_node("button_template/button"))

		local root = nodes["button_template/button"]
		self.druid:new_button(root, function(context, param)
			grid:set_offset(vmath.vector3(param))
		end, i)
		self.druid:new_text(nodes["button_template/text"], "Grid"..i)
		grid:add(root)
	end
end


local function setup_slider(self)
	local slider = self.druid:new_slider("slider_pin", vmath.vector3(95, 0, 0), function(_, value)
		gui.set_text(gui.get_node("text_progress_slider"), math.ceil(value * 100) .. "%")
	end)

	slider:set(0.2)
end


local function setup_checkbox(self)
	local radio_group = self.druid:new_radio_group(
		{"radio1/check", "radio2/check", "radio3/check"},
		nil,
		{"radio1/back", "radio2/back", "radio3/back"})

	local checkbox_group = self.druid:new_checkbox_group(
		{"checkbox1/check", "checkbox2/check", "checkbox3/check"},
		nil,
		{"checkbox1/back", "checkbox2/back", "checkbox3/back"})

	radio_group:set_state(2)
	checkbox_group:set_state({true, false, true})
end


local function setup_timer(self)
	self.timer = self.druid:new_timer("timer", 300, 0, empty_callback)
end


local function setup_scroll(self)
	self.scroll = self.druid:new_scroll("scroll_content", "main_page", vmath.vector4(0, 0, 0, 200))
end


local function setup_back_handler(self)
	self.druid:new_back_handler(empty_callback, "back button")
end



function M.setup_page(self)
	setup_texts(self)

	setup_button(self)
	setup_progress(self)
	setup_grid(self)
	setup_timer(self)
	setup_checkbox(self)
	setup_scroll(self)
	setup_slider(self)
	setup_back_handler(self)
end


return M
