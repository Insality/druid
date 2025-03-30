local intro_examples = require("example.examples.intro.examples_list")
local basic_examples = require("example.examples.basic.examples_list")
local data_list_examples = require("example.examples.data_list.examples_list")
local layout_examples = require("example.examples.layout.examples_list")
local gamepad_examples = require("example.examples.gamepad.examples_list")
local window_examples = require("example.examples.windows.examples_list")
local widgets_examples = require("example.examples.widgets.examples_list")
local panthera_examples = require("example.examples.panthera.examples_list")

local M = {}

---@class druid.examples
---@field example_name_id string
---@field examples_list druid.example.data[]

---@class druid.example.data
---@field name_id string
---@field root string
---@field template string|nil
---@field code_url string|nil @URL to the source code
---@field component_class druid.component|nil
---@field widget_class druid.widget|nil New way to create components
---@field on_create fun(instance: druid.component|druid.widget, output_list: output_list)|nil
---@field get_debug_info (fun(instance: druid.component):string)|nil
---@field properties_control (fun(instance: druid.component, properties_panel: properties_panel))|nil
---@field information_text_id string|nil


local function add_examples(examples, example_name_id, examples_list)
	table.insert(examples, {
		example_name_id = example_name_id,
		examples_list = examples_list
	})
end

---@return druid.examples[]
function M.get_examples()
	local examples = {}

	add_examples(examples, "ui_examples_intro", intro_examples.get_examples())
	add_examples(examples, "ui_examples_basic", basic_examples.get_examples())
	add_examples(examples, "ui_examples_data_list", data_list_examples.get_examples())
	add_examples(examples, "ui_examples_layout", layout_examples.get_examples())
	add_examples(examples, "ui_examples_gamepad", gamepad_examples.get_examples())
	add_examples(examples, "ui_examples_window", window_examples.get_examples())
	add_examples(examples, "ui_examples_panthera", panthera_examples.get_examples())
	add_examples(examples, "ui_examples_widgets", widgets_examples.get_examples())

	return examples
end

return M
