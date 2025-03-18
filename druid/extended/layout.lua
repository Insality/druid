local event = require("event.event")
local helper = require("druid.helper")
local component = require("druid.component")

---@alias druid.layout.mode "horizontal"|"vertical"|"horizontal_wrap"

---@class event.on_size_changed: event
---@field subscribe fun(_, callback: fun(new_size: vector3), context: any|nil)

---@class druid.layout.row_data
---@field width number
---@field height number
---@field count number

---@class druid.layout.rows_data
---@field total_width number
---@field total_height number
---@field nodes_width table<node, number>
---@field nodes_height table<node, number>
---@field rows druid.layout.row_data[]>

---The component used for managing the layout of nodes, placing them inside the node size with respect to the size and pivot of each node
---@class druid.layout: druid.component
---@field node node The node to manage the layout of
---@field rows_data druid.layout.rows_data Last calculated rows data
---@field is_dirty boolean
---@field entities node[] The entities to manage the layout of
---@field margin {x: number, y: number} The margin of the layout
---@field padding vector4 The padding of the layout
---@field type string The type of the layout
---@field is_resize_width boolean True if the layout should resize the width of the node
---@field is_resize_height boolean True if the layout should resize the height of the node
---@field is_justify boolean True if the layout should justify the nodes
---@field on_size_changed event.on_size_changed The event triggered when the size of the layout is changed
local M = component.create("layout")


---@param node_or_node_id node|string
---@param layout_type druid.layout.mode
function M:init(node_or_node_id, layout_type)
	self.node = self:get_node(node_or_node_id)

	self.is_dirty = true
	self.entities = {}
	self.size = gui.get_size(self.node)

	self.padding = gui.get_slice9(self.node)
	-- Grab default margins from slice9 z/w values
	self.margin = { x = self.padding.z, y = self.padding.w }
	-- Use symmetrical padding from x/z
	self.padding.z = self.padding.x
	self.padding.w = self.padding.y

	self.type = layout_type or "horizontal"
	self.is_resize_width = false
	self.is_resize_height = false
	self.is_justify = false

	self.on_size_changed = event.create() --[[@as event.on_size_changed]]
end


function M:update()
	if not self.is_dirty then
		return
	end

	self:refresh_layout()
end


---@return node[] entities The entities to manage the layout of
function M:get_entities()
	return self.entities
end


---@param node node The node to set the index of
---@param index number The index to set the node to
---@return druid.layout self for chaining
function M:set_node_index(node, index)
	for i = 1, #self.entities do
		if self.entities[i] == node then
			table.remove(self.entities, i)
			table.insert(self.entities, index, node)
			break
		end
	end

	return self
end


---Set the margin of the layout
---@param margin_x number|nil The margin x
---@param margin_y number|nil The margin y
---@return druid.layout self Current layout instance
function M:set_margin(margin_x, margin_y)
	self.margin.x = margin_x or self.margin.x
	self.margin.y = margin_y or self.margin.y
	self.is_dirty = true

	return self
end


---@param padding_x number|nil The padding x
---@param padding_y number|nil The padding y
---@param padding_z number|nil The padding z
---@param padding_w number|nil The padding w
---@return druid.layout self Current layout instance
function M:set_padding(padding_x, padding_y, padding_z, padding_w)
	self.padding.x = padding_x or self.padding.x
	self.padding.y = padding_y or self.padding.y
	self.padding.z = padding_z or self.padding.z
	self.padding.w = padding_w or self.padding.w
	self.is_dirty = true

	return self
end


---@return druid.layout self Current layout instance
function M:set_dirty()
	self.is_dirty = true

	return self
end


---@param is_justify boolean
---@return druid.layout self Current layout instance
function M:set_justify(is_justify)
	self.is_justify = is_justify
	self.is_dirty = true

	return self
end


---@param type string The layout type: "horizontal", "vertical", "horizontal_wrap"
---@return druid.layout self Current layout instance
function M:set_type(type)
	self.type = type
	self.is_dirty = true

	return self
