local Card = require("example.examples.layout.cards.scroll_bind_layout_card")

---@class examples.scroll_bind_layout_cards: druid.widget
---@field scroll druid.scroll
---@field layout druid.layout
---@field text druid.text
local M = {}

function M:init()
	self.created_nodes = {}

	self.button_left = self.druid:new_button("button_left", self.on_button_click, -1)
	self.button_right = self.druid:new_button("button_right", self.on_button_click, 1)

	self.prefab = self:get_node("scroll_bind_layout_card/root")
	gui.set_enabled(self.prefab, false)

	self.scroll = self.druid:new_scroll("view", "layout")
	self.layout = self.druid:new_layout("layout", "horizontal")
		:set_hug_content(true, false)

	self.layout.on_size_changed:subscribe(self.on_layout_updated, self)

	self.scroll:bind_layout(self.layout)
	self.scroll:set_vertical_scroll(false)
	self.scroll.on_scroll:subscribe(self.refresh_scroll)

	self:init_elements(20)
	self.scroll:scroll_to_index(4, false, true)

	self.output_log = nil
end


function M:on_remove()
	for _, card in ipairs(self.cards) do
		self.druid:remove(card)
		gui.delete_node(card.root)
	end
	self.cards = {}
end


---@param output_log output_list
function M:on_example_created(output_log)
	self.output_log = output_log
end


function M:init_elements(count)
	self.cards = {}

	for index = 1, count do
		self:create_element()
	end

	self.level = 1

	self.layout:refresh_layout()

	self:refresh_scroll(self.scroll.position)
end


---@return widget.scroll_bind_layout_card
function M:create_element()
	local index = #self.cards + 1

	local card = self.druid:new_widget(Card, "scroll_bind_layout_card", "root")
	card:set_level(index)
	card.on_select:subscribe(self.on_level_start, self)

	gui.set_enabled(card.root, true)

	self.layout:add(card.root)
	table.insert(self.cards, card)

	return card
end


function M:on_level_start(level)
	self.output_log:add_log_text("Level started: " .. level)
end


---@param direction number
function M:on_button_click(direction)
	self.scroll:scroll_to_index(self.selected_index + direction)
end


---@param position vector3
function M:refresh_scroll(position)
	local percent = self.scroll:get_percent()
	local is_left_enabled = percent.x > 0.02
	local is_right_enabled = percent.x < 0.98
	gui.set_enabled(self.button_left.node, is_left_enabled)
	gui.set_enabled(self.button_right.node, is_right_enabled)

	for _, card in ipairs(self.cards) do
		card:set_on_scroll_position(position)
	end

	do -- Find selected card by position
		local closest_index = nil
		local closest_distance = math.huge

		for index, card in ipairs(self.cards) do
			local distance = card:get_distance(position)
			if distance < closest_distance then
				closest_distance = distance
				closest_index = index
			end
		end

		self.selected_index = closest_index
	end
end


function M:on_layout_updated(size)
	local points = {}
	for index = 1, #self.cards do
		table.insert(points, gui.get_position(self.cards[index].root))
	end
	self.scroll:set_points(points)
end


---@param properties_panel properties_panel
function M:properties_control(properties_panel)
	properties_panel:add_button("ui_add_element", function()
		if #self.created_nodes >= 100 then
			return
		end
		self:create_element()
	end)
end


---@return string
function M:get_debug_info()
	local info = ""

	local s = self.scroll
	local view_node_size = gui.get(s.view_node, "size.y")
	local scroll_position = -s.position
	local scroll_bottom_position = vmath.vector3(scroll_position.x, scroll_position.y - view_node_size, scroll_position.z)

	info = info .. "View Size Y: " .. gui.get(s.view_node, "size.y") .. "\n"
	info = info .. "Content Size Y: " .. gui.get(s.content_node, "size.y") .. "\n"
	info = info .. "Content position Y: " .. math.ceil(s.position.y) .. "\n"
	info = info .. "Content Range Y: " .. s.available_pos.y .. " - " .. s.available_pos.w .. "\n"
	info = info .. "Layout Items: " .. #self.layout.entities .. "\n"

	return info
end


return M
