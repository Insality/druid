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

local Event = require("druid.event")
local helper = require("druid.helper")
local component = require("druid.component")

local M = component.create("grid")


--- Component init function
-- @function grid:init
-- @tparam node parent The gui node parent, where items will be placed
-- @tparam node element Element prefab. Need to get it size
-- @tparam[opt=1] number in_row How many nodes in row can be placed
function M.init(self, parent, element, in_row)
	self.parent = self:get_node(parent)
	self.nodes = {}

	self.offset = vmath.vector3(0)

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
end


local function check_border(self, pos)
	local border = self.border
	local size = self.node_size

	local W = pos.x - size.x/2 + self.border_offset.x
	local E = pos.x + size.x/2 + self.border_offset.x
	local N = pos.y + size.y/2 + self.border_offset.y
	local S = pos.y - size.y/2 + self.border_offset.y

	border.x = math.min(border.x, W)
	border.y = math.max(border.y, N)
	border.z = math.max(border.z, E)
	border.w = math.min(border.w, S)

	self.border_offset = vmath.vector3(
		(border.x + (border.z - border.x) * self.anchor.x),
		(border.y + (border.w - border.y) * self.anchor.y),
		0
	)
end


local temp_pos = vmath.vector3(0)
local function get_pos(self, index)
	local row = math.ceil(index / self.in_row) - 1
	local col = (index - row * self.in_row) - 1

	temp_pos.x = col * (self.node_size.x + self.offset.x) - self.border_offset.x
	temp_pos.y = -row * (self.node_size.y + self.offset.y) - self.border_offset.y
	temp_pos.z = 0

	return temp_pos
end


local function update_pos(self)
	for i = 1, #self.nodes do
		local node = self.nodes[i]
		gui.set_position(node, get_pos(self, i))
	end

	self.on_update_positions:trigger(self:get_context())
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
	table.insert(self.nodes, index, item)
	gui.set_parent(item, self.parent)

	local pos = get_pos(self, index)
	check_border(self, pos)
	update_pos(self)

	self.on_add_item:trigger(self:get_context(), item, index)
end


--- Return grid content size
-- @function grid:get_size
-- @treturn vector3 The grid content size
function M.get_size(self)
	return vmath.vector3(
		self.border.z - self.border.x,
		self.border.y - self.border.w,
		0)
end


--- Return array of all node positions
-- @function grid:get_all_pos
-- @treturn vector3[] All grid node positions
function M.get_all_pos(self)
	local result = {}
	for i = 1, #self.nodes do
		table.insert(result,	gui.get_position(self.nodes[i]))
	end

	return result
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


return M
