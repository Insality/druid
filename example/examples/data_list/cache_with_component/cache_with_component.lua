local event = require("event.event")

local button_component = require("example.examples.data_list.cache_with_component.button_component")

---@class examples.data_list_cache_with_component: druid.widget
---@field prefab node
---@field scroll druid.scroll
---@field grid druid.grid
---@field data_list druid.data_list
---@field on_item_click event
local M = {}


function M:init()
	self.prefab = self:get_node("button_component/root")
	gui.set_enabled(self.prefab, false)

	self.scroll = self.druid:new_scroll("view", "content")
	self.grid = self.druid:new_grid("content", self.prefab, 1)
	self.data_list = self.druid:new_data_list(self.scroll, self.grid, self.create_item_callback) --[[@as druid.data_list]]
	self.data_list:set_use_cache(true)
	self.data_list.on_element_add:subscribe(self.on_element_add)
	self.data_list.on_element_remove:subscribe(self.on_element_remove)

	local data = {}
	for index = 1, 1000 do
		table.insert(data, {})
	end
	self.data_list:set_data(data)

	self.on_item_click = event.create()
end


---@param item_data table
---@param index number
---@return node, druid.component
function M:create_item_callback(item_data, index)
	local instance = self.druid:new_widget(button_component, "button_component", self.prefab)
	gui.set_enabled(instance.root, true)

	return instance.root, instance
end


---@param index number
---@param node node
---@param instance examples.button_component
---@param data table
function M:on_element_add(index, node, instance, data)
	instance.text:set_text("Data Item " .. index)
	instance.button.on_click:subscribe(self.on_button_click, self)
	instance:set_data(index)
end


function M:on_element_remove(index, node, instance, data)
	instance.button.on_click:unsubscribe(self.on_button_click, self)
end


---@param instance examples.button_component
function M:on_button_click(instance)
	local data = instance:get_data()
	self.on_item_click:trigger(data)
end


---@param output_list output_list
function M:on_example_created(output_list)
	self.on_item_click:subscribe(function(index)
		output_list:add_log_text("Item clicked: " .. index)
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
	info = info .. "View Size Y: " .. gui.get(s.view_node, "size.y") .. "\n"
	info = info .. "Content Size Y: " .. gui.get(s.content_node, "size.y") .. "\n"
	info = info .. "Content position Y: " .. math.ceil(s.position.y) .. "\n"
	info = info .. "Content Range Y: " .. s.available_pos.y .. " - " .. s.available_pos.w .. "\n"

	return info
end


return M
