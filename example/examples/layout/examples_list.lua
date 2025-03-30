local M = {}

---@return druid.example.data[]
function M.get_examples()
	---@type druid.example.data[]
	return {
		{
			name_id = "ui_example_layout_basic",
			information_text_id = "ui_example_layout_basic_description",
			template = "basic_layout",
			root = "basic_layout/root",
			code_url = "example/examples/layout/basic/basic_layout.lua",
			widget_class = require("example.examples.layout.basic.basic_layout"),
		}
	}
end


return M
