	local M = {}


local function create_infinity_instance(self, record, index)
	local instance = gui.clone_tree(self.infinity_prefab)
	gui.set_enabled(instance["infinity_prefab"], true)
	gui.set_text(instance["infinity_text"], "Record " .. record)

	local button = self.druid:new_button(instance["infinity_prefab"], function()
		print("Infinity click on", record)
		self.infinity_list:add(self.infinity_list:get_length() + 1)
	end)
	button.on_long_click:subscribe(function()
		-- self.infinity_list:remove_by_data(record)
	end)

	return instance["infinity_prefab"], button
end


local function create_infinity_instance_hor(self, record, index)
	local instance = gui.clone_tree(self.infinity_prefab)
	gui.set_enabled(instance["infinity_prefab"], true)
	gui.set_text(instance["infinity_text"], "Record " .. record)

	local button = self.druid:new_button(instance["infinity_prefab"], function()
		print("Infinity click on", record)
		-- self.infinity_list_hor:remove_by_data(record)
	end)

	return instance["infinity_prefab"], button
end



local function create_infinity_instance_small(self, record, index)
	local instance = gui.clone_tree(self.infinity_prefab_small)
	gui.set_enabled(instance["infinity_prefab_small"], true)
	gui.set_text(instance["infinity_text_3"], record)

	local button = self.druid:new_button(instance["infinity_prefab_small"], function()
		print("Infinity click on", record)
		-- self.infinity_list_small:remove_by_data(record)
	end)
	button:set_click_zone(self.infinity_scroll_3.view_node)

	return instance["infinity_prefab_small"], button
end


local function create_infinity_instance_dynamic(self, record, index)
	local instance = gui.clone_tree(self.infinity_prefab_dynamic)
	gui.set_enabled(instance["infinity_prefab_dynamic"], true)
	gui.set_text(instance["infinity_text_dynamic"], "Record " .. record)

	gui.set_size(instance["infinity_prefab_dynamic"], vmath.vector3(200, 60 + index * 3, 0))
	local button = self.druid:new_button(instance["infinity_prefab_dynamic"], function()
		print("Dynamic click on", record)
		-- self.infinity_list_dynamic:remove_by_data(record)
	end)
	button:set_click_zone(self.infinity_scroll_dynamic.view_node)

	return instance["infinity_prefab_dynamic"], button
end


local function create_infinity_instance_dynamic_hor(self, record, index)
	local instance = gui.clone_tree(self.infinity_prefab_dynamic)
	gui.set_enabled(instance["infinity_prefab_dynamic"], true)
	gui.set_text(instance["infinity_text_dynamic"], "Record " .. record)

	gui.set_size(instance["infinity_prefab_dynamic"], vmath.vector3(150 + 2 * index, 60, 0))
	local button = self.druid:new_button(instance["infinity_prefab_dynamic"], function()
		print("Dynamic click on", record)
		-- self.infinity_list_dynamic_hor:remove_by_data(record)
	end)
	button:set_click_zone(self.infinity_scroll_dynamic_hor.view_node)

	return instance["infinity_prefab_dynamic"], button
end


