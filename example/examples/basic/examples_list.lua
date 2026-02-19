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
		},
		{
			name_id = "ui_example_basic_button_double_click",
			information_text_id = "ui_example_basic_button_double_click_description",
			template = "basic_button_double_click",
			root = "basic_button_double_click/root",
			code_url = "example/examples/basic/button/basic_button_double_click.lua",
			widget_class = require("example.examples.basic.button.basic_button_double_click"),
		},
		{
			name_id = "ui_example_basic_button_hold",
			information_text_id = "ui_example_basic_button_hold_description",
			template = "basic_button_hold",
			root = "basic_button_hold/root",
			code_url = "example/examples/basic/button/basic_button_hold.lua",
			widget_class = require("example.examples.basic.button.basic_button_hold"),
		},
		{
			name_id = "ui_example_basic_text",
			information_text_id = "ui_example_basic_text_description",
			template = "basic_text",
			root = "basic_text/root",
			code_url = "example/examples/basic/text/basic_text.lua",
			widget_class = require("example.examples.basic.text.basic_text"),
		},
		{
			name_id = "ui_example_basic_multiline_text",
			information_text_id = "ui_example_basic_multiline_text_description",
			template = "multiline_text",
			root = "multiline_text/root",
			code_url = "example/examples/basic/text/multiline_text.lua",
			widget_class = require("example.examples.basic.text.multiline_text"),
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
		},
		{
			name_id = "ui_example_basic_slider_vertical",
			information_text_id = "ui_example_basic_slider_vertical_description",
			template = "basic_slider_vertical",
			root = "basic_slider_vertical/root",
			code_url = "example/examples/basic/slider/basic_slider_vertical.lua",
			widget_class = require("example.examples.basic.slider.basic_slider_vertical"),
		},
		{
			name_id = "ui_example_basic_slider_stepped",
			information_text_id = "ui_example_basic_slider_stepped_description",
			template = "basic_slider_stepped",
			root = "basic_slider_stepped/root",
			code_url = "example/examples/basic/slider/basic_slider_stepped.lua",
			widget_class = require("example.examples.basic.slider.basic_slider_stepped"),
		},
		{
			name_id = "ui_example_basic_progress_bar",
			information_text_id = "ui_example_basic_progress_bar_description",
			template = "basic_progress_bar",
			root = "basic_progress_bar/root",
			code_url = "example/examples/basic/progress_bar/basic_progress_bar.lua",
			widget_class = require("example.examples.basic.progress_bar.basic_progress_bar"),
		},
		{
			name_id = "ui_example_basic_progress_bar_slice9",
			information_text_id = "ui_example_basic_progress_bar_slice9_description",
			template = "basic_progress_bar_slice9",
			root = "basic_progress_bar_slice9/root",
			code_url = "example/examples/basic/progress_bar/basic_progress_bar_slice9.lua",
			widget_class = require("example.examples.basic.progress_bar.basic_progress_bar_slice9"),
		},
		{
			name_id = "ui_example_basic_blocker",
			information_text_id = "ui_example_basic_blocker_description",
			template = "basic_blocker",
			root = "basic_blocker/root",
			code_url = "example/examples/basic/blocker/basic_blocker.lua",
			widget_class = require("example.examples.basic.blocker.basic_blocker"),
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
		},
		{
			name_id = "ui_example_basic_hotkey",
			information_text_id = "ui_example_basic_hotkey_description",
			template = "basic_hotkey",
			root = "basic_hotkey/root",
			code_url = "example/examples/basic/hotkey/basic_hotkey.lua",
			widget_class = require("example.examples.basic.hotkey.basic_hotkey"),
		},
		{
			name_id = "ui_example_basic_scroll",
			information_text_id = "ui_example_basic_scroll_description",
			template = "scroll",
			root = "scroll/root",
			code_url = "example/examples/basic/scroll/scroll.lua",
			widget_class = require("example.examples.basic.scroll.scroll"),
		},
		{
			name_id = "ui_example_basic_scroll_slider",
			information_text_id = "ui_example_basic_scroll_slider_description",
			template = "scroll_slider",
			root = "scroll_slider/root",
			code_url = "example/examples/basic/scroll_slider/scroll_slider.lua",
			widget_class = require("example.examples.basic.scroll_slider.scroll_slider"),
		},
		{
			name_id = "ui_example_basic_grid",
			information_text_id = "ui_example_basic_grid_description",
			template = "grid",
			root = "grid/root",
			code_url = "example/examples/basic/grid/grid.lua",
			widget_class = require("example.examples.basic.grid.grid"),
		},
		{
			name_id = "ui_example_basic_scroll_bind_grid",
			information_text_id = "ui_example_basic_scroll_bind_grid_description",
			template = "scroll_bind_grid",
			root = "scroll_bind_grid/root",
			code_url = "example/examples/basic/scroll_bind_grid/scroll_bind_grid.lua",
			widget_class = require("example.examples.basic.scroll_bind_grid.scroll_bind_grid"),
		},
		{
			name_id = "ui_example_basic_scroll_bind_grid_horizontal",
			information_text_id = "ui_example_basic_scroll_bind_grid_horizontal_description",
			template = "scroll_bind_grid_horizontal",
			root = "scroll_bind_grid_horizontal/root",
			code_url = "example/examples/basic/scroll_bind_grid/scroll_bind_grid_horizontal.lua",
			widget_class = require("example.examples.basic.scroll_bind_grid.scroll_bind_grid_horizontal"),
		},
		{
			name_id = "ui_example_basic_scroll_bind_grid_points",
			information_text_id = "ui_example_basic_scroll_bind_grid_points_description",
			template = "scroll_bind_grid_points",
			root = "scroll_bind_grid_points/root",
			code_url = "example/examples/basic/scroll_bind_grid/scroll_bind_grid_points.lua",
			widget_class = require("example.examples.basic.scroll_bind_grid.scroll_bind_grid_points"),
		},
		{
			name_id = "ui_example_basic_input",
			information_text_id = "ui_example_basic_input_description",
			template = "basic_input",
			root = "basic_input/root",
			code_url = "example/examples/basic/input/basic_input.lua",
			widget_class = require("example.examples.basic.input.basic_input"),
		},
		{
			name_id = "ui_example_input_password",
			information_text_id = "ui_example_input_password_description",
			template = "input_password",
			root = "input_password/root",
			code_url = "example/examples/basic/input/input_password.lua",
			widget_class = require("example.examples.basic.input.input_password"),
		},
		{
			name_id = "ui_example_basic_rich_input",
			information_text_id = "ui_example_basic_rich_input_description",
			template = "basic_rich_input",
			root = "basic_rich_input/root",
			code_url = "example/examples/basic/input/rich_input.lua",
			widget_class = require("example.examples.basic.input.rich_input"),
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
		},
		{
			name_id = "ui_example_rich_text_split_animated",
			information_text_id = "ui_example_rich_text_split_animated_description",
			template = "rich_text_split_animated",
			root = "rich_text_split_animated/root",
			code_url = "example/examples/basic/rich_text/rich_text_split_animated.lua",
			widget_class = require("example.examples.basic.rich_text.rich_text_split_animated"),
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
		},
		{
			name_id = "ui_example_checkbox",
			information_text_id = "ui_example_checkbox_description",
			template = "checkbox",
			root = "checkbox/root",
			code_url = "example/examples/basic/checkbox/checkbox.lua",
			widget_class = require("example.examples.basic.checkbox.checkbox"),
		},
		{
			name_id = "ui_example_checkbox_group",
			information_text_id = "ui_example_checkbox_group_description",
			template = "checkbox_group",
			root = "checkbox_group/root",
			code_url = "example/examples/basic/checkbox_group/checkbox_group.lua",
			widget_class = require("example.examples.basic.checkbox_group.checkbox_group"),
		},
		{
			name_id = "ui_example_radio_group",
			information_text_id = "ui_example_radio_group_description",
			template = "radio_group",
			root = "radio_group/root",
			code_url = "example/examples/basic/radio_group/radio_group.lua",
			widget_class = require("example.examples.basic.radio_group.radio_group"),
		},
	}
end

return M
