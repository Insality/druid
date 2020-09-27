--- Component to handle placing components in row
-- @module druid.dynamic_grid

--- Component events
-- @table Events
-- @tfield druid_event on_add_item On item add callback
-- @tfield druid_event on_remove_item On item remove callback
-- @tfield druid_event on_change_items On item add or remove callback
-- @tfield druid_event on_clear On grid clear callback
-- @tfield druid_event on_update_positions On update item positions callback

--- Component fields
-- @table Fields
-- @tfield node parent Parent gui node
-- @tfield node[] nodes List of all grid nodes
-- @tfield number first_index The first index of node in grid
-- @tfield number last_index The last index of node in grid
-- @tfield vector3 node_size Item size
-- @tfield vector4 border The size of item content

local const = require("druid.const")
local Event = require("druid.event")
local helper = require("druid.helper")
local component = require("druid.component")

local DynamicGrid = component.create("dynamic_grid", { const.ON_LAYOUT_CHANGE })

local SIDE_VECTORS = {
	LEFT = vmath.vector3(-1, 0, 0),
	RIGHT = vmath.vector3(1, 0, 0),
	TOP = vmath.vector3(0, -1, 0),
	BOT = vmath.vector3(0, 1, 0),
}


--- Component init function
-- @function dynamic_grid:init
-- @tparam node parent The gui node parent, where items will be placed
function DynamicGrid:init(parent, side)
	self.parent = self:get_node(parent)

	local parent_pivot = gui.get_pivot(self.parent)
	self.pivot = helper.get_pivot_offset(parent_pivot)

	assert(parent_pivot == gui.PIVOT_W or parent_pivot == gui.PIVOT_N, const.ERRORS.GRID_DYNAMIC_ANCHOR)
	self.side = (parent_pivot == gui.PIVOT_W and const.SIDE.X or const.SIDE.Y)

	self.nodes = {}
	self.border = vmath.vector4(0) -- Current grid content size

	self.on_add_item = Event()
	self.on_remove_item = Event()
	self.on_change_items = Event()
	self.on_clear = Event()
	self.on_update_positions = Event()

	self._set_position_function = gui.set_position
end


function DynamicGrid:on_layout_change()
	self:_update(true)
end


--- Return pos for grid node index
-- @function dynamic_grid:get_pos
-- @tparam number index The grid element index
-- @tparam node node The node to be placed
-- @treturn vector3 Node position
function DynamicGrid:get_pos(index, node, origin_index)
	local origin_node = self.nodes[origin_index]

	-- If anchor node is not exist, check around nodes
	if not origin_node then
		if self.nodes[index + 1] then
			origin_index = index + 1
		end
		if self.nodes[index - 1] then
			origin_index = index - 1
		end
		origin_node = self.nodes[origin_index]
	end

	if not origin_node then
		assert(not self.first_index, "Dynamic Grid can't have gaps between nodes. Error on grid:add")

		-- If not origin node, so it should be first element in the grid
		local size = self:_get_node_size(node)
		local pivot = const.PIVOTS[gui.get_pivot(node)]
		return vmath.vector3(
			size.x * pivot.x - size.x * self.pivot.x,
			size.y * pivot.y - size.y * self.pivot.y,
			0)
	end

	if origin_node then
		-- Other nodes spawn from other side of the origin node
		local is_forward = origin_index < index
		local delta = is_forward and 1 or -1
		return self:_get_next_node_pos(index - delta, node, self:_get_side_vector(self.side, is_forward))
	end
end


--- Add new node to the grid
-- @function dynamic_grid:add
--	@tparam node node Gui node
-- @tparam[opt] number index The node position. By default add as last node
-- @tparam[opt=false] bool is_shift_left If true, shift all nodes to the left, otherwise shift nodes to the right
function DynamicGrid:add(node, index, is_shift_left)
	local delta = is_shift_left and -1 or 1

	-- By default add node at end
	index = index or ((self.last_index or 0) + 1)

	-- If node exist at index place, shifting them
	local is_shift = self.nodes[index]
	if is_shift then
		-- We need to iterate from index to start or end grid, depends of shift side
		local start_index = is_shift_left and self.first_index or self.last_index
		for i = start_index, index, -delta do
			self.nodes[i + delta] = self.nodes[i]
		end
	end

	self:_add_node(node, index, index - delta)

	-- After shifting we should recalc node poses
	if is_shift then
		-- We need to iterate from placed node to start or end grid, depends of shift side
		local target_index = is_shift_left and self.first_index or self.last_index
		for i = index + delta, target_index + delta, delta do
			local move_node = self.nodes[i]
			move_node.pos = self:get_pos(i, move_node.node, i - delta)
		end
	end


	-- Sync grid data
	self:_update()

	self.on_add_item:trigger(self:get_context(), node, index)
	self.on_change_items:trigger(self:get_context(), index)
end


--- Remove the item from the grid. Note that gui node will be not deleted
-- @function dynamic_grid:remove
-- @tparam number index The grid node index to remove
-- @tparam[opt=false] bool is_shift_left If true, shift all nodes to the left, otherwise shift nodes to the right
function DynamicGrid:remove(index, is_shift_left)
	local delta = is_shift_left and -1 or 1

	assert(self.nodes[index], "No grid item at given index " .. index)

	-- Just set nil for delete node data
	self.nodes[index] = nil

	-- After delete node, we should shift nodes and recalc their poses, depends from is_shift_left
	local target_index = is_shift_left and self.first_index or self.last_index
	for i = index, target_index, delta do
		self.nodes[i] = self.nodes[i + delta]
		if self.nodes[i] then
			self.nodes[i].pos = self:get_pos(i, self.nodes[i].node, i - delta)
		end
	end

	-- Sync grid data
	self:_update()

	self.on_add_item:trigger(self:get_context(), index)
	self.on_change_items:trigger(self:get_context(), index)