local function setup_infinity_list(self)
	local data = {}
	for i = 1, 50 do
		table.insert(data, i)
	end

	self.infinity_list = self.druid:new_data_list(self.infinity_scroll, self.infinity_grid, function(record, index)
		-- function should return gui_node, [druid_component]
		local root, button = create_infinity_instance(self, record, index)
		button:set_click_zone(self.infinity_scroll.view_node)
		return root, button
	end):set_data(data)

	self.infinity_list_hor = self.druid:new_data_list(self.infinity_scroll_hor, self.infinity_grid_hor, function(record, index)
		-- function should return gui_node, [druid_component]
		local root, button = create_infinity_instance_hor(self, record, index)
		button:set_click_zone(self.infinity_scroll_hor.view_node)
		return root, button
	end):set_data(data)

	-- scroll to some index
	-- local pos = self.infinity_grid:get_pos(25)
	-- self.infinity_scroll:scroll_to(pos, true)
	timer.delay(1, false, function()
		self.infinity_list:scroll_to_index(25)
	end)


	self.infinity_list_small = self.druid:new_data_list(self.infinity_scroll_3, self.infinity_grid_3, function(record, index)
		-- function should return gui_node, [druid_component]
		return create_infinity_instance_small(self, record, index)
	end):set_data(data)

	self.infinity_list_dynamic = self.druid:new_data_list(self.infinity_scroll_dynamic, self.infinity_grid_dynamic, function(record, index)
		-- function should return gui_node, [druid_component]
		return create_infinity_instance_dynamic(self, record, index)
	end):set_data(data)

	timer.delay(1, false, function()
		self.infinity_list_dynamic:scroll_to_index(25)
	end)

	self.infinity_list_dynamic_hor = self.druid:new_data_list(self.infinity_scroll_dynamic_hor, self.infinity_grid_dynamic_hor, function(record, index)
		-- function should return gui_node, [druid_component]
		return create_infinity_instance_dynamic_hor(self, record, index)
	end):set_data(data)
end


local function toggle_stencil(self)
	self._is_stencil = not self._is_stencil
	local mode = self._is_stencil and gui.CLIPPING_MODE_STENCIL or gui.CLIPPING_MODE_NONE
	gui.set_clipping_mode(self.infinity_scroll.view_node, mode)
	gui.set_clipping_mode(self.infinity_scroll_hor.view_node, mode)
	gui.set_clipping_mode(self.infinity_scroll_3.view_node, mode)
	gui.set_clipping_mode(self.infinity_scroll_dynamic.view_node, mode)
	gui.set_clipping_mode(self.infinity_scroll_dynamic_hor.view_node, mode)
end


function M.setup_page(self)
	self.druid:new_scroll("infinity_page", "infinity_page_content")

	self.infinity_prefab = gui.get_node("infinity_prefab")
	self.infinity_prefab_small = gui.get_node("infinity_prefab_small")
	self.infinity_prefab_dynamic = gui.get_node("infinity_prefab_dynamic")
	gui.set_enabled(self.infinity_prefab, false)
	gui.set_enabled(self.infinity_prefab_small, false)
	gui.set_enabled(self.infinity_prefab_dynamic, false)

	self.infinity_scroll = self.druid:new_scroll("infinity_scroll_stencil", "infinity_scroll_content")
		:set_horizontal_scroll(false)
	self.infinity_grid = self.druid:new_static_grid("infinity_scroll_content", "infinity_prefab", 1)

	self.infinity_scroll_hor = self.druid:new_scroll("infinity_scroll_stencil_hor", "infinity_scroll_content_hor")
		:set_vertical_scroll(false)
	self.infinity_grid_hor = self.druid:new_static_grid("infinity_scroll_content_hor", "infinity_prefab", 999)

	self.infinity_scroll_3 = self.druid:new_scroll("infinity_scroll_3_stencil", "infinity_scroll_3_content")
		:set_horizontal_scroll(false)
	self.infinity_grid_3 = self.druid:new_static_grid("infinity_scroll_3_content", "infinity_prefab_small", 3)

	self.infinity_scroll_dynamic = self.druid:new_scroll("infinity_scroll_stencil_dynamic", "infinity_scroll_content_dynamic")
		:set_horizontal_scroll(false)
	self.infinity_grid_dynamic = self.druid:new_dynamic_grid("infinity_scroll_content_dynamic")

	self.infinity_scroll_dynamic_hor = self.druid:new_scroll("infinity_scroll_stencil_dynamic_hor", "infinity_scroll_content_dynamic_hor")
		:set_vertical_scroll(false)
	self.infinity_grid_dynamic_hor = self.druid:new_dynamic_grid("infinity_scroll_content_dynamic_hor")

	self._is_stencil = true
	self.druid:new_button("button_toggle_stencil/button", toggle_stencil)

	setup_infinity_list(self)
end


return M
