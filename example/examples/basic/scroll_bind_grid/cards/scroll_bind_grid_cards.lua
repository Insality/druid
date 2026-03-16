local Card = require("example.examples.basic.scroll_bind_grid.cards.scroll_bind_grid_card")

---@class examples.scroll_bind_grid_cards: druid.widget
---@field scroll druid.scroll
---@field grid druid.grid
---@field text druid.text
---@field cards widget.scroll_bind_grid_card[]
local M = {}

function M:init()
	self.created_nodes = {}

	self.button_left = self.druid:new_button("button_left", self.on_button_click, -1)
	self.button_right = self.druid:new_button("button_right", self.on_button_click, 1)

	self.prefab = self:get_node("scroll_bind_grid_card/root")
	gui.set_enabled(self.prefab, false)

	self.scroll = self.druid:new_scroll("view", "content")
	self.grid = self.druid:new_grid("content", "scroll_bind_grid_card/root", 9999)

	self.scroll:bind_grid(self.grid)
	self.scroll:set_vertical_scroll(false)
	self.scroll.on_scroll:subscribe(self.refresh_scroll)

	self:init_elements(20)
	self.scroll:scroll_to_index(1, false, true)

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

	self:_refresh_grid()
end


---@return widget.scroll_bind_grid_card
function M:create_element()
	local index = #self.cards + 1

	local card = self.druid:new_widget(Card, "scroll_bind_grid_card", "root")
	card:set_level(index)
	card.on_select:subscribe(self.on_level_start, self)

	gui.set_enabled(card.root, true)

	self.grid:add(card.root)
	table.insert(self.cards, card)

	return card
end


function M:on_level_start(level)
	self.output_log:add_log_text("Level started: " .. level)
end


function M:on_button_click(direction)
	local current_index = self.grid:get_index(-self.scroll.position + vmath.vector3(0, -100, 0))
	self.scroll:scroll_to_index(current_index + direction)
end


--- Refresh all elements relative to scroll position
---@param position vector3
function M:refresh_scroll(position)
	local percent = self.scroll:get_percent()
	local is_left_enabled = percent.x > 0.01
	local is_right_enabled = percent.x < 0.99
	gui.set_enabled(self.button_left.node, is_left_enabled)
	gui.set_enabled(self.button_right.node, is_right_enabled)

	for _, card in ipairs(self.cards) do
		card:set_on_scroll_position(position)
	end
end


function M:_refresh_grid()
	-- Since grid size restric scroll to center of first and last elements,
	-- we need to extend left and right area. For example we can do it in this way:
	-- It's a amount of pixels, how much need to extend one side to align side elements
	local extra_size = 250
	self.scroll:set_size(
		self.grid:get_size() + vmath.vector3(extra_size * 2, 0, 0)
	)

	-- Update points of interest
	local points = self.grid:get_all_pos()
	self.scroll:set_points(points)
end


---@param properties_panel properties_panel
function M:properties_control(properties_panel)
	properties_panel:add_button("ui_add_element", function()
		if #self.created_nodes >= 100 then
			return
		end
		self:create_element()
		self:_refresh_grid()
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
	info = info .. "Grid Items: " .. #self.grid.nodes .. "\n"
	info = info .. "Grid Item Size: " .. self.grid.node_size.x .. " x " .. self.grid.node_size.y .. "\n"
	info = info .. "Top Scroll Pos Grid Index: " .. self.grid:get_index(scroll_position) .. "\n"
	info = info .. "Bottm Scroll Pos Grid Index: " .. self.grid:get_index(scroll_bottom_position) .. "\n"

	return info
end


return M
