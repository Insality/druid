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
-- @tfield vector3 offset Item distance between each other items
-- @tfield vector3 anchor Item anchor
-- @tfield vector3 node_size Item size
-- @tfield vector4 border The size of item content

local const = require("druid.const")
local Event = require("druid.event")
local helper = require("druid.helper")
local component = require("druid.component")

local DynamicGrid = component.create("dynamic_grid", { const.ON_LAYOUT_CHANGE })


--- Component init function
-- @function dynamic_grid:init
-- @tparam node parent The gui node parent, where items will be placed
function DynamicGrid:init(parent, side)
	self.parent = self:get_node(parent)

	self.nodes = {}

	self.offset = vmath.vector3(0)

	self.pivot = helper.get_pivot_offset(gui.get_pivot(self.parent))
	self.anchor = vmath.vector3(0.5 + self.pivot.x, 0.5 - self.pivot.y, 0)

	self.border = vmath.vector4(0) -- Current grid content size

	self.on_add_item = Event()
	self.on_remove_item = Event()
	self.on_change_items = Event()
	self.on_clear = Event()
	self.on_update_positions = Event()

	self.center_pos = vmath.vector3(0)

	self._set_position_function = gui.set_position
end


--- Return pos for grid node index
-- @function dynamic_grid:get_pos
-- @tparam number index The grid element index
-- @tparam node node The node to be placed
-- @treturn vector3 Node position
function DynamicGrid:get_pos(index, node)
	local prev_node = self.nodes[index-1]
	local next_node = self.nodes[index+1]

	if not prev_node and not next_node then
		-- TODO: assert no elements in grid now
		local size = self:_get_node_size(node)
		local pivot = const.PIVOTS[gui.get_pivot(node)]
		return vmath.vector3(
			size.x * pivot.x + size.x * self.pivot.x,
			size.y * pivot.y - size.y * self.pivot.y,
			0)
	end

	-- For now it works only by vertical
	if prev_node then
		return self:_get_next_node_pos(index - 1, node, vmath.vector3(0, 1, 0))
	end

	if next_node then
		return self:_get_next_node_pos(index + 1, node, vmath.vector3(0, -1, 0))
	end
end


function DynamicGrid:on_layout_change()
	self:_update_pos(true)
end


--- Set grid items offset, the distance between items
-- @function dynamic_grid:set_offset
-- @tparam vector3 offset Offset
function DynamicGrid:set_offset(offset)
	self.offset = offset
	self:_update_pos()
end


--- Set grid anchor. Default anchor is equal to anchor of grid parent node
-- @function dynamic_grid:set_anchor
-- @tparam vector3 anchor Anchor
function DynamicGrid:set_anchor(anchor)
	self.anchor = anchor
	self:_update_pos()
end


--- Add new item to the grid
-- @function dynamic_grid:add
--	@tparam node item Gui node
-- @tparam[opt] number index The item position. By default add as last item
function DynamicGrid:add(item, index)
	index = index or ((self.last_index or 0) + 1)

	if self.nodes[index] then
		-- Move nodes to right
		for i = self.last_index, index, -1 do
			self.nodes[i + 1] = self.nodes[i]
		end
	end

	self:_add_node(item, index)

	self:_update_borders()
	self:_update_pos()
	self:_update_indexes()

	self.on_add_item:trigger(self:get_context(), item, index)
	self.on_change_items:trigger(self:get_context(), index)
end


--- Remove the item from the grid. Note that gui node will be not deleted
-- @function dynamic_grid:remove
-- @tparam number index The grid node index to remove
-- @tparam bool is_shift_nodes If true, will shift nodes left after index
function DynamicGrid:remove(index, is_shift_nodes)
	assert(self.nodes[index], "No grid item at given index " .. index)

	self.nodes[index] = nil

	if is_shift_nodes then
		for i = index, self.last_index do
			self.nodes[i] = self.nodes[i + 1]
		end
	end

	self:_update_borders()
	self:_update_pos()
	self:_update_indexes()

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


function DynamicGrid:get_center_position()
	return vmath.vector3(
		(self.border.x + self.border.z)/2,
		(self.border.y + self.border.w)/2,
		0)
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
function DynamicGrid:set_position_function(callback)
	self._set_position_function = callback or gui.set_position
end


--- Clear grid nodes array. GUI nodes will be not deleted!
-- If you want to delete GUI nodes, use dynamic_grid.nodes array before grid:clear
-- @function dynamic_grid:clear
function DynamicGrid:clear()
	self.nodes = {}
	self:_update_borders()
	self:_update_indexes()
end



--- Return the grid nodes table
-- @function dynamic_grid:get_nodes
-- @treturn table<index, node> The grid nodes
function DynamicGrid:get_nodes()
	return self.nodes
end


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


function DynamicGrid:_update_borders()
	local border = vmath.vector4(math.huge, -math.huge, -math.huge, math.huge)

	for index, node in pairs(self.nodes) do
		local pos = node.pos
		local size = node.size
		local pivot = node.pivot

		local left = pos.x - size.x/2 - (size.x * pivot.x)
		local right = pos.x + size.x/2 - (size.x * pivot.x)
		local top = pos.y + size.y/2 - (size.y * pivot.y)
		local bottom = pos.y - size.y/2 - (size.y * pivot.y)

		border.x = math.min(border.x, left)
		border.y = math.max(border.y, top)
		border.z = math.max(border.z, right)
		border.w = math.min(border.w, bottom)
	end

	self.border = border
end


function DynamicGrid:_update_pos(is_instant)
	for index, node in pairs(self.nodes) do
		if is_instant then
			gui.set_position(node.node, node.pos)
		else
			self._set_position_function(node.node, node.pos)
		end
	end

	self.on_update_positions:trigger(self:get_context())
end


function DynamicGrid:_get_next_node_pos(origin_node_index, new_node, place_side)
	local node = self.nodes[origin_node_index]
	local pos = node.pos
	local size = node.size
	local anchor = node.pivot

	local new_node_size = self:_get_node_size(new_node)
	local new_anchor = const.PIVOTS[gui.get_pivot(new_node)]

	local dist = vmath.vector3(
		(size.x/2 + new_node_size.x/2) * place_side.x,
		(size.y/2 + new_node_size.y/2) * place_side.y,
		0
	)

	local node_center = vmath.vector3(
		pos.x - size.x * anchor.x,
		pos.y - size.y * anchor.y,
		0
	)

	return vmath.vector3(
		node_center.x + dist.x + new_node_size.x * new_anchor.x,
		node_center.y - dist.y + new_node_size.y * new_anchor.y,
		0
	)
end


function DynamicGrid:_get_node_size(node)
	return vmath.mul_per_elem(gui.get_size(node), gui.get_scale(node))
end


function DynamicGrid:_add_node(node, index)
	self.nodes[index] = {
		node = node,
		pos = self:get_pos(index, node),
		size = self:_get_node_size(node),
		pivot = const.PIVOTS[gui.get_pivot(node)]
	}

	-- Add new item instantly in new pos
	gui.set_parent(node, self.parent)
	gui.set_position(node, self.nodes[index].pos)
end


return DynamicGrid