end


---@param is_hug_width boolean
---@param is_hug_height boolean
---@return druid.layout self Current layout instance
function M:set_hug_content(is_hug_width, is_hug_height)
	self.is_resize_width = is_hug_width or false
	self.is_resize_height = is_hug_height or false
	self.is_dirty = true

	return self
end


---Add node to layout
---@param node_or_node_id node|string node_or_node_id
---@return druid.layout self Current layout instance
function M:add(node_or_node_id)
	-- Acquire node from entity or by id
	local node = node_or_node_id
	if type(node_or_node_id) == "table" then
		assert(node_or_node_id.node, "The entity should have a node")
		node = node_or_node_id.node
	else
		---@cast node_or_node_id string|node
		node = self:get_node(node_or_node_id)
	end

	---@cast node node
	table.insert(self.entities, node)
	gui.set_parent(node, self.node)
	self.is_dirty = true

	return self
end


---Remove node from layout
---@param node_or_node_id node|string node_or_node_id
---@return druid.layout self for chaining
function M:remove(node_or_node_id)
	local node = type(node_or_node_id) == "table" and node_or_node_id.node or self:get_node(node_or_node_id)

	for index = #self.entities, 1, -1 do
		if self.entities[index] == node then
			table.remove(self.entities, index)
			self.is_dirty = true
			break
		end
	end

	return self
end


---@return vector3
function M:get_size()
	return self.size
end


---@return number, number
function M:get_content_size()
	local width = self.size.x - self.padding.x - self.padding.z
	local height = self.size.y - self.padding.y - self.padding.w
	return width, height
end


---@return druid.layout self Current layout instance
function M:refresh_layout()
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
	self.rows_data = rows_data
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

		if node_width > 0 or node_height > 0 then
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
				local node_margin = margin.y
				if is_justify then
					node_margin = (max_height - rows_data.total_height) / (#rows - 1) + margin.y
				end

				current_x = -row.width * (0.5 + layout_pivot_offset.x)

				position_x = current_x + row.width * (0.5 + pivot_offset.x)
				position_y = current_y - node_height * (0.5 - pivot_offset.y)

				current_y = current_y - node_height - node_margin

				row_index = row_index + 1
				row = rows[row_index]
			end

			if type == "horizontal_wrap" then
				local width = row.width
				if is_justify and row.count > 0 then
					width = math.max(row.width, max_width)
				end
				local new_row_width = width * (0.5 - layout_pivot_offset.x)

				-- Compare with eps due the float loss and element flickering
				if current_x + node_width - new_row_width > 0.00001 then
					current_y = current_y - row.height - margin.y

					if row_index < #rows then
						row_index = row_index + 1
						row = rows[row_index]
					end

					current_x = -row.width * (0.5 + layout_pivot_offset.x)

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
		self.size = size

		self.on_size_changed(size)
	end

	self.is_dirty = false

	return self
end


---@return druid.layout self Current layout instance
function M:clear_layout()
	for index = #self.entities, 1, -1 do
		self.entities[index] = nil
	end

	self.is_dirty = true

	return self
end


---@param node node
---@return number width The width of the node
---@return number height The height of the node
function M:get_node_size(node)
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


---Calculate rows data for layout. Contains total width, height and rows info (width, height, count of elements in row)
---@local
---@return druid.layout.rows_data
function M:calculate_rows_data()
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
			node_width, node_height = self:get_node_size(node)
			rows_data.nodes_width[node] = node_width
			rows_data.nodes_height[node] = node_height
		end

		if node_width > 0 or node_height > 0 then
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


---Will reset z value to 0!
local TEMP_VECTOR = vmath.vector3(0, 0, 0)
---@param node node
---@param x number
---@param y number
---@return node
function M:set_node_position(node, x, y)
	TEMP_VECTOR.x = x
	TEMP_VECTOR.y = y
	gui.set_position(node, TEMP_VECTOR)

	return node
end


return M
