-- Copyright (c) 2021 Maxim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Component to handle placing components by row and columns.
-- Grid can anchor your elements, get content size and other
-- @module StaticGrid
-- @within BaseComponent
-- @alias druid.static_grid

--- On item add callback(self, node, index)
-- @tfield druid_event on_add_item

--- On item remove callback(self, index)
-- @tfield druid_event on_remove_item

--- On item add or remove callback(self, index)
-- @tfield druid_event on_change_items

--- On grid clear callback(self)
-- @tfield druid_event on_clear

--- On update item positions callback(self)
-- @tfield druid_event on_update_positions

--- Parent gui node
-- @tfield node parent

--- List of all grid nodes
-- @tfield node[] nodes

--- The first index of node in grid
-- @tfield number first_index

--- The last index of node in grid
-- @tfield number last_index

--- Item anchor
-- @tfield vector3 anchor

--- Item size
-- @tfield vector3 node_size

--- The size of item content
-- @tfield vector4 border

---

local const = require("druid.const")
local Event = require("druid.event")
local helper = require("druid.helper")
local component = require("druid.component")

local StaticGrid = component.create("static_grid", { component.ON_LAYOUT_CHANGE })


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
-- @tfield[opt=false] bool IS_DYNAMIC_NODE_POSES If true, always center grid content as grid pivot sets
function StaticGrid.on_style_change(self, style)
	self.style = {}
	self.style.IS_DYNAMIC_NODE_POSES = style.IS_DYNAMIC_NODE_POSES or false
end


--- Component init function
-- @tparam StaticGrid self
-- @tparam node parent The gui node parent, where items will be placed
-- @tparam node element Element prefab. Need to get it size
-- @tparam[opt=1] number in_row How many nodes in row can be placed
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
-- @tparam StaticGrid self
-- @tparam number index The grid element index
-- @treturn vector3 Node position
function StaticGrid.get_pos(self, index)
	local row = math.ceil(index / self.in_row) - 1
	local col = (index - row * self.in_row) - 1

	_temp_pos.x = col * self.node_size.x + self._zero_offset.x
	_temp_pos.y = -row * self.node_size.y + self._zero_offset.y
	_temp_pos.z = 0

	return _temp_pos
end


--- Return index for grid pos
-- @tparam StaticGrid self
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
-- @tparam StaticGrid self
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
-- @tparam StaticGrid self
-- @tparam vector3 anchor Anchor
function StaticGrid.set_anchor(self, anchor)
	self.anchor = anchor
	self:_update()
end


--- Add new item to the grid
-- @tparam StaticGrid self
--	@tparam node item Gui node
-- @tparam[opt] number index The item position. By default add as last item
-- @tparam[opt=SHIFT.RIGHT] number shift_policy How shift nodes, if required. See const.SHIFT
-- @tparam[opt=false] boolean is_instance If true, update node positions instantly
function StaticGrid.add(self, item, index, shift_policy, is_instant)
	shift_policy = shift_policy or const.SHIFT.RIGHT
	index = index or ((self.last_index or 0) + 1)

	if self.nodes[index] then
		if shift_policy == const.SHIFT.RIGHT then
			for i = self.last_index, index, -1 do
				self.nodes[i + 1] = self.nodes[i]
			end
		end
		if shift_policy == const.SHIFT.LEFT then
			for i = self.first_index, index do
				self.nodes[i - 1] = self.nodes[i]
			end
		end
	end

	self.nodes[index] = item
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
-- @tparam StaticGrid self
-- @tparam number index The grid node index to remove
-- @tparam[opt=SHIFT.RIGHT] number shift_policy How shift nodes, if required. See const.SHIFT
-- @tparam[opt=false] boolean is_instance If true, update node positions instantly
-- @treturn Node The deleted gui node from grid
function StaticGrid.remove(self, index, shift_policy, is_instant)
	shift_policy = shift_policy or const.SHIFT.RIGHT
	assert(self.nodes[index], "No grid item at given index " .. index)

	local remove_node = self.nodes[index]
	self.nodes[index] = nil

	if shift_policy == const.SHIFT.RIGHT then
		for i = index, self.last_index do
			self.nodes[i] = self.nodes[i + 1]
		end
	end
	if shift_policy == const.SHIFT.LEFT then
		for i = index, self.first_index, -1 do
			self.nodes[i] = self.nodes[i - 1]
		end
	end

	self:_update(is_instant)

	self.on_remove_item:trigger(self:get_context(), index)
	self.on_change_items:trigger(self:get_context(), index)

	return remove_node
end


--- Return grid content size
-- @tparam StaticGrid self
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
-- @tparam StaticGrid self
-- @treturn vector3 The grid content borders
function StaticGrid.get_borders(self)
	return self.border
end


--- Return array of all node positions
-- @tparam StaticGrid self
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
-- @tparam StaticGrid self
-- @tparam function callback Function on node set position
-- @treturn druid.static_grid Current grid instance
function StaticGrid.set_position_function(self, callback)
	self._set_position_function = callback or gui.set_position

	return self
end


--- Clear grid nodes array. GUI nodes will be not deleted!
-- If you want to delete GUI nodes, use static_grid.nodes array before grid:clear
-- @tparam StaticGrid self
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
-- @tparam StaticGrid self The StaticGrid instance
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


--- Update grid inner state
-- @tparam StaticGrid self
-- @tparam bool is_instant If true, node position update instantly, otherwise with set_position_function callback
-- @local
function StaticGrid._update(self, is_instant)
	self:_update_indexes()
	self:_update_borders()
	self:_update_pos(is_instant)
end


--- Update first and last indexes of grid nodes
-- @tparam StaticGrid self
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
-- @tparam StaticGrid self
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
-- @tparam StaticGrid self
-- @tparam bool is_instant If true, node position update instantly, otherwise with set_position_function callback
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
-- @function static_grid:_get_zero_offset
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


return StaticGrid
