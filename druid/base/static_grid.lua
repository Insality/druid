local const = require("druid.const")
local event = require("event.event")
local helper = require("druid.helper")
local component = require("druid.component")

---@class druid.grid.style
---@field IS_DYNAMIC_NODE_POSES boolean|nil If true, always center grid content as grid pivot sets. Default: false
---@field IS_ALIGN_LAST_ROW boolean|nil If true, always align last row of the grid as grid pivot sets. Default: false

---The component for manage the nodes position in the grid with various options
---@class druid.grid: druid.component
---@field on_add_item event Trigger on add item event, fun(self, item, index)
---@field on_remove_item event Trigger on remove item event, fun(self, index)
---@field on_change_items event Trigger on change items event, fun(self, index)
---@field on_clear event Trigger on clear event, fun(self)
---@field on_update_positions event Trigger on update positions event, fun(self)
---@field parent node Parent node
---@field nodes node[] Nodes array
---@field first_index number First index
---@field last_index number Last index
---@field anchor vector3 Anchor
---@field pivot vector3 Pivot
---@field node_size vector3 Node size
---@field border vector4 Border
---@field in_row number In row
---@field style druid.grid.style Style
local M = component.create("grid")


---The constructor for the grid component
---@param parent string|node The GUI Node container, where grid's items will be placed
---@param element node Element prefab. Need to get it size
---@param in_row number|nil How many nodes in row can be placed. By default 1
function M:init(parent, element, in_row)
	self.parent = self:get_node(parent)
	self.nodes = {}

	self.pivot = helper.get_pivot_offset(self.parent)
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

	self.on_add_item = event.create()
	self.on_remove_item = event.create()
	self.on_change_items = event.create()
	self.on_clear = event.create()
	self.on_update_positions = event.create()

	self._set_position_function = gui.set_position
end


---@param style druid.grid.style
function M:on_style_change(style)
	self.style = {
		IS_DYNAMIC_NODE_POSES = style.IS_DYNAMIC_NODE_POSES or false,
		IS_ALIGN_LAST_ROW = style.IS_ALIGN_LAST_ROW or false,
	}
end


local _temp_pos = vmath.vector3(0)
---Return pos for grid node index
---@param index number The grid element index
---@return vector3 position Node position
function M:get_pos(index)
	local row = math.ceil(index / self.in_row) - 1
	local col = (index - row * self.in_row) - 1

	local zero_offset_x = self:_get_zero_offset_x(row)

	_temp_pos.x = col * self.node_size.x + zero_offset_x
	_temp_pos.y = -row * self.node_size.y + self._zero_offset.y
	_temp_pos.z = 0

	return _temp_pos
end


---Return grid index by position
---@param pos vector3 The node position in the grid
---@return number index The node index
function M:get_index(pos)
	-- Offset to left-top corner from node pivot
	local node_offset_x = self.node_size.x * (-0.5 + self.node_pivot.x)
	local node_offset_y = self.node_size.y * (0.5 - self.node_pivot.y)

	local col = (pos.x + node_offset_x) / self.node_size.x + 1
	local row = -(pos.y + node_offset_y) / self.node_size.y

	col = helper.round(col)
	row = helper.round(row)

	local index = col + (row * self.in_row)
	return math.ceil(index)
end


---Return grid index by node
---@param node node The gui node in the grid
---@return number|nil index The node index
function M:get_index_by_node(node)
	for index, grid_node in pairs(self.nodes) do
		if node == grid_node then
			return index
		end
	end

	return nil
end


function M:on_layout_change()
	self:_update(true)
end


---Set grid anchor. Default anchor is equal to anchor of grid parent node
---@param anchor vector3 Anchor
function M:set_anchor(anchor)
	self.anchor = anchor
	self:_update()
end


---Instantly update the grid content
---@return druid.grid self Current grid instance
function M:refresh()
	self:_update(true)

	return self
end


