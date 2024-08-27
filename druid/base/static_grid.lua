-- Copyright (c) 2021 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Component to handle component's position by row and columns.
-- <b># Overview #</b>
--
-- The Static Grid component allows for positioning components in rows and columns.
-- It provides a static grid layout with constant node sizes, allowing for pre-calculated
-- node positions and the option to include gaps between nodes.
--
-- <b># Notes #</b>
--
-- • In a static grid, the node size remains constant, enabling the calculation of node
-- positions before placement. If you want add gaps between nodes, increase the root prefab size,
-- including the padding and margin.
--
-- • The static grid can automatically shift elements when nodes are added or removed.
--
-- • When a node is added, the grid will set the node's parent to the specified parent_node.
--
-- • You can obtain an array of positions for each element, which can be used to set
-- points of interest in a scroll component.
--
-- • The size of all elements can be retrieved for setting up the size in a scroll component.
--
-- • The grid can be bound to a scroll component for automatic resizing of the scroll content size.
--
-- • The pivot of the parent_node affects the node placement within the grid.
--
-- • A prefab node is used to determine the node size and anchor.
--
-- • You can specify a position_function for animations using the
-- _static_grid:set_position_function(node, pos) callback. The default position function is gui.set_position().
--
-- <a href="https://insality.github.io/druid/druid/index.html?example=general_grid" target="_blank"><b>Example Link</b></a>
-- @module StaticGrid
-- @within BaseComponent
-- @alias druid.static_grid

--- On item add callback(self, node, index)
-- @tfield DruidEvent on_add_item @{DruidEvent}

--- On item remove callback(self, index)
-- @tfield DruidEvent on_remove_item @{DruidEvent}

--- On item add, remove or change in_row callback(self, index|nil)
-- @tfield DruidEvent on_change_items @{DruidEvent}

--- On grid clear callback(self)
-- @tfield DruidEvent on_clear @{DruidEvent}

--- On update item positions callback(self)
-- @tfield DruidEvent on_update_positions @{DruidEvent}

--- Parent gui node
-- @tfield node parent

--- List of all grid nodes
-- @tfield node[] nodes

--- The first index of node in grid
-- @tfield number first_index

--- The last index of node in grid
-- @tfield number last_index

--- Item anchor [0..1]
-- @tfield vector3 anchor

--- Item pivot [-0.5..0.5]
-- @tfield vector3 pivot

--- Item size
-- @tfield vector3 node_size

--- The size of item content
-- @tfield vector4 border

---

local const = require("druid.const")
local Event = require("druid.event")
local helper = require("druid.helper")
local component = require("druid.component")

local StaticGrid = component.create("static_grid")


local function _extend_border(border, pos, size, pivot)
	local left = pos.x - size.x/2 - (size.x * pivot.x)
	local right = pos.x + size.x/2 - (size.x * pivot.x)
	local top = pos.y + size.y/2 - (size.y * pivot.y)
	local bottom = pos.y - size.y/2 - (size.y * pivot.y)

	border.x = math.min(border.x, left)
	border.y = math.max(border.y, top)
	border.z = math.max(border.z, right)
	border.w = math.min(border.w, bottom)
end


--- Component style params.
-- You can override this component styles params in druid styles table
-- or create your own style
-- @table style
-- @tfield boolean|nil IS_DYNAMIC_NODE_POSES If true, always center grid content as grid pivot sets. Default: false
-- @tfield boolean|nil IS_ALIGN_LAST_ROW If true, always align last row of the grid as grid pivot sets. Default: false
function StaticGrid.on_style_change(self, style)
	self.style = {}
	self.style.IS_DYNAMIC_NODE_POSES = style.IS_DYNAMIC_NODE_POSES or false
	self.style.IS_ALIGN_LAST_ROW = style.IS_ALIGN_LAST_ROW or false
end


