local event = require("event.event")
local component = require("druid.component")
local storage = require("saver.storage")

local examples_list_view_item = require("example.components.examples_list_view.examples_list_view_item")

---@class examples_list_view: druid.base_component
---@field root druid.container
---@field druid druid_instance
---@field scroll druid.scroll
---@field grid druid.grid
local M = component.create("examples_list_view")


---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.root = self.druid:new_container("root") --[[@as druid.container]]
	self.root:add_container("text_header")

	self.druid:new_lang_text("text_header", "ui_examples")
	self.druid:new(examples_list_view_item, "examples_list_view_item")

	self.prefab = self:get_node("examples_list_view_item/root")
	gui.set_enabled(self.prefab, false)

	self.scroll = self.druid:new_scroll("scroll_view", "scroll_content")
	self.grid = self.druid:new_grid("scroll_content", self.prefab, 1)
	self.scroll:bind_grid(self.grid)

	self.root:add_container("scroll_view", nil, function(_, size)
		self.scroll:set_view_size(size)
		self.scroll:set_size(self.grid:get_size())
	end)

	self.selected_example = nil
	self.examples = {}
	self.on_debug_info = event.create()
	self.on_set_information = event.create()
	self.add_log_text = event.create()

	timer.delay(0.1, true, function()
		self:update_debug_info()
	end)
end


---@param examples druid.examples
---@param druid_example druid.example @The main GUI component
function M:add_example(examples, druid_example)
	local example_name_id = examples.example_name_id
	local examples_list = examples.examples_list

	if false then
		do -- Add section name
			local nodes = gui.clone_tree(self.prefab)
			local item = self.druid:new(examples_list_view_item, "examples_list_view_item", nodes) --[[@as examples_list_view_item]]
			gui.set_enabled(item.root.node, true)
			item.text:translate(example_name_id)
			item:set_fold_icon_enabled(true)

			item.on_click:subscribe(function()
				item:set_fold_status(not item:is_folded())
			end)

			self.grid:add(item.root.node)
		end
	end

	for index = 1, #examples_list do
		local example_data = examples_list[index]
		local nodes = gui.clone_tree(self.prefab)
		local item = self.druid:new(examples_list_view_item, "examples_list_view_item", nodes) --[[@as examples_list_view_item]]
		gui.set_enabled(item.root.node, true)
		item.text:translate(example_data.name_id)
		item:set_fold_icon_enabled(false)

		item.on_click:subscribe(function()
			if self.selected_example then
				self.selected_example.list_item:set_selected(false)
				druid_example.druid:remove(self.selected_example.instance)
				gui.set_enabled(self.selected_example.root, false)

				self.selected_example = nil
			end

			local root = gui.get_node(example_data.root)
			gui.set_enabled(root, true)

			local instance
			if example_data.widget_class then
				instance = druid_example.druid:new_widget(example_data.widget_class, example_data.template)
			else
				instance = druid_example.druid:new(example_data.component_class, example_data.template)
			end

			self.selected_example = {
				data = example_data,
				list_item = item,
				instance = instance,
				root = root
			}
			item:set_selected(true)

			druid_example.output_list:clear()
			if example_data.on_create then
				example_data.on_create(instance, druid_example.output_list)
			end

			if example_data.information_text_id then
				self.on_set_information(example_data.information_text_id)
			else
				self.on_set_information("")
			end

			druid_example.example_scene:set_gui_path(example_data.code_url)

			druid_example.properties_panel:clear()
			if example_data.properties_control then
				example_data.properties_control(instance, druid_example.properties_panel)
			end

			storage.set("last_selected_example", example_data.name_id)
			if html5 then
				local command = string.format('window.history.replaceState(null, null, "?example=%s")', example_data.name_id)
				html5.run(command)
			end
		end)

		self.grid:add(item.root.node)
		table.insert(self.examples, {
			data = example_data,
			list_item = item
		})
	end
end


---@param name_id string
---@return boolean @true if example was found and selected
function M:select_example_by_name_id(name_id)
	print("Select example by name_id", name_id)
	for index = 1, #self.examples do
		local example = self.examples[index]

		-- Scroll to the element
		local target_pos = gui.get_position(example.list_item.root.node)
		target_pos.y = target_pos.y + self.scroll.view_size.y / 2
		self.scroll:scroll_to(target_pos, true)

		-- Select the element
		if example.data.name_id == name_id then
			example.list_item.on_click:trigger()
			return true
		end
	end

	return false
end


function M:update_debug_info()
	if not self.selected_example then
		self.on_debug_info:trigger("")
		return
	end

	local data = self.selected_example.data
	if data.get_debug_info then
		local info = data.get_debug_info(self.selected_example.instance)
		self.on_debug_info:trigger(info)
		return
	end

	self.on_debug_info:trigger("")
end


return M
