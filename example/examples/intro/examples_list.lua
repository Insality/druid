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
			component_class = require("example.examples.intro.intro.intro"),
		},
	}
end

return M