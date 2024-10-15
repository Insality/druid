-- Copyright (c) 2024 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Layout management on node
--
-- <a href="https://insality.github.io/druid/druid/index.html?example=general_layout" target="_blank"><b>Example Link</b></a>
-- @module Layout
-- @within BaseComponent
-- @alias druid.layout

--- Layout node
-- @tfield node node

--- Current layout mode
-- @tfield string mode

---

local helper = require("druid.helper")
local component = require("druid.component")

-- @class druid.layout.row_data
-- @tfield width number
-- @tfield height number
-- @tfield count number

-- @class druid.layout.rows_data
-- @tfield total_width number
-- @tfield total_height number
-- @tfield nodes_width table<node, number>
-- @tfield nodes_height table<node, number>
-- @tfield rows druid.layout.row_data[]>

-- @class druid.layout: druid.base_component
local M = component.create("layout")

-- The @{Layout} constructor
-- @tparam Layout self @{Layout}
-- @tparam node node Gui node
-- @tparam string layout_type The layout mode (from const.LAYOUT_MODE)
-- @tparam function|nil on_size_changed_callback The callback on window resize
function M.init(self, node, layout_type)
	self.node = self:get_node(node)

	self.is_dirty = true
	self.entities = {}
	self.margin = { x = 0, y = 0 }
	self.padding = gui.get_slice9(self.node)
	self.type = layout_type or "horizontal"
	self.is_resize_width = false
	self.is_resize_height = false
	self.is_justify = false
end

function M:update()
	if not self.is_dirty then
		return
	end

	self:refresh_layout()
end


-- @tparam Layout self @{Layout}
-- @tparam number|nil margin_x
-- @tparam number|nil margin_y
-- @treturn druid.layout @{Layout}
function M.set_margin(self, margin_x, margin_y)
	self.margin.x = margin_x or self.margin.x
	self.margin.y = margin_y or self.margin.y
	self.is_dirty = true

	return self
end


-- @tparam Layout self @{Layout}
-- @tparam vector4 padding The vector4 with padding values, where x - left, y - top, z - right, w - bottom
-- @treturn druid.layout @{Layout}
function M.set_padding(self, padding)
	self.padding = padding
	self.is_dirty = true

	return self
end


-- @tparam Layout self @{Layout}
-- @treturn druid.layout @{Layout}
function M.set_dirty(self)
	self.is_dirty = true

	return self
end


-- @tparam Layout self @{Layout}
-- @tparam boolean is_justify
-- @treturn druid.layout @{Layout}
function M.set_justify(self, is_justify)
	self.is_justify = is_justify
	self.is_dirty = true

	return self
end


-- @tparam Layout self @{Layout}
-- @tparam string type The layout type: "horizontal", "vertical", "horizontal_wrap"
-- @treturn druid.layout @{Layout}
function M.set_type(self, type)
	self.type = type
	self.is_dirty = true

	return self
end


-- @tparam Layout self @{Layout}
-- @tparam boolean is_hug_width
-- @tparam boolean is_hug_height
-- @treturn druid.layout @{Layout}
function M.set_hug_content(self, is_hug_width, is_hug_height)
	self.is_resize_width = is_hug_width or false
	self.is_resize_height = is_hug_height or false
	self.is_dirty = true

	return self
end


-- @tparam Layout self @{Layout}
-- @tparam string|node node_or_node_id
-- @treturn druid.layout @{Layout}
function M.add(self, node_or_node_id)
	-- Acquire node from entity or by id
	local node = node_or_node_id
	if type(node_or_node_id) == "table" then
		assert(node_or_node_id.node, "The entity should have a node")
		node = node_or_node_id.node
	else
		-- @cast node_or_node_id string|node
		node = self:get_node(node_or_node_id)
	end

	-- @cast node node
	table.insert(self.entities, node)
	gui.set_parent(node, self.node)

	self.is_dirty = true

	return self
end


