local M = {}

---@return druid.example.data[]
function M.get_examples()
	---@type druid.example.data[]
	return {
		{
			name_id = "ui_example_window_language",
			information_text_id = "ui_example_window_language_description",
			template = "window_language",
			root = "window_language/root",
			code_url = "example/examples/windows/window_language/window_language.lua",
			widget_class = require("example.examples.windows.window_language.window_language"),
			on_create = function(instance, output_list)
				---@cast instance examples.window_language
				instance.on_language_change:subscribe(function(language)
					output_list:add_log_text("Language changed to " .. language)
				end)
			end
		},
		{
			name_id = "ui_example_window_confirmation",
			template = "window_confirmation",
			root = "window_confirmation/root",
			information_text_id = "ui_example_window_language_description",
			code_url = "example/examples/windows/window_confirmation/window_confirmation.lua",
			widget_class = require("example.examples.windows.window_confirmation.window_confirmation"),
			on_create = function(instance, output_list)
				---@cast instance examples.window_confirmation
				instance.text_header:translate("ui_confirmation")
				instance.text_button_accept:translate("ui_confirm")
				instance.text_button_decline:translate("ui_cancel")
				instance.text_description:translate("ui_confirmation_description")

				instance.button_accept.on_click:subscribe(function()
					output_list:add_log_text("Confirmation Accepted")
				end)
				instance.button_decline.on_click:subscribe(function()
					output_list:add_log_text("Confirmation Declined")
				end)
			end,
		},
		{
			name_id = "ui_example_window_information",
			template = "window_info",
			root = "window_info/root",
			information_text_id = "ui_example_window_information_description",
			code_url = "example/examples/windows/window_info/window_info.lua",
			widget_class = require("example.examples.windows.window_info.window_info"),
			on_create = function(instance, output_list)
				---@cast instance examples.window_info
				instance.text_header:translate("ui_information")
				instance.text_button_accept:translate("ui_confirm")
				instance.text_description:translate("ui_example_window_information_text")

				instance.button_accept.on_click:subscribe(function()
					output_list:add_log_text("Information Accepted")
				end)
			end
		}
	}
end

return M
