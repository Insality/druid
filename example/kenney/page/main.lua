local M = {}

local function empty_callback(self, param)
	print("Empty callback. Param", param)
end


local function random_progress(progress, text)
	local rnd = math.random()

	gui.set_text(text, math.ceil(rnd * 100))
	progress:to(rnd)
end


local function setup_button(self)
	self.druid:new_button("button_simple", empty_callback, "button_param")
	self.druid:new_button("button_template/button", empty_callback, "button_param")
end


local function setup_progress(self)
	local progress = self.druid:new_progress("progress_fill", "x", 0.4)
	random_progress(progress, gui.get_node("text_progress"))
	timer.delay(2, true, function()
		random_progress(progress, gui.get_node("text_progress"))
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


local function setup_timer(self)
	self.timer = self.druid:new_timer("text_timer", 120, 0, empty_callback)
end


local function setup_scroll(self)
	self.scroll = self.druid:new_scroll("scroll_content", "main_page", vmath.vector4(0, 0, 0, 200))
end


local function setup_back_handler(self)
	self.druid:new_back_handler(empty_callback, "back button")
end



function M.setup_page(self)
	setup_button(self)
	setup_progress(self)
	setup_grid(self)
	setup_timer(self)
	setup_scroll(self)
	setup_back_handler(self)
end


return M
