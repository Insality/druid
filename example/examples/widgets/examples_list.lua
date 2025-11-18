local M = {}

function M.get_examples()
	---@type druid.example.data[]
	return {
		{
			name_id = "ui_example_widget_hover_hint",
			information_text_id = "ui_example_widget_hover_hint_description",
			template = "hover_hint_example",
			root = "hover_hint_example/root",
			code_url = "example/examples/widgets/hover_hint/hover_hint_example.lua",
			widget_class = require("example.examples.widgets.hover_hint.hover_hint_example"),
		}
	}
end

return M