--- The @{StaticGrid} constructor
-- @tparam StaticGrid self @{StaticGrid}
-- @tparam string|node parent The GUI Node container, where grid's items will be placed
-- @tparam node element Element prefab. Need to get it size
-- @tparam number|nil in_row How many nodes in row can be placed. By default 1
function StaticGrid.init(self, parent, element, in_row)
	self.parent = self:get_node(parent)
	self.nodes = {}

	self.pivot = helper.get_pivot_offset(gui.get_pivot(self.parent))
	self.anchor = vmath.vector3(0.5 + self.pivot.x, 0.5 - self.pivot.y, 0)

	self.in_row = in_row or 1

	self._prefab = self:get_node(element)
	self.node_size = gui.get_size(self._prefab)
	self.node_pivot = const.PIVOTS[gui.get_pivot(self._prefab)]

	self._grid_horizonal_offset = self.node_size.x * (self.in_row - 1) * self.anchor.x
	self._zero_offset = vmath.vector3(
		self.node_size.x * self.node_pivot.x - self.node_size.x * self.pivot.x - self._grid_horizonal_offset,
		self.node_size.y * self.node_pivot.y - self.node_size.y * self.pivot.y,
		0)

	self.border = vmath.vector4(0) -- Current grid content size

	self.on_add_item = Event()
	self.on_remove_item = Event()
	self.on_change_items = Event()
	self.on_clear = Event()
	self.on_update_positions = Event()

	self._set_position_function = gui.set_position
end


local _temp_pos = vmath.vector3(0)
--- Return pos for grid node index
-- @tparam StaticGrid self @{StaticGrid}
-- @tparam number index The grid element index
-- @treturn vector3 @Node position
function StaticGrid.get_pos(self, index)
	local row = math.ceil(index / self.in_row) - 1
	local col = (index - row * self.in_row) - 1

	local zero_offset_x = self:_get_zero_offset_x(row)

	_temp_pos.x = col * self.node_size.x + zero_offset_x
	_temp_pos.y = -row * self.node_size.y + self._zero_offset.y
	_temp_pos.z = 0

	return _temp_pos
end


--- Return index for grid pos
-- @tparam StaticGrid self @{StaticGrid}
-- @tparam vector3 pos The node position in the grid
-- @treturn number The node index
function StaticGrid.get_index(self, pos)
	local col = pos.x / self.node_size.x + 1
	local row = -pos.y / self.node_size.y

	col = helper.round(col)
	row = helper.round(row)

	local index = col + (row * self.in_row)
	return math.ceil(index)
end


--- Return grid index by node
-- @tparam StaticGrid self @{StaticGrid}
-- @tparam node node The gui node in the grid
-- @treturn number The node index
function StaticGrid.get_index_by_node(self, node)
	for index, grid_node in pairs(self.nodes) do
		if node == grid_node then
			return index
		end
	end

	return nil
end


function StaticGrid.on_layout_change(self)
	self:_update(true)
end


--- Set grid anchor. Default anchor is equal to anchor of grid parent node
-- @tparam StaticGrid self @{StaticGrid}
-- @tparam vector3 anchor Anchor
function StaticGrid.set_anchor(self, anchor)
	self.anchor = anchor
	self:_update()
end


--- Add new item to the grid
-- @tparam StaticGrid self @{StaticGrid}
-- @tparam node item GUI node
-- @tparam number|nil index The item position. By default add as last item
-- @tparam number|nil shift_policy How shift nodes, if required. Default: const.SHIFT.RIGHT
-- @tparam boolean|nil is_instant If true, update node positions instantly
function StaticGrid.add(self, item, index, shift_policy, is_instant)
	index = index or ((self.last_index or 0) + 1)

	helper.insert_with_shift(self.nodes, item, index, shift_policy)
	gui.set_parent(item, self.parent)

	-- Add new item instantly in new pos. Break update function for correct positioning
	self:_update_indexes()
	self:_update_borders()

	gui.set_position(item, self:get_pos(index) + self:_get_zero_offset())

	self:_update_pos(is_instant)

	self.on_add_item:trigger(self:get_context(), item, index)
	self.on_change_items:trigger(self:get_context(), index)
