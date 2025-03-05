local M = {}

function M.get_examples()
	---@type druid.example.data[]
	return {
		{
			name_id = "ui_example_data_list_basic",
			information_text_id = "ui_example_data_list_basic_description",
			template = "data_list_basic",
			root = "data_list_basic/root",
			code_url = "example/examples/data_list/basic/data_list_basic.lua",
			component_class = require("example.examples.data_list.basic.data_list_basic"),
			on_create = function(instance, output_list)
				---@cast instance data_list_basic
				instance.on_item_click:subscribe(function(index)
					output_list:add_log_text("Item clicked: " .. index)
				end)
			end,
			properties_control = function(instance, properties_panel)
				---@cast instance data_list_basic

				local view_node = instance.scroll.view_node
				local is_stencil = gui.get_clipping_mode(view_node) == gui.CLIPPING_MODE_STENCIL

				properties_panel:add_checkbox("ui_clipping", is_stencil, function(value)
					gui.set_clipping_mode(view_node, value and gui.CLIPPING_MODE_STENCIL or gui.CLIPPING_MODE_NONE)
				end)

				properties_panel:add_slider("ui_scroll", 0, function(value)
					instance.scroll:scroll_to_percent(vmath.vector3(0, 1 - value, 0), true)
				end)
			end,
			get_debug_info = function(instance)
				---@cast instance data_list_basic
				local data_list = instance.data_list

				local data = data_list:get_data()
				local info = ""
				info = info .. "Data length: " .. #data .. "\n"
				info = info .. "First Visual Index: " .. data_list.top_index .. "\n"
				info = info .. "Last Visual Index: " .. data_list.last_index .. "\n"

				local s = instance.scroll
				info = info .. "\n"
				info = info .. "View Size Y: " .. gui.get(s.view_node, "size.y") .. "\n"
				info = info .. "Content Size Y: " .. gui.get(s.content_node, "size.y") .. "\n"
				info = info .. "Content position Y: " .. math.ceil(s.position.y) .. "\n"
				info = info .. "Content Range Y: " .. s.available_pos.y .. " - " .. s.available_pos.w .. "\n"

				return info
			end
		},

		{
			name_id = "ui_example_data_list_horizontal_basic",
			information_text_id = "ui_example_data_list_horizontal_basic_description",
			template = "data_list_horizontal_basic",
			root = "data_list_horizontal_basic/root",
			code_url = "example/examples/data_list/basic/data_list_horizontal_basic.lua",
			component_class = require("example.examples.data_list.basic.data_list_horizontal_basic"),
			properties_control = function(instance, properties_panel)
				---@cast instance data_list_horizontal_basic

				local view_node = instance.scroll.view_node
				local is_stencil = gui.get_clipping_mode(view_node) == gui.CLIPPING_MODE_STENCIL

				properties_panel:add_checkbox("ui_clipping", is_stencil, function(value)
					gui.set_clipping_mode(view_node, value and gui.CLIPPING_MODE_STENCIL or gui.CLIPPING_MODE_NONE)
				end)
			end,
			get_debug_info = function(instance)
				---@cast instance data_list_horizontal_basic
				local data_list = instance.data_list

				local data = data_list:get_data()
				local info = ""
				info = info .. "Data length: " .. #data .. "\n"
				info = info .. "First Visual Index: " .. data_list.top_index .. "\n"
				info = info .. "Last Visual Index: " .. data_list.last_index .. "\n"

				local s = instance.scroll
				info = info .. "\n"
				info = info .. "View Size X: " .. gui.get(s.view_node, "size.x") .. "\n"
				info = info .. "Content Size X: " .. gui.get(s.content_node, "size.x") .. "\n"
				info = info .. "Content position X: " .. math.ceil(s.position.x) .. "\n"
				info = info .. "Content Range X: " .. s.available_pos.x .. " - " .. s.available_pos.z .. "\n"

				return info
			end
		},

		{
			name_id = "ui_example_data_list_add_remove_clear",
			information_text_id = "ui_example_data_list_add_remove_clear_description",
			template = "data_list_add_remove_clear",
			root = "data_list_add_remove_clear/root",
			code_url = "example/examples/data_list/add_remove_clear/data_list_add_remove_clear.lua",
			component_class = require("example.examples.data_list.add_remove_clear.data_list_add_remove_clear"),
			on_create = function(instance, output_list)
				---@cast instance data_list_add_remove_clear
				instance.on_item_click:subscribe(function(index)
					instance:remove_item(index)
					output_list:add_log_text("Item removed: " .. index)
				end)
			end,
			properties_control = function(instance, properties_panel)
				---@cast instance data_list_add_remove_clear

				local view_node = instance.scroll.view_node
				local is_stencil = gui.get_clipping_mode(view_node) == gui.CLIPPING_MODE_STENCIL

				properties_panel:add_checkbox("ui_clipping", is_stencil, function(value)
					gui.set_clipping_mode(view_node, value and gui.CLIPPING_MODE_STENCIL or gui.CLIPPING_MODE_NONE)
				end)

				properties_panel:add_slider("ui_scroll", 0, function(value)
					instance.scroll:scroll_to_percent(vmath.vector3(0, 1 - value, 0), true)
				end)

				properties_panel:add_button("ui_add_element", function()
					instance:add_item()
				end)

				properties_panel:add_button("ui_remove_element", function()
					instance:remove_item()
				end)

				properties_panel:add_button("ui_clear_elements", function()
					instance.data_list:clear()
				end)
			end,
			get_debug_info = function(instance)
				---@cast instance data_list_add_remove_clear
				local data_list = instance.data_list

				local data = data_list:get_data()
				local info = ""
				info = info .. "Data length: " .. #data .. "\n"
				info = info .. "First Visual Index: " .. data_list.top_index .. "\n"
				info = info .. "Last Visual Index: " .. data_list.last_index .. "\n"

				local s = instance.scroll
				info = info .. "\n"
				info = info .. "View Size X: " .. gui.get(s.view_node, "size.x") .. "\n"
				info = info .. "Content Size X: " .. gui.get(s.content_node, "size.x") .. "\n"
				info = info .. "Content position X: " .. math.ceil(s.position.x) .. "\n"
				info = info .. "Content Range X: " .. s.available_pos.x .. " - " .. s.available_pos.z .. "\n"

				return info
			end
		},

		{
			name_id = "ui_example_data_list_cache_with_component",
			information_text_id = "ui_example_data_list_cache_with_component_description",
			template = "data_list_cache_with_component",
			root = "data_list_cache_with_component/root",
			code_url = "example/examples/data_list/cache_with_component/cache_with_component.lua",
			component_class = require("example.examples.data_list.cache_with_component.cache_with_component"),
			on_create = function(instance, output_list)
				---@cast instance data_list_cache_with_component
				instance.on_item_click:subscribe(function(index)
					output_list:add_log_text("Item clicked: " .. index)
				end)
			end,
			properties_control = function(instance, properties_panel)
				---@cast instance data_list_cache_with_component

				local view_node = instance.scroll.view_node
				local is_stencil = gui.get_clipping_mode(view_node) == gui.CLIPPING_MODE_STENCIL

				properties_panel:add_checkbox("ui_clipping", is_stencil, function(value)
					gui.set_clipping_mode(view_node, value and gui.CLIPPING_MODE_STENCIL or gui.CLIPPING_MODE_NONE)
				end)

				properties_panel:add_slider("ui_scroll", 0, function(value)
					instance.scroll:scroll_to_percent(vmath.vector3(0, 1 - value, 0), true)
				end)
			end,
			get_debug_info = function(instance)
				---@cast instance data_list_cache_with_component
				local data_list = instance.data_list

				local data = data_list:get_data()
				local info = ""
				info = info .. "Data length: " .. #data .. "\n"
				info = info .. "First Visual Index: " .. data_list.top_index .. "\n"
				info = info .. "Last Visual Index: " .. data_list.last_index .. "\n"

				local s = instance.scroll
				info = info .. "\n"
				info = info .. "View Size Y: " .. gui.get(s.view_node, "size.y") .. "\n"
				info = info .. "Content Size Y: " .. gui.get(s.content_node, "size.y") .. "\n"
				info = info .. "Content position Y: " .. math.ceil(s.position.y) .. "\n"
				info = info .. "Content Range Y: " .. s.available_pos.y .. " - " .. s.available_pos.w .. "\n"

				return info
			end
		},
	}
end

return M
