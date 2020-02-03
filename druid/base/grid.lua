--- Component to handle placing components by row and columns.
-- Grid can anchor your elements, get content size and other
-- @module base.grid

local helper = require("druid.helper")
local component = require("druid.system.component")

local M = component.create("grid")


function M.init(self, parent, element, in_row)
	self.parent = helper.get_node(parent)
	self.nodes = {}

	self.offset = vmath.vector3(0)
	self.anchor = vmath.vector3(0.5, 0, 0)
	self.in_row = in_row or 1
	self.node_size = gui.get_size(helper.get_node(element))
	self.border = vmath.vector4(0)
	self.border_offset = vmath.vector3(0)
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

	return temp_pos
end


local function update_pos(self)
	for i = 1, #self.nodes do
		local node = self.nodes[i]
		gui.set_position(node, get_pos(self, i))
	end
end


function M.set_offset(self, offset)
	self.offset = offset
	update_pos(self)
end


function M.set_anchor(self, anchor)
	self.anchor = anchor
	update_pos(self)
end


function M.add(self, item, index)
	index = index or (#self.nodes + 1)
	table.insert(self.nodes, index, item)
	gui.set_parent(item, self.parent)

	local pos = get_pos(self, index)
	check_border(self, pos)
	update_pos(self)
end


function M.get_size(self)
	return vmath.vector3(
		self.border.z - self.border.x,
		self.border.w - self.border.y,
		0)
end


function M.get_all_pos(self)
	local result = {}
	for i = 1, #self.nodes do
		table.insert(result,	gui.get_position(self.nodes[i]))
	end

	return result
end


function M.clear(self)
	for i = 1, #self.nodes do
		gui.delete_node(self.nodes[i])
	end
	self.nodes = {}
end


return M