-- @tparam Layout self @{Layout}
-- @treturn druid.layout @{Layout}
function M.refresh_layout(self)
	local layout_node = self.node

	local entities = self.entities
	local type = self.type -- vertical, horizontal, horizontal_wrap
	local margin = self.margin -- {x: horizontal, y: vertical} in pixels, between elements
	local padding = self.padding -- {x: left, y: top, z: right, w: bottom} in pixels
	local is_justify = self.is_justify
	local size = gui.get_size(layout_node)
	local max_width = size.x - padding.x - padding.z
	local max_height = size.y - padding.y - padding.w
	local layout_pivot_offset = helper.get_pivot_offset(gui.get_pivot(layout_node)) -- {x: -0.5, y: -0.5} - is left bot, {x: 0.5, y: 0.5} - is right top

	local rows_data = self:calculate_rows_data()
	local rows = rows_data.rows
	local row_index = 1
	local row = rows[row_index]

	-- Current x and Current y is a top left corner of the node
	local current_x = -row.width * (0.5 + layout_pivot_offset.x)
	local current_y = rows_data.total_height * (0.5 - layout_pivot_offset.y)

	if is_justify then
		if (type == "horizontal" or type == "horizontal_wrap") and row.count > 1 then
			current_x = -max_width * (0.5 + layout_pivot_offset.x)
		end
		if type == "vertical" then
			current_y = max_height * (0.5 - layout_pivot_offset.y)
		end
	end

	for index = 1, #entities do
		local node = entities[index]
		local node_width = rows_data.nodes_width[node]
		local node_height = rows_data.nodes_height[node]
		local pivot_offset = helper.get_pivot_offset(gui.get_pivot(node))

		if node_width > 0 and node_height > 0 then
			-- Calculate position for current node
			local position_x, position_y

			if type == "horizontal" then
				position_x = current_x + node_width * (0.5 + pivot_offset.x)
				position_y = current_y - row.height * (0.5 - pivot_offset.y)

				local node_margin = margin.x
				if is_justify and row.count > 1 then
					node_margin = (max_width - row.width) / (row.count - 1) + margin.x
				end
				current_x = current_x + node_width + node_margin
			end

			if type == "vertical" then
				position_x = current_x + row.width * (0.5 - pivot_offset.x)
				position_y = current_y - node_height * (0.5 + pivot_offset.y)

				local node_margin = margin.y
				if is_justify then
					node_margin = (max_height - rows_data.total_height) / (#rows - 1) + margin.y
				end

				current_y = current_y - node_height - node_margin
			end

			if type == "horizontal_wrap" then
				local width = row.width
				if is_justify and row.count > 0 then
					width = math.max(row.width, max_width)
				end
				local new_row_width = width * (0.5 - layout_pivot_offset.x)

				-- Compare with eps due the float loss and element flickering
				if current_x + node_width - new_row_width > 0.0001 then
					if row_index < #rows then
						row_index = row_index + 1
						row = rows[row_index]
					end

					current_x = -row.width * (0.5 + layout_pivot_offset.x)
					current_y = current_y - row.height - margin.y
					if is_justify and row.count > 1 then
						current_x = -max_width * (0.5 + layout_pivot_offset.x)
					end
				end

				position_x = current_x + node_width * (0.5 + pivot_offset.x)
				position_y = current_y - row.height * (0.5 - pivot_offset.y)

				local node_margin = margin.x
				if is_justify and row.count > 1 then
					node_margin = (max_width - row.width) / (row.count - 1) + margin.x
				end
				current_x = current_x + node_width + node_margin
			end

			do -- Padding offset
				if layout_pivot_offset.x == -0.5 then
					position_x = position_x + padding.x
				end
				if layout_pivot_offset.y == 0.5 then
					position_y = position_y - padding.y
				end
				if layout_pivot_offset.x == 0.5 then
					position_x = position_x - padding.z
				end
				if layout_pivot_offset.y == -0.5 then
					position_y = position_y + padding.w
				end
			end

			self:set_node_position(node, position_x, position_y)
		end
	end

	if self.is_resize_width or self.is_resize_height then
		if self.is_resize_width then
			size.x = rows_data.total_width + padding.x + padding.z
		end
		if self.is_resize_height then
			size.y = rows_data.total_height + padding.y + padding.w
		end
		gui.set_size(layout_node, size)
	end

	self.is_dirty = false

	return self
end


-- @tparam Layout self @{Layout}
-- @treturn druid.layout @{Layout}
function M.clear_layout(self)
	for index = #self.entities, 1, -1 do
		self.entities[index] = nil
	end

	self.is_dirty = true

	return self
end


-- @tparam node node
-- @treturn number, number
-- @local
function M.get_node_size(node)
	if not gui.is_enabled(node, false) then
		return 0, 0
	end

	local scale = gui.get_scale(node)

	-- If node has text - get text size instead of node size
	if gui.get_text(node) then
		local text_metrics = helper.get_text_metrics_from_node(node)
		return text_metrics.width * scale.x, text_metrics.height * scale.y
	end

	local size = gui.get_size(node)
	return size.x * scale.x, size.y * scale.y
end


-- @tparam Layout self @{Layout}
-- Calculate rows data for layout. Contains total width, height and rows info (width, height, count of elements in row)
-- @treturn druid.layout.rows_data
-- @local
function M.calculate_rows_data(self)
	local entities = self.entities
	local margin = self.margin
	local type = self.type
	local padding = self.padding

	local size = gui.get_size(self.node)
	local max_width = size.x - padding.x - padding.z

	-- Collect rows info about width, height and count of elements in row
	local current_row = { width = 0, height = 0, count = 0 }
	local rows_data = {
		total_width = 0,
		total_height = 0,
		nodes_width = {},
		nodes_height = {},
		rows = { current_row }
	}

	for index = 1, #entities do
		local node = entities[index]
		local node_width = rows_data.nodes_width[node]
		local node_height = rows_data.nodes_height[node]

		-- Get node size if it's not calculated yet
		if not node_width or not node_height then
			node_width, node_height = M.get_node_size(node)
			rows_data.nodes_width[node] = node_width
			rows_data.nodes_height[node] = node_height
		end

		if node_width > 0 and node_height > 0 then
			if type == "horizontal" then
				current_row.width = current_row.width + node_width + margin.x
				current_row.height = math.max(current_row.height, node_height)
				current_row.count = current_row.count + 1
			end

			if type == "vertical" then
				if current_row.count > 0 then
					current_row = { width = 0, height = 0, count = 0 }
					table.insert(rows_data.rows, current_row)
				end

				current_row.width = math.max(current_row.width, node_width + margin.x)
				current_row.height = node_height
				current_row.count = current_row.count + 1
			end

			if type == "horizontal_wrap" then
				if current_row.width + node_width > max_width and current_row.count > 0 then
					current_row = { width = 0, height = 0, count = 0 }
					table.insert(rows_data.rows, current_row)
				end

				current_row.width = current_row.width + node_width + margin.x
				current_row.height = math.max(current_row.height, node_height)
				current_row.count = current_row.count + 1
			end
		end
	end

	-- Remove last margin of each row
	-- Calculate total width and height
	local rows_count = #rows_data.rows
	for index = 1, rows_count do
		local row = rows_data.rows[index]
		if row.width > 0 then
			row.width = row.width - margin.x
		end

		rows_data.total_width = math.max(rows_data.total_width, row.width)
		rows_data.total_height = rows_data.total_height + row.height
	end

	rows_data.total_height = rows_data.total_height + margin.y * (rows_count - 1)
	return rows_data
end

-- @tparam node node
-- @tparam number x
-- @tparam number y
-- @treturn node
-- @local
function M:set_node_position(node, x, y)
	local position = gui.get_position(node)
	position.x = x
	position.y = y
	gui.set_position(node, position)

	return node
end

return M