---Set grid pivot
---@param pivot constant The new pivot
---@return druid.grid self Current grid instance
function M:set_pivot(pivot)
	local prev_pivot = helper.get_pivot_offset(gui.get_pivot(self.parent))
	self.pivot = helper.get_pivot_offset(pivot)

	local width = gui.get(self.parent, "size.x")
	local height = gui.get(self.parent, "size.y")

	local position = gui.get_position(self.parent)
	position.x = position.x + width * (self.pivot.x - prev_pivot.x)
	position.y = position.y + height * (self.pivot.y - prev_pivot.y)
	gui.set_position(self.parent, position)

	gui.set_pivot(self.parent, pivot)

	self.anchor = vmath.vector3(0.5 + self.pivot.x, 0.5 - self.pivot.y, 0)
	self._grid_horizonal_offset = self.node_size.x * (self.in_row - 1) * self.anchor.x
	self._zero_offset = vmath.vector3(
		self.node_size.x * self.node_pivot.x - self.node_size.x * self.pivot.x - self._grid_horizonal_offset,
		self.node_size.y * self.node_pivot.y - self.node_size.y * self.pivot.y,
		0
	)

	self:_update(true)

	return self
end


---Add new item to the grid
---@param item node GUI node
---@param index number|nil The item position. By default add as last item
---@param shift_policy number|nil How shift nodes, if required. Default: const.SHIFT.RIGHT
---@param is_instant boolean|nil If true, update node positions instantly
---@return druid.grid self Current grid instance
function M:add(item, index, shift_policy, is_instant)
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

	return self
end


---Set new items to the grid. All previous items will be removed
---@param nodes node[] The new grid nodes
---@param is_instant boolean|nil If true, update node positions instantly
---@return druid.grid self Current grid instance
function M:set_items(nodes, is_instant)
	self.nodes = nodes
	for index = 1, #nodes do
		local item = nodes[index]
		gui.set_parent(item, self.parent)
	end

	self:_update(is_instant)

	self.on_change_items:trigger(self:get_context())

	return self
end


---Remove the item from the grid. Note that gui node will be not deleted
---@param index number The grid node index to remove
---@param shift_policy number|nil How shift nodes, if required. Default: const.SHIFT.RIGHT
---@param is_instant boolean|nil If true, update node positions instantly
---@return node node The deleted gui node from grid
function M:remove(index, shift_policy, is_instant)
	assert(self.nodes[index], "No grid item at given index " .. index)

	local remove_node = self.nodes[index]
	helper.remove_with_shift(self.nodes, index, shift_policy)

	self:_update(is_instant)

	self.on_remove_item:trigger(self:get_context(), index)
	self.on_change_items:trigger(self:get_context(), index)

	return remove_node
end


---Return grid content size
---@return vector3 size The grid content size
function M:get_size()
	return vmath.vector3(
		self.border.z - self.border.x,
		self.border.y - self.border.w,
		0)
end


---Return grid content size for given count of nodes
---@param count number The count of nodes
---@return vector3 size The grid content size
function M:get_size_for(count)
	if not count or count == 0 then
		return vmath.vector3(0)
	end

	local border = vmath.vector4(math.huge, -math.huge, -math.huge, math.huge)

	local size = self.node_size
	local pivot = self.node_pivot
	self:_extend_border(border, self:get_pos(1), size, pivot)
	self:_extend_border(border, self:get_pos(count), size, pivot)
	if count >= self.in_row then
		self:_extend_border(border, self:get_pos(self.in_row), size, pivot)
	end

	return vmath.vector3(
		border.z - border.x,
		border.y - border.w,
		0)
end


---Return grid content borders
---@return vector4 borders The grid content borders
function M:get_borders()
	return self.border
end


---Return array of all node positions
---@return vector3[] positions All grid node positions
function M:get_all_pos()
	local result = {}
	for i, node in pairs(self.nodes) do
		table.insert(result, gui.get_position(node))
	end

	return result
end


---Change set position function for grid nodes. It will call on
-- update poses on grid elements. Default: gui.set_position
---@param callback function Function on node set position
---@return druid.grid self Current grid instance
function M:set_position_function(callback)
	self._set_position_function = callback or gui.set_position

	return self
end


---Clear grid nodes array. GUI nodes will be not deleted!
-- If you want to delete GUI nodes, use static_grid.nodes array before grid:clear
---@return druid.grid self Current grid instance
function M:clear()
	self.border.x = 0
	self.border.y = 0
	self.border.w = 0
	self.border.z = 0

	self.nodes = {}
	self:_update()

	self.on_clear:trigger(self:get_context())
	self.on_change_items:trigger(self:get_context())

	return self
