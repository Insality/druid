local helper = require "druid.helper"
local M = {}

function M.get_examples()
	---@type druid.example.data[]
	return {
		{
			name_id = "ui_example_intro",
			information_text_id = "ui_example_intro_description",
			template = "intro",
			root = "intro/root",
			code_url = "example/examples/intro/intro/intro.lua",
			widget_class = require("example.examples.intro.intro.intro"),
		},
		{
			name_id = "ui_example_window_language",
			information_text_id = "ui_example_window_language_description",
			template = "window_language",
			root = "window_language/root",
			code_url = "example/examples/windows/window_language/window_language.lua",
			widget_class = require("example.examples.windows.window_language.window_language"),
		},
	}
end

return M
