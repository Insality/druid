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
			widget_class = require("example.examples.data_list.basic.data_list_basic"),
		},

		{
			name_id = "ui_example_data_list_horizontal_basic",
			information_text_id = "ui_example_data_list_horizontal_basic_description",
			template = "data_list_horizontal_basic",
			root = "data_list_horizontal_basic/root",
			code_url = "example/examples/data_list/basic/data_list_horizontal_basic.lua",
			widget_class = require("example.examples.data_list.basic.data_list_horizontal_basic"),
		},

		{
			name_id = "ui_example_data_list_matrix_basic",
			information_text_id = "ui_example_data_list_matrix_basic_description",
			template = "data_list_matrix_basic",
			root = "data_list_matrix_basic/root",
			code_url = "example/examples/data_list/basic/data_list_matrix_basic.lua",
			widget_class = require("example.examples.data_list.basic.data_list_matrix_basic"),
		},

		{
			name_id = "ui_example_data_list_add_remove_clear",
			information_text_id = "ui_example_data_list_add_remove_clear_description",
			template = "data_list_add_remove_clear",
			root = "data_list_add_remove_clear/root",
			code_url = "example/examples/data_list/add_remove_clear/data_list_add_remove_clear.lua",
			widget_class = require("example.examples.data_list.add_remove_clear.data_list_add_remove_clear"),
		},

		{
			name_id = "ui_example_data_list_cache_with_component",
			information_text_id = "ui_example_data_list_cache_with_component_description",
			template = "data_list_cache_with_component",
			root = "data_list_cache_with_component/root",
			code_url = "example/examples/data_list/cache_with_component/cache_with_component.lua",
			widget_class = require("example.examples.data_list.cache_with_component.cache_with_component"),
		},
	}
end

return M
