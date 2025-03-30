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
		--{
		--	name_id = "ui_example_how_to_use_example",
		--	information_text_id = "ui_example_how_to_use_example_description",
		--	template = "how_to_use_example",
		--	root = "how_to_use_example/root",
		--	code_url = "example/examples/intro/how_to_use_example/how_to_use_example.lua",
		--	widget_class = require("example.examples.intro.how_to_use_example.how_to_use_example"),
		--}
	}
end

return M