end


--- Return grid content size
-- @function dynamic_grid:get_size
-- @treturn vector3 The grid content size
function DynamicGrid:get_size(border)
	border = border or self.border
	return vmath.vector3(
		border.z - border.x,
		border.y - border.w,
		0)
end


--- Return grid index by node
-- @function dynamic_grid:get_index_by_node
-- @tparam node node The gui node in the grid
-- @treturn number The node index
function DynamicGrid:get_index_by_node(node)
	for index, node_info in pairs(self.nodes) do
		if node == node_info.node then
			return index
		end
	end

	return nil
end


--- Return array of all node positions
-- @function dynamic_grid:get_all_pos
-- @treturn vector3[] All grid node positions
function DynamicGrid:get_all_pos()
	local result = {}
	for i, node in pairs(self.nodes) do
		table.insert(result, gui.get_position(node))
	end

	return result
end


--- Change set position function for grid nodes. It will call on
-- update poses on grid elements. Default: gui.set_position
-- @function dynamic_grid:set_position_function
-- @tparam function callback Function on node set position
-- @treturn druid.dynamic_grid Current grid instance
function DynamicGrid:set_position_function(callback)
	self._set_position_function = callback or gui.set_position
	return self
end


--- Clear grid nodes array. GUI nodes will be not deleted!
-- If you want to delete GUI nodes, use dynamic_grid.nodes array before grid:clear
-- @function dynamic_grid:clear
-- @treturn druid.dynamic_grid Current grid instance
function DynamicGrid:clear()
	self.nodes = {}
	self:_update()
	return self
end


function DynamicGrid:_add_node(node, index, origin_index)
	self.nodes[index] = {
		node = node,
		pos = self:get_pos(index, node, origin_index),
		size = self:_get_node_size(node),
		pivot = const.PIVOTS[gui.get_pivot(node)]
	}

	-- Add new item instantly in new pos
	gui.set_parent(node, self.parent)
	gui.set_position(node, self.nodes[index].pos + self:_get_zero_offset())
end


--- Update grid inner state
-- @function dynamic_grid:_update
-- @tparam bool is_instant If true, node position update instantly, otherwise with set_position_function callback
-- @local
function DynamicGrid:_update(is_instant)
	self:_update_indexes()
	self:_update_borders()
	self:_update_pos(is_instant)
end


--- Update first and last indexes of grid nodes
-- @function dynamic_grid:_update_indexes
-- @local
function DynamicGrid:_update_indexes()
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
-- @function dynamic_grid:_update_borders
-- @local
function DynamicGrid:_update_borders()
	if not self.first_index then
		self.border = vmath.vector4(0)
		return
	end

	self.border = vmath.vector4(math.huge, -math.huge, -math.huge, math.huge)

	for index, node in pairs(self.nodes) do
		local pos = node.pos
		local size = node.size
		local pivot = node.pivot

		local left = pos.x - size.x/2 - (size.x * pivot.x)
		local right = pos.x + size.x/2 - (size.x * pivot.x)
		local top = pos.y + size.y/2 - (size.y * pivot.y)
		local bottom = pos.y - size.y/2 - (size.y * pivot.y)

		self.border.x = math.min(self.border.x, left)
		self.border.y = math.max(self.border.y, top)
		self.border.z = math.max(self.border.z, right)
		self.border.w = math.min(self.border.w, bottom)
	end
end


--- Update grid nodes position
-- @function dynamic_grid:_update_indexes
-- @tparam bool is_instant If true, node position update instantly, otherwise with set_position_function callback
-- @local
function DynamicGrid:_update_pos(is_instant)
	local offset = self:_get_zero_offset()

	for index, node in pairs(self.nodes) do
		if is_instant then
			gui.set_position(node.node, node.pos + offset)
		else
			self._set_position_function(node.node, node.pos + offset)
		end
	end

	self.on_update_positions:trigger(self:get_context())
end


function DynamicGrid:_get_next_node_pos(origin_node_index, new_node, place_side)
	local node = self.nodes[origin_node_index]

	local new_node_size = self:_get_node_size(new_node)
	local new_pivot = const.PIVOTS[gui.get_pivot(new_node)]

	local dist_x = (node.size.x/2 + new_node_size.x/2) * place_side.x
	local dist_y = (node.size.y/2 + new_node_size.y/2) * place_side.y
	local node_center_x = node.pos.x - node.size.x * node.pivot.x
	local node_center_y = node.pos.y - node.size.y * node.pivot.y

	return vmath.vector3(
		node_center_x + dist_x + new_node_size.x * new_pivot.x,
		node_center_y - dist_y + new_node_size.y * new_pivot.y,
		0
	)
end


function DynamicGrid:_get_node_size(node)
	return vmath.mul_per_elem(gui.get_size(node), gui.get_scale(node))
end


function DynamicGrid:_get_zero_offset()
	-- zero offset: center pos - border size * anchor
	return vmath.vector3(
		-((self.border.x + self.border.z)/2 + (self.border.z - self.border.x) * self.pivot.x),
		-((self.border.y + self.border.w)/2 + (self.border.y - self.border.w) * self.pivot.y),
		0)
end


function DynamicGrid:_get_side_vector(side, is_forward)
	if side == const.SIDE.X then
		return is_forward and SIDE_VECTORS.RIGHT or SIDE_VECTORS.LEFT
	end

	if side == const.SIDE.Y then
		return is_forward and SIDE_VECTORS.BOT or SIDE_VECTORS.TOP
	end
end


return DynamicGrid
