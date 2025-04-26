local M = {}

function M.get_examples()
	---@type druid.example.data[]
	return {
		{
			name_id = "ui_example_container_anchors",
			information_text_id = "ui_example_container_anchors_description",
			template = "container_anchors",
			root = "container_anchors/root",
			code_url = "example/examples/container/container_anchors/container_anchors.lua",
			widget_class = require("example.examples.container.container_anchors.container_anchors"),
		},
		{
			name_id = "ui_example_container_resize",
			information_text_id = "ui_example_container_resize_description",
			template = "container_resize",
			root = "container_resize/root",
			code_url = "example/examples/container/container_resize/container_resize.lua",
			widget_class = require("example.examples.container.container_resize.container_resize"),
		}
	}
end

return M
