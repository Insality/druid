local event = require("event.event")

---@class examples.data_list_add_remove_clear: druid.widget
---@field prefab node
---@field scroll druid.scroll
---@field grid druid.grid
---@field data_list druid.data_list
---@field on_item_click event
local M = {}


function M:init()
	self.prefab = self:get_node("prefab")
	gui.set_enabled(self.prefab, false)

	self.scroll = self.druid:new_scroll("view", "content")
	self.grid = self.druid:new_grid("content", self.prefab, 1)
	self.data_list = self.druid:new_data_list(self.scroll, self.grid, self.create_item_callback) --[[@as druid.data_list]]

	local data = {}
	for index = 1, 20 do
		table.insert(data, {})
	end
	self.data_list:set_data(data)

	self.on_item_click = event.create()
end


---@param item_data table
---@param index number
---@return node, druid.component
function M:create_item_callback(item_data, index)
	local nodes = gui.clone_tree(self.prefab)

	local root = nodes[self:get_template() .. "/prefab"]
	local text = nodes[self:get_template() .. "/text"]
	gui.set_enabled(root, true)
	gui.set_text(text, "Data Item " .. index)

	local button = self.druid:new_button(root, self.on_button_click, index)
	return root, button
end


function M:on_button_click(index)
	self.on_item_click:trigger(index)
end


function M:add_item(index)
	self.data_list:add({}, index)
end


function M:remove_item(index)
	print("Want to remove item", index)
	self.data_list:remove(index)
end


function M:clear()
	self.data_list:clear()
end


---@param output_list output_list
function M:on_example_created(output_list)
	self.on_item_click:subscribe(function(index)
		self:remove_item(index)
		output_list:add_log_text("Item removed: " .. index)
	end)
end


---@param properties_panel properties_panel
function M:properties_control(properties_panel)
	local view_node = self.scroll.view_node
	local is_stencil = gui.get_clipping_mode(view_node) == gui.CLIPPING_MODE_STENCIL

	properties_panel:add_checkbox("ui_clipping", is_stencil, function(value)
		gui.set_clipping_mode(view_node, value and gui.CLIPPING_MODE_STENCIL or gui.CLIPPING_MODE_NONE)
	end)

	properties_panel:add_slider("ui_scroll", 0, function(value)
		self.scroll:scroll_to_percent(vmath.vector3(0, 1 - value, 0), true)
	end)

	properties_panel:add_button("ui_add_element", function()
		self:add_item()
	end)

	properties_panel:add_button("ui_remove_element", function()
		self:remove_item()
	end)

	properties_panel:add_button("ui_clear_elements", function()
		self.data_list:clear()
	end)
end


---@return string
function M:get_debug_info()
	local data_list = self.data_list

	local data = data_list:get_data()
	local info = ""
	info = info .. "Data length: " .. #data .. "\n"
	info = info .. "First Visual Index: " .. data_list.top_index .. "\n"
	info = info .. "Last Visual Index: " .. data_list.last_index .. "\n"

	local s = self.scroll
	info = info .. "\n"
	info = info .. "View Size X: " .. gui.get(s.view_node, "size.x") .. "\n"
	info = info .. "Content Size X: " .. gui.get(s.content_node, "size.x") .. "\n"
	info = info .. "Content position X: " .. math.ceil(s.position.x) .. "\n"
	info = info .. "Content Range X: " .. s.available_pos.x .. " - " .. s.available_pos.z .. "\n"

	return info
end


return M