end


--- Remove the item from the grid. Note that gui node will be not deleted
-- @tparam StaticGrid self @{StaticGrid}
-- @tparam number index The grid node index to remove
-- @tparam number|nil shift_policy How shift nodes, if required. Default: const.SHIFT.RIGHT
-- @tparam boolean|nil is_instant If true, update node positions instantly
-- @treturn node The deleted gui node from grid
function StaticGrid.remove(self, index, shift_policy, is_instant)
	assert(self.nodes[index], "No grid item at given index " .. index)

	local remove_node = self.nodes[index]
	helper.remove_with_shift(self.nodes, index, shift_policy)

	self:_update(is_instant)

	self.on_remove_item:trigger(self:get_context(), index)
	self.on_change_items:trigger(self:get_context(), index)

	return remove_node
end


--- Return grid content size
-- @tparam StaticGrid self @{StaticGrid}
-- @treturn vector3 The grid content size
function StaticGrid.get_size(self)
	return vmath.vector3(
		self.border.z - self.border.x,
		self.border.y - self.border.w,
		0)
end


function StaticGrid.get_size_for(self, count)
	if not count or count == 0 then
		return vmath.vector3(0)
	end

	local border = vmath.vector4(math.huge, -math.huge, -math.huge, math.huge)

	local size = self.node_size
	local pivot = self.node_pivot
	_extend_border(border, self:get_pos(1), size, pivot)
	_extend_border(border, self:get_pos(count), size, pivot)
	if count >= self.in_row then
		_extend_border(border, self:get_pos(self.in_row), size, pivot)
	end

	return vmath.vector3(
		border.z - border.x,
		border.y - border.w,
		0)
end


--- Return grid content borders
-- @tparam StaticGrid self @{StaticGrid}
-- @treturn vector3 The grid content borders
function StaticGrid.get_borders(self)
	return self.border
end


--- Return array of all node positions
-- @tparam StaticGrid self @{StaticGrid}
-- @treturn vector3[] All grid node positions
function StaticGrid.get_all_pos(self)
	local result = {}
	for i, node in pairs(self.nodes) do
		table.insert(result, gui.get_position(node))
	end

	return result
end


--- Change set position function for grid nodes. It will call on
-- update poses on grid elements. Default: gui.set_position
-- @tparam StaticGrid self @{StaticGrid}
-- @tparam function callback Function on node set position
-- @treturn druid.static_grid Current grid instance
function StaticGrid.set_position_function(self, callback)
	self._set_position_function = callback or gui.set_position

	return self
end


--- Clear grid nodes array. GUI nodes will be not deleted!
-- If you want to delete GUI nodes, use static_grid.nodes array before grid:clear
-- @tparam StaticGrid self @{StaticGrid}
-- @treturn druid.static_grid Current grid instance
function StaticGrid.clear(self)
	self.border.x = 0
	self.border.y = 0
	self.border.w = 0
	self.border.z = 0

	self.nodes = {}
	self:_update()

	self.on_clear:trigger(self:get_context())

	return self
end


--- Return StaticGrid offset, where StaticGrid content starts.
-- @tparam StaticGrid self @{StaticGrid} The StaticGrid instance
-- @treturn vector3 The StaticGrid offset
function StaticGrid:get_offset()
	local borders = self:get_borders()
	local size = self:get_size()

	local offset = vmath.vector3(
		(borders.z + borders.x)/2 + size.x * self.pivot.x,
		(borders.y + borders.w)/2 + size.y * self.pivot.y,
		0)

	return offset
end


