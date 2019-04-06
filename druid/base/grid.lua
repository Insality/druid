local helper = require("druid.helper")

local M = {}

--- Sort and placing nodes
-- Plans: placing by max width, placing with max in_row
-- Allow different node sizes, allow animation with node insert


function M.init(instance, parent, element, in_row)
	instance.parent = helper.get_node(parent)
	instance.nodes = {}

	instance.offset = vmath.vector3(0)
	instance.anchor = vmath.vector3(0)
	instance.in_row = in_row or 1
	instance.node_size = gui.get_size(helper.get_node(element))
	instance.border = vmath.vector4(0)
end


local function check_border(instance, pos)
	local size = instance.node_size
	local W = pos.x - size.x/2
	local E = pos.x + size.x/2
	local N = pos.y + size.y/2
	local S = pos.y - size.y/2

	instance.border.x = math.min(instance.border.x, W)
	instance.border.y = math.max(instance.border.y, N)
	instance.border.z = math.max(instance.border.z, E)
	instance.border.w = math.min(instance.border.w, S)
end


local temp_pos = vmath.vector3(0)
local function get_pos(instance, index)
	local row = math.ceil(index / instance.in_row) - 1
	local col = (index - row * instance.in_row) - 1

	temp_pos.x = col * (instance.node_size.x + instance.offset.x)
	temp_pos.x = temp_pos.x + (0.5 - instance.anchor.x) * instance.node_size.x
	temp_pos.y = -row * (instance.node_size.y + instance.offset.y)
	temp_pos.y = temp_pos.y - (0.5 - instance.anchor.y) * instance.node_size.y

	return temp_pos
end


local function update_pos(instance)
	for i = 1, #instance.nodes do
		local node = instance.nodes[i]
		gui.set_position(node, get_pos(instance, i))
	end
end


function M.set_offset(instance, offset)
	instance.offset = offset
	update_pos(instance)
end


function M.set_anchor(instance, anchor)
	instance.anchor = anchor
	update_pos(instance)
end


function M.add(instance, item, index)
	index = index or (#instance.nodes + 1)
	table.insert(instance.nodes, index, item)
	gui.set_parent(item, instance.parent)

	local pos = get_pos(instance, index)
	check_border(instance, pos)
	gui.set_position(item, pos)
end


function M.get_size(instance)
	return instance.border
end


function M.get_all_pos(instance)
	local result = {}
	for i = 1, #instance.nodes do
		table.insert(result,	gui.get_position(instance.nodes[i]))
	end

	return result
end


return M