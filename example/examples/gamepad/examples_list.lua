local M = {}

---@return druid.example.data[]
function M.get_examples()
	---@type druid.example.data[]
	return {
		{
			name_id = "ui_example_gamepad_tester",
			information_text_id = "ui_example_gamepad_tester_description",
			template = "gamepad_tester",
			root = "gamepad_tester/root",
			code_url = "example/examples/gamepad/gamepad_tester/gamepad_tester.lua",
			component_class = require("example.examples.gamepad.gamepad_tester.gamepad_tester"),
			on_create = function(instance, output_list)
				---@cast instance gamepad_tester
				instance.button_left.on_click:subscribe(function()
					output_list:add_log_text("Button Left Clicked")
				end)
				instance.button_right.on_click:subscribe(function()
					output_list:add_log_text("Button Right Clicked")
				end)
				instance.button_up.on_click:subscribe(function()
					output_list:add_log_text("Button Up Clicked")
				end)
				instance.button_down.on_click:subscribe(function()
					output_list:add_log_text("Button Down Clicked")
				end)
				instance.button_a.on_click:subscribe(function()
					output_list:add_log_text("Button A Clicked")
				end)
				instance.button_b.on_click:subscribe(function()
					output_list:add_log_text("Button B Clicked")
				end)
				instance.button_x.on_click:subscribe(function()
					output_list:add_log_text("Button X Clicked")
				end)
				instance.button_y.on_click:subscribe(function()
					output_list:add_log_text("Button Y Clicked")
				end)
				instance.button_back.on_click:subscribe(function()
					output_list:add_log_text("Button Back Clicked")
				end)
				instance.button_start.on_click:subscribe(function()
					output_list:add_log_text("Button Start Clicked")
				end)
				instance.button_l1.on_click:subscribe(function()
					output_list:add_log_text("Button L1 Clicked")
				end)
				instance.button_r1.on_click:subscribe(function()
					output_list:add_log_text("Button R1 Clicked")
				end)
				instance.button_stick_left.on_click:subscribe(function()
					output_list:add_log_text("Button Stick Left Clicked")
				end)
				instance.button_stick_right.on_click:subscribe(function()
					output_list:add_log_text("Button Stick Right Clicked")
				end)
			end,
		},

		{
			name_id = "ui_example_on_screen_control",
			information_text_id = "ui_example_on_screen_control_description",
			template = "on_screen_control",
			root = "on_screen_control/root",
			code_url = "example/examples/gamepad/on_screen_control/on_screen_control.lua",
			component_class = require("example.examples.gamepad.on_screen_control.on_screen_control"),
		}
	}
end

return M