--- Set new in_row elements for grid
-- @tparam StaticGrid self @{StaticGrid}
-- @tparam number in_row The new in_row value
-- @treturn druid.static_grid Current grid instance
function StaticGrid.set_in_row(self, in_row)
	self.in_row = in_row
	self._grid_horizonal_offset = self.node_size.x * (self.in_row - 1) * self.anchor.x
	self._zero_offset = vmath.vector3(
		self.node_size.x * self.node_pivot.x - self.node_size.x * self.pivot.x - self._grid_horizonal_offset,
		self.node_size.y * self.node_pivot.y - self.node_size.y * self.pivot.y,
		0)

	self:_update(true)
	self.on_change_items:trigger(self:get_context())

	return self
end


--- Update grid inner state
-- @tparam StaticGrid self @{StaticGrid}
-- @tparam boolean|nil is_instant If true, node position update instantly, otherwise with set_position_function callback
-- @local
function StaticGrid._update(self, is_instant)
	self:_update_indexes()
	self:_update_borders()
	self:_update_pos(is_instant)
end


--- Update first and last indexes of grid nodes
-- @tparam StaticGrid self @{StaticGrid}
-- @local
function StaticGrid._update_indexes(self)
	self.first_index = nil
	self.last_index = nil
	for index in pairs(self.nodes) do
		self.first_index = self.first_index or index
		self.last_index = self.last_index or index

		self.first_index = math.min(self.first_index, index)
		self.last_index = math.max(self.last_index, index)
	end
end


--- Update grid content borders, recalculate min and max values
-- @tparam StaticGrid self @{StaticGrid}
-- @local
function StaticGrid._update_borders(self)
	if not self.first_index then
		self.border = vmath.vector4(0)
		return
	end

	self.border = vmath.vector4(math.huge, -math.huge, -math.huge, math.huge)

	local size = self.node_size
	local pivot = self.node_pivot
	for index, node in pairs(self.nodes) do
		_extend_border(self.border, self:get_pos(index), size, pivot)
	end
end


--- Update grid nodes position
-- @tparam StaticGrid self @{StaticGrid}
-- @tparam boolean|nil is_instant If true, node position update instantly, otherwise with set_position_function callback
-- @local
function StaticGrid._update_pos(self, is_instant)
	local zero_offset = self:_get_zero_offset()

	for i, node in pairs(self.nodes) do
		local pos = self:get_pos(i)
		pos.x = pos.x + zero_offset.x
		pos.y = pos.y + zero_offset.y

		if is_instant then
			gui.set_position(node, pos)
		else
			self._set_position_function(node, pos)
		end
	end

	self.on_update_positions:trigger(self:get_context())
end


--- Return elements offset for correct posing nodes. Correct posing at
-- parent pivot node (0:0) with adjusting of node sizes and anchoring
-- @treturn vector3 The offset vector
-- @local
function StaticGrid:_get_zero_offset()
	if not self.style.IS_DYNAMIC_NODE_POSES then
		return const.VECTOR_ZERO
	end

	-- zero offset: center pos - border size * anchor
	return vmath.vector3(
		-((self.border.x + self.border.z)/2 + (self.border.z - self.border.x) * self.pivot.x),
		-((self.border.y + self.border.w)/2 + (self.border.y - self.border.w) * self.pivot.y),
		0
	)
end


--- Return offset x for last row in grid. Used to align this row accorting to grid's anchor
-- @treturn number The offset x value
-- @local
function StaticGrid:_get_zero_offset_x(row_index)
	if not self.style.IS_DYNAMIC_NODE_POSES or not self.style.IS_ALIGN_LAST_ROW then
		return self._zero_offset.x
	end

	local offset_x = self._zero_offset.x
	local last_row = math.ceil(self.last_index / self.in_row) - 1

	if last_row > 0 and last_row == row_index then
		local elements_in_row = (self.last_index - (last_row * self.in_row)) - 1
		local offset = elements_in_row * self.node_size.x * self.anchor.x
		offset_x = self.node_size.x * self.node_pivot.x - self.node_size.x * self.pivot.x - offset
	end

	return offset_x
end


return StaticGrid
