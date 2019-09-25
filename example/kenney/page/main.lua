local M = {}

local function empty_callback(self, param)
	print("Empty callback. Param", param)
end


local function random_progress(progress, text)
	local rnd = math.random()

	gui.set_text(text, math.ceil(rnd * 100))
	progress:to(rnd)
end


function M.setup_page(self)
	self.druid:new_button("button_simple", empty_callback, "button_param")

	self.druid:new_button("button_template/button", empty_callback, "button_param")


	local progress = self.druid:new_progress("progress_fill", "x", 0.4)
	random_progress(progress, gui.get_node("text_progress"))
	timer.delay(2, true, function()
		random_progress(progress, gui.get_node("text_progress"))
	end)


	local grid = self.druid:new_grid("grid", "button_template/button", 3)

	for i = 1, 12 do
		local nodes = gui.clone_tree(gui.get_node("button_template/button"))

		local root = nodes["button_template/button"]
		self.druid:new_button(root, empty_callback, "Grid"..i)
		self.druid:new_text(nodes["button_template/text"], "Grid"..i)
		grid:add(root)
	end


	self.timer = self.druid:new_timer("text_timer", 120, 0, empty_callback)

	self.scroll = self.druid:new_scroll("scroll_content", "main_page", vmath.vector4(0, 0, 0, 200))
end


return M
