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
-- @tfield vector3 border_offer The border offset for correct anchor calculations

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

	local pivot = helper.get_pivot_offset(gui.get_pivot(self.parent))
	self.anchor = vmath.vector3(0.5 + pivot.x, 0.5 - pivot.y, 0)

	self.border = vmath.vector4(0) -- Current grid content size
	self.border_offset = vmath.vector3(0) -- Content offset for match the grid anchoring

	self.on_add_item = Event()
	self.on_remove_item = Event()
	self.on_change_items = Event()
	self.on_clear = Event()
	self.on_update_positions = Event()

	self._set_position_function = gui.set_position
end


local _temp_pos = vmath.vector3(0)
--- Return pos for grid node index
-- @function dynamic_grid:get_pos
-- @tparam number index The grid element index
-- @treturn vector3 Node position
function DynamicGrid:get_pos(index)
	local row = math.ceil(index) - 1
	local col = (index - row) - 1

	_temp_pos.x = col * (self.node_size.x + self.offset.x) - self.border_offset.x
	_temp_pos.y = -row * (self.node_size.y + self.offset.y) - self.border_offset.y
	_temp_pos.z = 0

	return _temp_pos
end


--- Return index for grid pos
-- @function dynamic_grid:get_index
-- @tparam vector3 pos The node position in the grid
-- @treturn number The node index
function DynamicGrid:get_index(pos)
	local col = (pos.x + self.border_offset.x) / (self.node_size.x + self.offset.x) + 1
	local row = -(pos.y + self.border_offset.y) / (self.node_size.y + self.offset.y)

	col = helper.round(col)
	row = helper.round(row)

	local index = col + row
	return math.ceil(index)
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

	self.nodes[index] = item

	gui.set_parent(item, self.parent)

	local pos = self:get_pos(index)
	-- Add new item instantly in new pos
	gui.set_position(item, pos)

	for i, _ in pairs(self.nodes) do
		self:_update_border_offset(self:get_pos(i))
	end

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

	-- Recalculate borders
	self.border = vmath.vector4(0)
	self:_update_border_offset(self:get_pos(1))
	for i, _ in pairs(self.nodes) do
		self:_update_border_offset(self:get_pos(i))
	end

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


--- Return grid size for amount of nodes in this grid
-- @function dynamic_grid:get_size_for_elements_count
-- @tparam number count The grid content node amount
-- @treturn vector3 The grid content size
function DynamicGrid:get_size_for_elements_count(count)
	local border = vmath.vector4(0)
	for i = 1, count do
		local pos = self:get_pos(i)
		self:_update_border(pos, border)
	end

	return self:get_size(border)
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
	self.border.x = 0
	self.border.y = 0
	self.border.w = 0
	self.border.z = 0

	self:_update_border_offset(self:get_pos(1))

	self.nodes = {}
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


function DynamicGrid:_update_border(pos, border)
	local size = self.node_size
	local pivot = self.node_pivot

	local left = pos.x - size.x/2 - (size.x * pivot.x) + self.border_offset.x
	local right = pos.x + size.x/2 - (size.x * pivot.x) + self.border_offset.x
	local top = pos.y + size.y/2 - (size.y * pivot.y) + self.border_offset.y
	local bottom = pos.y - size.y/2 - (size.y * pivot.y) + self.border_offset.y

	border.x = math.min(border.x, left)
	border.y = math.max(border.y, top)
	border.z = math.max(border.z, right)
	border.w = math.min(border.w, bottom)
end


function DynamicGrid:_update_border_offset(pos)
	local border = self.border
	self:_update_border(pos, border)

	self.border_offset = vmath.vector3(
		(border.x + (border.z - border.x) * self.anchor.x),
		(border.y + (border.w - border.y) * self.anchor.y),
		0
	)
end


function DynamicGrid:_update_pos(is_instant)
	for i, node in pairs(self.nodes) do
		if is_instant then
			gui.set_position(node, self:get_pos(i))
		else
			self._set_position_function(node, self:get_pos(i))
		end
	end

	self.on_update_positions:trigger(self:get_context())
end


return DynamicGrid
