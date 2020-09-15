--- Component to handle placing components by row and columns.
-- Grid can anchor your elements, get content size and other
-- @module druid.grid

--- Component events
-- @table Events
-- @tfield druid_event on_add_item On item add callback
-- @tfield druid_event on_remove_item On item remove callback
-- @tfield druid_event on_clear On grid clear callback
-- @tfield druid_event on_update_positions On update item positions callback

--- Component fields
-- @table Fields
-- @tfield node parent Parent gui node
-- @tfield node[] nodes List of all grid nodes
-- @tfield vector3 offset Item distance between each other items
-- @tfield vector3 anchor Item anchor
-- @tfield vector3 node_size Item size
-- @tfield vector4 border The size of item content
-- @tfield vector3 border_offer The border offset for correct anchor calculations

local const = require("druid.const")
local Event = require("druid.event")
local helper = require("druid.helper")
local component = require("druid.component")

local M = component.create("grid", { const.ON_LAYOUT_CHANGE })


--- Component init function
-- @function grid:init
-- @tparam node parent The gui node parent, where items will be placed
-- @tparam node element Element prefab. Need to get it size
-- @tparam[opt=1] number in_row How many nodes in row can be placed
function M.init(self, parent, element, in_row)
	self.parent = self:get_node(parent)
	self.nodes = {}

	self.offset = vmath.vector3(0)
	self.grid_mode = const.GRID_MODE.DYNAMIC

	local pivot = helper.get_pivot_offset(gui.get_pivot(self.parent))
	self.anchor = vmath.vector3(0.5 + pivot.x, 0.5 - pivot.y, 0)

	self.in_row = in_row or 1
	self.node_size = gui.get_size(self:get_node(element))
	self.border = vmath.vector4(0)
	self.border_offset = vmath.vector3(0)

	self.on_add_item = Event()
	self.on_remove_item = Event()
	self.on_clear = Event()
	self.on_update_positions = Event()

	self._set_position_function = gui.set_position
end


local function _update_border(self, pos, border)
	local size = self.node_size

	local left = pos.x - size.x/2 + self.border_offset.x
	local right = pos.x + size.x/2 + self.border_offset.x
	local top = pos.y + size.y/2 + self.border_offset.y
	local bottom = pos.y - size.y/2 + self.border_offset.y

	border.x = math.min(border.x, left)
	border.y = math.max(border.y, top)
	border.z = math.max(border.z, right)
	border.w = math.min(border.w, bottom)
end


local function update_border_offset(self, pos)
	local border = self.border
	_update_border(self, pos, border)

	self.border_offset = vmath.vector3(
		(border.x + (border.z - border.x) * self.anchor.x),
		(border.y + (border.w - border.y) * self.anchor.y),
		0
	)
end


local function update_pos(self, is_instant)
	for i, node in pairs(self.nodes) do
		if is_instant then
			gui.set_position(node, self:get_pos(i))
		else
			self._set_position_function(node, self:get_pos(i))
		end
	end

	self.on_update_positions:trigger(self:get_context())
end


local temp_pos = vmath.vector3(0)
--- Return pos for grid node index
-- @function grid:get_pos
-- @tparam number index The grid element index
-- @treturn vector3 Node position
function M.get_pos(self, index)
	local row = math.ceil(index / self.in_row) - 1
	local col = (index - row * self.in_row) - 1

	temp_pos.x = col * (self.node_size.x + self.offset.x) - self.border_offset.x
	temp_pos.y = -row * (self.node_size.y + self.offset.y) - self.border_offset.y
	temp_pos.z = 0

	return temp_pos
end


--- Return index for grid pos
-- @function grid:get_index
-- @tparam vector3 pos The node position in the grid
-- @treturn number The node index
function M.get_index(self, pos)
	local col = (pos.x + self.border_offset.x) / (self.node_size.x + self.offset.x)
	local row = -(pos.y + self.border_offset.y) / (self.node_size.y + self.offset.y)

	local index = col + (row * self.in_row) + 1
	return math.floor(index)
end


function M.on_layout_change(self)
	update_pos(self, true)
end


--- Set grid items offset, the distance between items
-- @function grid:set_offset
-- @tparam vector3 offset Offset
function M.set_offset(self, offset)
	self.offset = offset
	update_pos(self)
end


--- Set grid anchor
-- @function grid:set_anchor
-- @tparam vector3 acnhor Anchor
function M.set_anchor(self, anchor)
	self.anchor = anchor
	update_pos(self)
end


--- Add new item to the grid
-- @function grid:add
--	@tparam node item Gui node
-- @tparam[opt] number index The item position. By default add as last item
function M.add(self, item, index)
	index = index or (#self.nodes + 1)

	if self.grid_mode == const.GRID_MODE.DYNAMIC then
		table.insert(self.nodes, index, item)
	else
		self.nodes[index] = item
	end

	gui.set_parent(item, self.parent)

	local pos = self:get_pos(index)
	for i, _ in pairs(self.nodes) do
		update_border_offset(self, self:get_pos(i))
	end

	-- Add new item instantly in new pos
	gui.set_position(item, pos)
	update_pos(self)

	self.on_add_item:trigger(self:get_context(), item, index)
end


function M:remove(index, delete_node)
	assert(self.nodes[index], "No grid item at given index " .. index)

	local parent_node = self.nodes[index]
	if delete_node then
		gui.delete_node(parent_node)
	end

	if self.grid_mode == const.GRID_MODE.DYNAMIC then
		table.remove(self.nodes, index)
	else
		self.nodes[index] = nil
	end

	-- Recalculate borders
	self.border = vmath.vector4(0)
	update_border_offset(self, self:get_pos(1))
	for i, _ in pairs(self.nodes) do
		local pos = self:get_pos(i)
		update_border_offset(self, pos)
	end

	update_pos(self)
end


--- Return grid content size
-- @function grid:get_size
-- @treturn vector3 The grid content size
function M.get_size(self, border)
	border = border or self.border
	return vmath.vector3(
		border.z - border.x,
		border.y - border.w,
		0)
end


function M:get_size_for_elements_count(count)
	local border = vmath.vector4(0)
	for i = 1, count do
		local pos = self:get_pos(i)
		_update_border(self, pos, border)
	end

	return M.get_size(self, border)
end


--- Return array of all node positions
-- @function grid:get_all_pos
-- @treturn vector3[] All grid node positions
function M.get_all_pos(self)
	local result = {}
	for i, node in pairs(self.nodes) do
		table.insert(result, gui.get_position(node))
	end

	return result
end


--- Change set position function for grid nodes. It will call on
-- update poses on grid elements. Default: gui.set_position
-- @function grid:set_position_function
-- @tparam function callback Function on node set position
function M.set_position_function(self, callback)
	self._set_position_function = callback or gui.set_position
end


--- Clear grid nodes array. GUI nodes will be not deleted!
-- If you want to delete GUI nodes, use grid.nodes array before grid:clear
-- @function grid:clear
function M.clear(self)
	self.border.x = 0
	self.border.y = 0
	self.border.w = 0
	self.border.z = 0

	self.nodes = {}
end


function M:set_grid_mode(grid_mode)
	assert(grid_mode == const.GRID_MODE.STATIC or grid_mode == const.GRID_MODE.DYNAMIC)

	self.grid_mode = grid_mode
end


return M