end


---Return StaticGrid offset, where StaticGrid content starts.
---@return vector3 offset The StaticGrid offset
function M:get_offset()
	local borders = self:get_borders()
	local size = self:get_size()

	local offset = vmath.vector3(
		(borders.z + borders.x)/2 + size.x * self.pivot.x,
		(borders.y + borders.w)/2 + size.y * self.pivot.y,
		0)

	return offset
end


---Set new in_row elements for grid
---@param in_row number The new in_row value
---@return druid.grid self Current grid instance
function M:set_in_row(in_row)
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


---Set new node size for grid
---@param width number|nil The new node width
---@param height number|nil The new node height
---@return druid.grid self Current grid instance
function M:set_item_size(width, height)
	if width then
		self.node_size.x = width
	end
	if height then
		self.node_size.y = height
	end
	self._grid_horizonal_offset = self.node_size.x * (self.in_row - 1) * self.anchor.x
	self._zero_offset = vmath.vector3(
		self.node_size.x * self.node_pivot.x - self.node_size.x * self.pivot.x - self._grid_horizonal_offset,
		self.node_size.y * self.node_pivot.y - self.node_size.y * self.pivot.y,
		0)

	self:_update()
	self.on_change_items:trigger(self:get_context())

	return self
end


---Sort grid nodes by custom comparator function
---@param comparator function The comparator function. (a, b) -> boolean
---@return druid.grid self Current grid instance
function M:sort_nodes(comparator)
	table.sort(self.nodes, comparator)
	self:_update(true)

	return self
end


---Update grid inner state
---@param is_instant boolean|nil If true, node position update instantly, otherwise with set_position_function callback
---@private
function M:_update(is_instant)
	self:_update_indexes()
	self:_update_borders()
	self:_update_pos(is_instant)
end


---Update first and last indexes of grid nodes
---@private
function M:_update_indexes()
	self.first_index = nil
	self.last_index = nil
	for index in pairs(self.nodes) do
		self.first_index = self.first_index or index
		self.last_index = self.last_index or index

		self.first_index = math.min(self.first_index, index)
		self.last_index = math.max(self.last_index, index)
	end
end


---Update grid content borders, recalculate min and max values
---@private
function M:_update_borders()
	if not self.first_index then
		self.border = vmath.vector4(0)
		return
	end

	self.border = vmath.vector4(math.huge, -math.huge, -math.huge, math.huge)

	local size = self.node_size
	local pivot = self.node_pivot
	for index, node in pairs(self.nodes) do
		self:_extend_border(self.border, self:get_pos(index), size, pivot)
	end
end


---Update grid nodes position
---@param is_instant boolean|nil If true, node position update instantly, otherwise with set_position_function callback
---@private
function M:_update_pos(is_instant)
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


---Return elements offset for correct posing nodes. Correct posing at
---parent pivot node (0:0) with adjusting of node sizes and anchoring
---@return vector3 The offset vector
---@private
function M:_get_zero_offset()
	if not self.style.IS_DYNAMIC_NODE_POSES then
		return vmath.vector3(0)
	end

	-- zero offset: center pos - border size * anchor
	return vmath.vector3(
		-((self.border.x + self.border.z)/2 + (self.border.z - self.border.x) * self.pivot.x),
		-((self.border.y + self.border.w)/2 + (self.border.y - self.border.w) * self.pivot.y),
		0
	)
end


---Return offset x for last row in grid. Used to align this row accorting to grid's anchor
---@return number The offset x value
---@private
function M:_get_zero_offset_x(row_index)
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


---@param border vector4 Will be updated with new border values
---@param pos vector3
---@param size vector3
---@param pivot vector3
function M:_extend_border(border, pos, size, pivot)
	local left = pos.x - size.x/2 - (size.x * pivot.x)
	local right = pos.x + size.x/2 - (size.x * pivot.x)
	local top = pos.y + size.y/2 - (size.y * pivot.y)
	local bottom = pos.y - size.y/2 - (size.y * pivot.y)

	border.x = math.min(border.x, left)
	border.y = math.max(border.y, top)
	border.z = math.max(border.z, right)
	border.w = math.min(border.w, bottom)
end


return M
