local const = require("druid.const")
local helper = require("druid.helper")
local M = {}

function M.get_examples()
	---@type druid.example.data[]
	return {
		{
			name_id = "ui_example_basic_button",
			information_text_id = "ui_example_basic_button_description",
			template = "basic_button",
			root = "basic_button/root",
			code_url = "example/examples/basic/button/basic_button.lua",
			widget_class = require("example.examples.basic.button.basic_button"),
			properties_control = function(instance, properties_panel)
				---@cast instance examples.basic_button

				local checkbox = properties_panel:add_checkbox("ui_enabled", false, function(value)
					instance.button:set_enabled(value)
				end)
				checkbox:set_value(true)
			end,
			on_create = function(instance, output_log)
				---@cast instance examples.basic_button
				instance.button.on_click:subscribe(function()
					output_log:add_log_text("Button Clicked")
				end)
			end,
		},
		{
			name_id = "ui_example_basic_button_double_click",
			information_text_id = "ui_example_basic_button_double_click_description",
			template = "basic_button_double_click",
			root = "basic_button_double_click/root",
			code_url = "example/examples/basic/button/basic_button_double_click.lua",
			widget_class = require("example.examples.basic.button.basic_button_double_click"),
			on_create = function(instance, output_log)
				---@cast instance examples.basic_button_double_click
				instance.button.on_click:subscribe(function()
					output_log:add_log_text("Clicked")
				end)
				instance.button.on_double_click:subscribe(function()
					output_log:add_log_text("Double Clicked")
				end)
			end,
		},
		{
			name_id = "ui_example_basic_button_hold",
			information_text_id = "ui_example_basic_button_hold_description",
			template = "basic_button_hold",
			root = "basic_button_hold/root",
			code_url = "example/examples/basic/button/basic_button_hold.lua",
			widget_class = require("example.examples.basic.button.basic_button_hold"),
			on_create = function(instance, output_log)
				---@cast instance examples.basic_button_hold
				instance.button.on_click:subscribe(function()
					output_log:add_log_text("Clicked")
				end)
				instance.button.on_long_click:subscribe(function()
					output_log:add_log_text("On long click")
				end)
			end,
		},
		{
			name_id = "ui_example_basic_text",
			information_text_id = "ui_example_basic_text_description",
			template = "basic_text",
			root = "basic_text/root",
			code_url = "example/examples/basic/text/basic_text.lua",
			widget_class = require("example.examples.basic.text.basic_text"),
			properties_control = function(instance, properties_panel)
				---@cast instance examples.basic_text

				local adjust_index = 1
				local adjust_types = {
					"downscale",
					"downscale_limited",
					--"scale_then_scroll", -- works bad with container for some reason
					--"scroll", -- works bad with container for some reason
					"trim",
				}
				properties_panel:add_button("ui_adjust_next", function()
					adjust_index = adjust_index + 1
					if adjust_index > #adjust_types then
						adjust_index = 1
					end
					instance.text:set_text_adjust(adjust_types[adjust_index], 0.5)
				end)

				local pivot_index = 1
				local pivot_list = {
					gui.PIVOT_CENTER,
					gui.PIVOT_W,
					gui.PIVOT_SW,
					gui.PIVOT_S,
					gui.PIVOT_SE,
					gui.PIVOT_E,
					gui.PIVOT_NE,
					gui.PIVOT_N,
					gui.PIVOT_NW,
				}

				---@cast instance examples.rich_text_tags
				properties_panel:add_button("ui_pivot_next", function()
					pivot_index = pivot_index + 1
					if pivot_index > #pivot_list then
						pivot_index = 1
					end
					instance:set_pivot(pivot_list[pivot_index])
				end)
			end,
			get_debug_info = function(instance)
				---@cast instance examples.multiline_text
				local info = ""

				info = info .. "Text Adjust: " .. instance.text.adjust_type .. "\n"
				info = info .. "Pivot: " .. gui.get_pivot(instance.text.node) .. "\n"

				return info
			end
		},
		{
			name_id = "ui_example_basic_multiline_text",
			information_text_id = "ui_example_basic_multiline_text_description",
			template = "multiline_text",
			root = "multiline_text/root",
			code_url = "example/examples/basic/text/multiline_text.lua",
			widget_class = require("example.examples.basic.text.multiline_text"),
			properties_control = function(instance, properties_panel)
				---@cast instance examples.multiline_text

				local adjust_index = 1
				local adjust_types = {
					"downscale",
					"downscale_limited",
					--"scale_then_scroll", -- works bad with container for some reason
					--"scroll", -- works bad with container for some reason
					"trim",
				}
				properties_panel:add_button("ui_adjust_next", function()
					adjust_index = adjust_index + 1
					if adjust_index > #adjust_types then
						adjust_index = 1
					end
					instance.text:set_text_adjust(adjust_types[adjust_index], 0.8)
				end)

				local pivot_index = 1
				local pivot_list = {
					gui.PIVOT_CENTER,
					gui.PIVOT_W,
					gui.PIVOT_SW,
					gui.PIVOT_S,
					gui.PIVOT_SE,
					gui.PIVOT_E,
					gui.PIVOT_NE,
					gui.PIVOT_N,
					gui.PIVOT_NW,
				}

				properties_panel:add_button("ui_pivot_next", function()
					pivot_index = pivot_index + 1
					if pivot_index > #pivot_list then
						pivot_index = 1
					end
					instance:set_pivot(pivot_list[pivot_index])
				end)
			end,
			get_debug_info = function(instance)
				---@cast instance examples.multiline_text
				local info = ""

				info = info .. "Text Adjust: " .. instance.text.adjust_type .. "\n"
				info = info .. "Pivot: " .. gui.get_pivot(instance.text.node) .. "\n"

				return info
			end
		},
		{
			name_id = "ui_example_basic_hover",
			information_text_id = "ui_example_basic_hover_description",
			template = "hover",
			root = "hover/root",
			code_url = "example/examples/basic/hover/hover.lua",
			widget_class = require("example.examples.basic.hover.hover"),
		},
		{
			name_id = "ui_example_basic_drag",
			information_text_id = "ui_example_basic_drag_description",
			template = "drag",
			root = "drag/root",
			code_url = "example/examples/basic/drag/drag.lua",
			widget_class = require("example.examples.basic.drag.drag"),
		},
		{
			name_id = "ui_example_basic_drag_to_node",
			information_text_id = "ui_example_basic_drag_to_node_description",
			template = "drag_to_node",
			root = "drag_to_node/root",
			code_url = "example/examples/basic/drag/drag_to_node.lua",
			widget_class = require("example.examples.basic.drag.drag_to_node"),
		},
		{
			name_id = "ui_example_basic_slider",
			information_text_id = "ui_example_basic_slider_description",
			template = "basic_slider",
			root = "basic_slider/root",
			code_url = "example/examples/basic/slider/basic_slider.lua",
			widget_class = require("example.examples.basic.slider.basic_slider"),
			on_create = function(instance, output_log)
				---@cast instance examples.basic_slider
				instance.slider.on_change_value:subscribe(function(_, value)
					local value = helper.round(value, 2)
					output_log:add_log_text("Slider Value: " .. value)
				end)
			end,
		},
		{
			name_id = "ui_example_basic_slider_vertical",
			information_text_id = "ui_example_basic_slider_vertical_description",
			template = "basic_slider_vertical",
			root = "basic_slider_vertical/root",
			code_url = "example/examples/basic/slider/basic_slider_vertical.lua",
			widget_class = require("example.examples.basic.slider.basic_slider_vertical"),
			on_create = function(instance, output_log)
				---@cast instance examples.basic_slider_vertical
				instance.slider.on_change_value:subscribe(function(_, value)
					local value = helper.round(value, 2)
					output_log:add_log_text("Slider Value: " .. value)
				end)
			end,
		},
		{
			name_id = "ui_example_basic_slider_stepped",
			information_text_id = "ui_example_basic_slider_stepped_description",
			template = "basic_slider_stepped",
			root = "basic_slider_stepped/root",
			code_url = "example/examples/basic/slider/basic_slider_stepped.lua",
			widget_class = require("example.examples.basic.slider.basic_slider_stepped"),
			on_create = function(instance, output_log)
				---@cast instance examples.basic_slider_stepped
				instance.slider.on_change_value:subscribe(function(_, value)
					local value = helper.round(value, 2)
					output_log:add_log_text("Slider Value: " .. value)
				end)
			end,
		},
		{
			name_id = "ui_example_basic_progress_bar",
			information_text_id = "ui_example_basic_progress_bar_description",
			template = "basic_progress_bar",
			root = "basic_progress_bar/root",
			code_url = "example/examples/basic/progress_bar/basic_progress_bar.lua",
			widget_class = require("example.examples.basic.progress_bar.basic_progress_bar"),
			properties_control = function(instance, properties_panel)
				---@cast instance examples.basic_progress_bar
				properties_panel:add_slider("ui_value", 1, function(value)
					instance:set_value(value)
				end)
			end,
		},
		{
			name_id = "ui_example_basic_progress_bar_slice9",
			information_text_id = "ui_example_basic_progress_bar_slice9_description",
			template = "basic_progress_bar_slice9",
			root = "basic_progress_bar_slice9/root",
			code_url = "example/examples/basic/progress_bar/basic_progress_bar_slice9.lua",
			widget_class = require("example.examples.basic.progress_bar.basic_progress_bar_slice9"),
			properties_control = function(instance, properties_panel)
				---@cast instance examples.basic_progress_bar_slice9
				properties_panel:add_slider("ui_value", 1, function(value)
					instance:set_value(value)
				end)
			end,
		},
		{
			name_id = "ui_example_basic_blocker",
			information_text_id = "ui_example_basic_blocker_description",
			template = "basic_blocker",
			root = "basic_blocker/root",
			code_url = "example/examples/basic/blocker/basic_blocker.lua",
			widget_class = require("example.examples.basic.blocker.basic_blocker"),
			on_create = function(instance, output_log)
				---@cast instance examples.basic_blocker
				instance.button_root.on_click:subscribe(function()
					output_log:add_log_text("Root Clicked")
				end)
				instance.button.on_click:subscribe(function()
					output_log:add_log_text("Button Clicked")
				end)
			end,
		},
		{
			name_id = "ui_example_basic_back_handler",
			information_text_id = "ui_example_basic_back_handler_description",
			template = "basic_back_handler",
			root = "basic_back_handler/root",
			code_url = "example/examples/basic/back_handler/basic_back_handler.lua",
			widget_class = require("example.examples.basic.back_handler.basic_back_handler"),
		},
		{
			name_id = "ui_example_basic_timer",
			information_text_id = "ui_example_basic_timer_description",
			template = "basic_timer",
			root = "basic_timer/root",
			code_url = "example/examples/basic/timer/basic_timer.lua",
			widget_class = require("example.examples.basic.timer.basic_timer"),
			on_create = function(instance, output_log)
				---@cast instance examples.basic_timer
				instance.on_cycle_end:subscribe(function()
					output_log:add_log_text("Timer Cycle End")
				end)
			end,
		},
		{
			name_id = "ui_example_basic_hotkey",
			information_text_id = "ui_example_basic_hotkey_description",
			template = "basic_hotkey",
			root = "basic_hotkey/root",
			code_url = "example/examples/basic/hotkey/basic_hotkey.lua",
			widget_class = require("example.examples.basic.hotkey.basic_hotkey"),
			on_create = function(instance, output_log)
				---@cast instance examples.basic_hotkey
				instance.hotkey.on_hotkey_released:subscribe(function()
					output_log:add_log_text("Hotkey Released")
				end)
			end,
		},
		{
			name_id = "ui_example_basic_scroll",
			information_text_id = "ui_example_basic_scroll_description",
			template = "scroll",
			root = "scroll/root",
			code_url = "example/examples/basic/scroll/scroll.lua",
			widget_class = require("example.examples.basic.scroll.scroll"),
			on_create = function(instance, output_log)
				---@cast instance examples.scroll
				instance.button_tutorial.on_click:subscribe(function()
					output_log:add_log_text("Button Tutorial Clicked")
				end)
				instance.button_stencil.on_click:subscribe(function()
					output_log:add_log_text("Button Stencil Clicked")
				end)
			end,
			properties_control = function(instance, properties_panel)
				---@cast instance examples.scroll
				local scroll = instance.scroll
				local is_stretch = instance.scroll.style.EXTRA_STRETCH_SIZE > 0
				properties_panel:add_checkbox("ui_elastic_scroll", is_stretch, function(value)
					instance.scroll:set_extra_stretch_size(value and 100 or 0)
				end)

				local view_node = instance.scroll.view_node
				local is_stencil = gui.get_clipping_mode(view_node) == gui.CLIPPING_MODE_STENCIL
				properties_panel:add_checkbox("ui_clipping", is_stencil, function(value)
					gui.set_clipping_mode(view_node, value and gui.CLIPPING_MODE_STENCIL or gui.CLIPPING_MODE_NONE)
				end)

				local slider_frict = properties_panel:add_slider("ui_slider_friction", 0, function(value)
					scroll.style.FRICT = 1 - ((1 - value) * 0.1)
				end)
				slider_frict:set_text_function(function(value)
					return string.format("%.2f", 1 - ((1 - value) * 0.1))
				end)
				slider_frict:set_value(1 - (1 - scroll.style.FRICT) / 0.1)

				local slider_speed = properties_panel:add_slider("ui_slider_speed", 0, function(value)
					scroll.style.INERT_SPEED = value * 50
				end)
				slider_speed:set_value(scroll.style.INERT_SPEED / 50)
				slider_speed:set_text_function(function(value)
					return string.format("%.1f", value * 50)
				end)

				local slider_wheel_speed = properties_panel:add_slider("ui_slider_wheel_speed", 0, function(value)
					scroll.style.WHEEL_SCROLL_SPEED = value * 30
				end)
				slider_wheel_speed:set_value(scroll.style.WHEEL_SCROLL_SPEED / 30)
				slider_wheel_speed:set_text_function(function(value)
					return string.format("%.1f", value * 30)
				end)

				local wheel_by_inertion = properties_panel:add_checkbox("ui_wheel_by_inertion", scroll.style.WHEEL_SCROLL_BY_INERTION, function(value)
					scroll.style.WHEEL_SCROLL_BY_INERTION = value
				end)
				wheel_by_inertion:set_value(scroll.style.WHEEL_SCROLL_BY_INERTION)
			end,
			get_debug_info = function(instance)
				---@cast instance examples.scroll
				local info = ""

				local s = instance.scroll
				info = info .. "View Size Y: " .. gui.get(s.view_node, "size.y") .. "\n"
				info = info .. "Content Size Y: " .. gui.get(s.content_node, "size.y") .. "\n"
				info = info .. "Content position Y: " .. math.ceil(s.position.y) .. "\n"
				info = info .. "Content Range Y: " .. s.available_pos.y .. " - " .. s.available_pos.w .. "\n"

				return info
			end
		},
		{
			name_id = "ui_example_basic_scroll_slider",
			information_text_id = "ui_example_basic_scroll_slider_description",
			template = "scroll_slider",
			root = "scroll_slider/root",
			code_url = "example/examples/basic/scroll_slider/scroll_slider.lua",
			widget_class = require("example.examples.basic.scroll_slider.scroll_slider"),
			get_debug_info = function(instance)
				---@cast instance examples.scroll_slider
				local info = ""

				local s = instance.scroll
				info = info .. "View Size Y: " .. gui.get(s.view_node, "size.y") .. "\n"
				info = info .. "Content Size Y: " .. gui.get(s.content_node, "size.y") .. "\n"
				info = info .. "Content position Y: " .. math.ceil(s.position.y) .. "\n"
				info = info .. "Content Range Y: " .. s.available_pos.y .. " - " .. s.available_pos.w .. "\n"

				return info
			end
		},
		{
			name_id = "ui_example_basic_grid",
			information_text_id = "ui_example_basic_grid_description",
			template = "grid",
			root = "grid/root",
			code_url = "example/examples/basic/grid/grid.lua",
			widget_class = require("example.examples.basic.grid.grid"),
			properties_control = function(instance, properties_panel)
				---@cast instance examples.grid

				local grid = instance.grid

				local slider = properties_panel:add_slider("ui_grid_in_row", 0.3, function(value)
					local in_row_amount = math.ceil(value * 10)
					in_row_amount = math.max(1, in_row_amount)
					grid:set_in_row(in_row_amount)
				end)
				slider:set_text_function(function(value)
					return tostring(math.ceil(value * 10))
				end)

				properties_panel:add_button("ui_add_element", function()
					if #instance.created_nodes >= 36 then
						return
					end
					instance:add_element()
				end)

				properties_panel:add_button("ui_remove_element", function()
					instance:remove_element()
				end)

				properties_panel:add_button("ui_clear_elements", function()
					instance:clear()
				end)

				properties_panel:add_checkbox("ui_dynamic_pos", grid.style.IS_DYNAMIC_NODE_POSES, function()
					grid.style.IS_DYNAMIC_NODE_POSES = not grid.style.IS_DYNAMIC_NODE_POSES
					grid:refresh()
				end)

				properties_panel:add_checkbox("ui_align_last_row", grid.style.IS_ALIGN_LAST_ROW, function()
					grid.style.IS_ALIGN_LAST_ROW = not grid.style.IS_ALIGN_LAST_ROW
					grid:refresh()
				end)

				local pivot_index = 1
				local pivot_list = {
					gui.PIVOT_CENTER,
					gui.PIVOT_W,
					gui.PIVOT_SW,
					gui.PIVOT_S,
					gui.PIVOT_SE,
					gui.PIVOT_E,
					gui.PIVOT_NE,
					gui.PIVOT_N,
					gui.PIVOT_NW,
				}

				properties_panel:add_button("ui_pivot_next", function()
					pivot_index = pivot_index + 1
					if pivot_index > #pivot_list then
						pivot_index = 1
					end
					grid:set_pivot(pivot_list[pivot_index])
				end)

				local slider_size = properties_panel:add_slider("ui_item_size", 0.5, function(value)
					local size = 50 + value * 100
					grid:set_item_size(size, size)
				end)
				slider_size:set_text_function(function(value)
					return tostring(50 + math.ceil(value * 100))
				end)
				slider_size:set_value(0.5)
			end,
			get_debug_info = function(instance)
				---@cast instance examples.grid
				local info = ""

				local grid = instance.grid
				info = info .. "Grid Items: " .. #grid.nodes .. "\n"
				info = info .. "Grid Item Size: " .. grid.node_size.x .. " x " .. grid.node_size.y .. "\n"
				info = info .. "Pivot: " .. tostring(grid.pivot)

				return info
			end
		},
		{
			name_id = "ui_example_basic_scroll_bind_grid",
			information_text_id = "ui_example_basic_scroll_bind_grid_description",
			template = "scroll_bind_grid",
			root = "scroll_bind_grid/root",
			code_url = "example/examples/basic/scroll_bind_grid/scroll_bind_grid.lua",
			widget_class = require("example.examples.basic.scroll_bind_grid.scroll_bind_grid"),
			properties_control = function(instance, properties_panel)
				---@cast instance examples.scroll_bind_grid

				local view_node = instance.scroll.view_node
				local is_stencil = gui.get_clipping_mode(view_node) == gui.CLIPPING_MODE_STENCIL
				properties_panel:add_checkbox("ui_clipping", is_stencil, function(value)
					gui.set_clipping_mode(view_node, value and gui.CLIPPING_MODE_STENCIL or gui.CLIPPING_MODE_NONE)
				end)

				properties_panel:add_button("ui_add_element", function()
					if #instance.created_nodes >= 100 then
						return
					end
					instance:add_element()
				end)

				properties_panel:add_button("ui_remove_element", function()
					instance:remove_element()
				end)

				properties_panel:add_button("ui_clear_elements", function()
					instance:clear()
				end)
			end,
			get_debug_info = function(instance)
				---@cast instance examples.scroll_bind_grid
				local info = ""

				local s = instance.scroll
				local view_node_size = gui.get(s.view_node, "size.y")
				local scroll_position = -s.position
				local scroll_bottom_position = vmath.vector3(scroll_position.x, scroll_position.y - view_node_size, scroll_position.z)

				info = info .. "View Size Y: " .. gui.get(s.view_node, "size.y") .. "\n"
				info = info .. "Content Size Y: " .. gui.get(s.content_node, "size.y") .. "\n"
				info = info .. "Content position Y: " .. math.ceil(s.position.y) .. "\n"
				info = info .. "Content Range Y: " .. s.available_pos.y .. " - " .. s.available_pos.w .. "\n"
				info = info .. "Grid Items: " .. #instance.grid.nodes .. "\n"
				info = info .. "Grid Item Size: " .. instance.grid.node_size.x .. " x " .. instance.grid.node_size.y .. "\n"
				info = info .. "Top Scroll Pos Grid Index: " .. instance.grid:get_index(scroll_position) .. "\n"
				info = info .. "Bottm Scroll Pos Grid Index: " .. instance.grid:get_index(scroll_bottom_position) .. "\n"


				return info
			end
		},
		{
			name_id = "ui_example_basic_scroll_bind_grid_horizontal",
			information_text_id = "ui_example_basic_scroll_bind_grid_horizontal_description",
			template = "scroll_bind_grid_horizontal",
			root = "scroll_bind_grid_horizontal/root",
			code_url = "example/examples/basic/scroll_bind_grid/scroll_bind_grid_horizontal.lua",
			widget_class = require("example.examples.basic.scroll_bind_grid.scroll_bind_grid_horizontal"),
			properties_control = function(instance, properties_panel)
				---@cast instance examples.scroll_bind_grid_horizontal

				local view_node = instance.scroll.view_node
				local is_stencil = gui.get_clipping_mode(view_node) == gui.CLIPPING_MODE_STENCIL

				properties_panel:add_checkbox("ui_clipping", is_stencil, function(value)
					gui.set_clipping_mode(view_node, value and gui.CLIPPING_MODE_STENCIL or gui.CLIPPING_MODE_NONE)
				end)


				properties_panel:add_button("ui_add_element", function()
					if #instance.created_nodes >= 100 then
						return
					end
					instance:add_element()
				end)

				properties_panel:add_button("ui_remove_element", function()
					instance:remove_element()
				end)

				properties_panel:add_button("ui_clear_elements", function()
					instance:clear()
				end)
			end,
			get_debug_info = function(instance)
				---@cast instance examples.scroll_bind_grid_horizontal
				local info = ""

				local s = instance.scroll
				local view_node_size = gui.get(s.view_node, "size.x")
				local scroll_position = -s.position
				local scroll_bottom_position = vmath.vector3(scroll_position.x + view_node_size, scroll_position.y, scroll_position.z)

				info = info .. "View Size X: " .. gui.get(s.view_node, "size.x") .. "\n"
				info = info .. "Content Size X: " .. gui.get(s.content_node, "size.x") .. "\n"
				info = info .. "Content position X: " .. math.ceil(s.position.x) .. "\n"
				info = info .. "Content Range X: " .. s.available_pos.x .. " - " .. s.available_pos.z .. "\n"
				info = info .. "Grid Items: " .. #instance.grid.nodes .. "\n"
				info = info .. "Grid Item Size: " .. instance.grid.node_size.x .. " x " .. instance.grid.node_size.y .. "\n"
				info = info .. "Left Scroll Pos Grid Index: " .. instance.grid:get_index(scroll_position) .. "\n"
				info = info .. "Right Scroll Pos Grid Index: " .. instance.grid:get_index(scroll_bottom_position) .. "\n"

				return info
			end
		},
		{
			name_id = "ui_example_basic_scroll_bind_grid_points",
			information_text_id = "ui_example_basic_scroll_bind_grid_points_description",
			template = "scroll_bind_grid_points",
			root = "scroll_bind_grid_points/root",
			code_url = "example/examples/basic/scroll_bind_grid/scroll_bind_grid_points.lua",
			widget_class = require("example.examples.basic.scroll_bind_grid.scroll_bind_grid_points"),
			properties_control = function(instance, properties_panel)
				---@cast instance examples.scroll_bind_grid_points

				local view_node = instance.scroll.view_node
				local is_stencil = gui.get_clipping_mode(view_node) == gui.CLIPPING_MODE_STENCIL
				properties_panel:add_checkbox("ui_clipping", is_stencil, function(value)
					gui.set_clipping_mode(view_node, value and gui.CLIPPING_MODE_STENCIL or gui.CLIPPING_MODE_NONE)
				end)

				properties_panel:add_button("ui_add_element", function()
					if #instance.created_nodes >= 100 then
						return
					end
					instance:add_element()
				end)

				properties_panel:add_button("ui_remove_element", function()
					instance:remove_element()
				end)

				properties_panel:add_button("ui_clear_elements", function()
					instance:clear()
				end)
			end,
			get_debug_info = function(instance)
				---@cast instance examples.scroll_bind_grid_points
				local info = ""

				local s = instance.scroll
				local view_node_size = gui.get(s.view_node, "size.y")
				local scroll_position = -s.position
				local scroll_bottom_position = vmath.vector3(scroll_position.x, scroll_position.y - view_node_size, scroll_position.z)

				info = info .. "View Size Y: " .. gui.get(s.view_node, "size.y") .. "\n"
				info = info .. "Content Size Y: " .. gui.get(s.content_node, "size.y") .. "\n"
				info = info .. "Content position Y: " .. math.ceil(s.position.y) .. "\n"
				info = info .. "Content Range Y: " .. s.available_pos.y .. " - " .. s.available_pos.w .. "\n"
				info = info .. "Grid Items: " .. #instance.grid.nodes .. "\n"
				info = info .. "Grid Item Size: " .. instance.grid.node_size.x .. " x " .. instance.grid.node_size.y .. "\n"
				info = info .. "Top Scroll Pos Grid Index: " .. instance.grid:get_index(scroll_position) .. "\n"
				info = info .. "Bottm Scroll Pos Grid Index: " .. instance.grid:get_index(scroll_bottom_position) .. "\n"


				return info
			end
		},
		{
			name_id = "ui_example_basic_input",
			information_text_id = "ui_example_basic_input_description",
			template = "basic_input",
			root = "basic_input/root",
			code_url = "example/examples/basic/input/basic_input.lua",
			widget_class = require("example.examples.basic.input.basic_input"),
			on_create = function(instance, output_log)
				---@cast instance examples.basic_input
				instance.input.on_input_select:subscribe(function()
					output_log:add_log_text("Input Selected")
				end)
				instance.input_2.on_input_select:subscribe(function()
					output_log:add_log_text("Input 2 Selected")
				end)
				instance.input.on_input_unselect:subscribe(function(_, text)
					output_log:add_log_text("Input Deselected. Text: " .. text)
				end)
				instance.input_2.on_input_unselect:subscribe(function(_, text)
					output_log:add_log_text("Input Deselected. Text: " .. text)
				end)
			end,
		},
		{
			name_id = "ui_example_input_password",
			information_text_id = "ui_example_input_password_description",
			template = "input_password",
			root = "input_password/root",
			code_url = "example/examples/basic/input/input_password.lua",
			widget_class = require("example.examples.basic.input.input_password"),
			on_create = function(instance, output_log)
				---@cast instance examples.input_password
				instance.input.on_input_unselect:subscribe(function(_, text)
					output_log:add_log_text("Input: " .. text)
				end)
			end,
		},
		{
			name_id = "ui_example_basic_rich_input",
			information_text_id = "ui_example_basic_rich_input_description",
			template = "basic_rich_input",
			root = "basic_rich_input/root",
			code_url = "example/examples/basic/input/rich_input.lua",
			widget_class = require("example.examples.basic.input.rich_input"),
			on_create = function(instance, output_log)
				---@cast instance examples.rich_input
				instance.rich_input.input.on_input_unselect:subscribe(function(_, text)
					output_log:add_log_text("Input: " .. text)
				end)
				instance.rich_input_2.input.on_input_unselect:subscribe(function(_, text)
					output_log:add_log_text("Input 2: " .. text)
				end)
			end,
		},
		{
			name_id = "ui_example_basic_rich_text",
			information_text_id = "ui_example_basic_rich_text_description",
			template = "basic_rich_text",
			root = "basic_rich_text/root",
			code_url = "example/examples/basic/rich_text/basic_rich_text.lua",
			widget_class = require("example.examples.basic.rich_text.basic_rich_text"),
		},
		{
			name_id = "ui_example_rich_text_tags",
			information_text_id = "ui_example_rich_text_tags_description",
			template = "rich_text_tags",
			root = "rich_text_tags/root",
			code_url = "example/examples/basic/rich_text/rich_text_tags.lua",
			widget_class = require("example.examples.basic.rich_text.rich_text_tags"),
			properties_control = function(instance, properties_panel)
				local pivot_index = 1
				local pivot_list = {
					gui.PIVOT_CENTER,
					gui.PIVOT_W,
					gui.PIVOT_SW,
					gui.PIVOT_S,
					gui.PIVOT_SE,
					gui.PIVOT_E,
					gui.PIVOT_NE,
					gui.PIVOT_N,
					gui.PIVOT_NW,
				}

				---@cast instance examples.rich_text_tags
				properties_panel:add_button("ui_pivot_next", function()
					pivot_index = pivot_index + 1
					if pivot_index > #pivot_list then
						pivot_index = 1
					end
					instance:set_pivot(pivot_list[pivot_index])
				end)
			end
		},
		--{
		--	name_id = "ui_example_rich_text_tags_custom",
		--	information_text_id = "ui_example_rich_text_tags_custom_description",
		--	template = "rich_text_tags_custom",
		--	root = "rich_text_tags_custom/root",
		--	code_url = "example/examples/basic/rich_text/rich_text_tags_custom.lua",
		--	component_class = require("example.examples.basic.rich_text.rich_text_tags_custom"),
		--	properties_control = function(instance, properties_panel)
		--		local pivot_index = 1
		--		local pivot_list = {
		--			gui.PIVOT_CENTER,
		--			gui.PIVOT_W,
		--			gui.PIVOT_SW,
		--			gui.PIVOT_S,
		--			gui.PIVOT_SE,
		--			gui.PIVOT_E,
		--			gui.PIVOT_NE,
		--			gui.PIVOT_N,
		--			gui.PIVOT_NW,
		--		}

		--		---@cast instance rich_text_tags_custom
		--		properties_panel:add_button("ui_pivot_next", function()
		--			pivot_index = pivot_index + 1
		--			if pivot_index > #pivot_list then
		--				pivot_index = 1
		--			end
		--			instance:set_pivot(pivot_list[pivot_index])
		--		end)
		--	end,

		--	on_create = function(instance, output_log)
		--		---@cast instance rich_text_tags_custom
		--		instance.on_link_click:subscribe(function(text)
		--			output_log:add_log_text("Custom Link: " .. text)
		--		end)
		--	end
		--},
		{
			name_id = "ui_example_basic_swipe",
			information_text_id = "ui_example_basic_swipe_description",
			template = "basic_swipe",
			root = "basic_swipe/root",
			code_url = "example/examples/basic/swipe/basic_swipe.lua",
			widget_class = require("example.examples.basic.swipe.basic_swipe"),
			on_create = function(instance, output_log)
				---@cast instance examples.basic_swipe
				instance.swipe.on_swipe:subscribe(function(_, side, dist, delta_time)
					output_log:add_log_text("Swipe Side: " .. side)
				end)
			end,
		},
		{
			name_id = "ui_example_checkbox",
			information_text_id = "ui_example_checkbox_description",
			template = "checkbox",
			root = "checkbox/root",
			code_url = "example/examples/basic/checkbox/checkbox.lua",
			widget_class = require("example.examples.basic.checkbox.checkbox"),
			on_create = function(instance, output_log)
				---@cast instance examples.checkbox
				instance.button.on_click:subscribe(function()
					output_log:add_log_text("Checkbox Clicked: " .. tostring(instance.is_enabled))
				end)
			end,
		},
		{
			name_id = "ui_example_checkbox_group",
			information_text_id = "ui_example_checkbox_group_description",
			template = "checkbox_group",
			root = "checkbox_group/root",
			code_url = "example/examples/basic/checkbox_group/checkbox_group.lua",
			widget_class = require("example.examples.basic.checkbox_group.checkbox_group"),
			on_create = function(instance, output_log)
				---@cast instance examples.checkbox_group
				instance.on_state_changed:subscribe(function(state1, state2, state3)
					output_log:add_log_text("State: " .. tostring(state1) .. " " .. tostring(state2) .. " " .. tostring(state3))
				end)
			end,
		},
		{
			name_id = "ui_example_radio_group",
			information_text_id = "ui_example_radio_group_description",
			template = "radio_group",
			root = "radio_group/root",
			code_url = "example/examples/basic/radio_group/radio_group.lua",
			widget_class = require("example.examples.basic.radio_group.radio_group"),
			on_create = function(instance, output_log)
				---@cast instance examples.radio_group
				instance.on_state_changed:subscribe(function(selected)
					output_log:add_log_text("Selected: " .. selected)
				end)
			end,
		},
	}
end

return M
