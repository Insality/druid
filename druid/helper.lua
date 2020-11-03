-- Druid helper module for gui layouts
-- @module helper

local const = require("druid.const")

local M = {}


--- Text node or icon node can be nil
local function get_text_width(text_node)
	if text_node then
		local text_metrics = gui.get_text_metrics_from_node(text_node)
		local text_scale = gui.get_scale(text_node).x
		return text_metrics.width * text_scale
	end

	return 0
end


local function get_icon_width(icon_node)
	if icon_node then
		local icon_scale_x = gui.get_scale(icon_node).x
		return gui.get_size(icon_node).x * icon_scale_x -- icon width
	end

	return 0
end


--- Center two nodes.
-- Nodes will be center around 0 x position
-- text_node will be first (at left side)
-- @function helper.centrate_text_with_icon
-- @tparam[opt] text text_node Gui text node
-- @tparam[opt] box icon_node Gui box node
-- @tparam number margin Offset between nodes
function M.centrate_text_with_icon(text_node, icon_node, margin)
	margin = margin or 0
	local text_width = get_text_width(text_node)
	local icon_width = get_icon_width(icon_node)
	local width = text_width + icon_width

	if text_node then
		local pos = gui.get_position(text_node)
		pos.x = -width/2 + text_width - margin/2
		gui.set_position(text_node, pos)
	end

	if icon_node then
		local icon_pos = gui.get_position(icon_node)
		icon_pos.x = width/2 - icon_width + margin/2
		gui.set_position(icon_node, icon_pos)
	end
end


--- Center two nodes.
-- Nodes will be center around 0 x position
-- icon_node will be first (at left side)
-- @function helper.centrate_icon_with_text
-- @tparam[opt] box icon_node Gui box node
-- @tparam[opt] text text_node Gui text node
-- @tparam[opt=0] number margin Offset between nodes
function M.centrate_icon_with_text(icon_node, text_node, margin)
	margin = margin or 0
	local icon_width = get_icon_width(icon_node)
	local text_width = get_text_width(text_node)
	local width = text_width + icon_width

	if text_node then
		local pos = gui.get_position(text_node)
		pos.x = width/2 - text_width + margin/2
		gui.set_position(text_node, pos)
	end

	if icon_node then
		local icon_pos = gui.get_position(icon_node)
		icon_pos.x = -width/2 + icon_width - margin/2
		gui.set_position(icon_node, icon_pos)
	end
end


function M.step(current, target, step)
	if current < target then
		return math.min(current + step, target)
	else
		return math.max(target, current - step)
	end
end


function M.clamp(a, min, max)
	if min > max then
		min, max = max, min
	end

	if a >= min and a <= max then
		return a
	elseif a < min then
		return min
	else
		return max
	end
end


function M.distance(x1, y1, x2, y2)
	return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end


function M.sign(val)
	if val == 0 then
		return 0
	end

	return (val < 0) and -1 or 1
end


function M.round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end


function M.lerp(a, b, t)
	return a + (b - a) * t
end


function M.contains(t, value)
	for i = 1, #t do
		if t[i] == value then
			return i
		end
	end
	return false
end


--- Check if node is enabled in gui hierarchy.
-- Return false, if node or any his parent is disabled
-- @function helper.is_enabled
-- @tparam node node Gui node
-- @treturn bool Is enabled in hierarchy
function M.is_enabled(node)
	local is_enabled = gui.is_enabled(node)
	local parent = gui.get_parent(node)
	while parent and is_enabled do
		is_enabled = is_enabled and gui.is_enabled(parent)
		parent = gui.get_parent(parent)
	end

	return is_enabled
end


--- Get node offset for given gui pivot
-- @function helper.get_pivot_offset
-- @tparam gui.pivot pivot The node pivot
-- @treturn vector3 Vector offset with [-1..1] values
function M.get_pivot_offset(pivot)
	return const.PIVOTS[pivot]
end


--- Check if device is mobile (Android or iOS)
-- @function helper..is_mobile
function M.is_mobile()
	local system_name = sys.get_sys_info().system_name
	return system_name == const.OS.IOS or system_name == const.OS.ANDROID
end


--- Check if device is HTML5
-- @function helper.is_web
function M.is_web()
	local system_name = sys.get_sys_info().system_name
	return system_name == const.OS.BROWSER
end


--- Distance from node to size border
-- @function helper.get_border
-- @return vector4 (left, top, right, down)
function M.get_border(node)
	local pivot = gui.get_pivot(node)
	local pivot_offset = M.get_pivot_offset(pivot)
	local size = vmath.mul_per_elem(gui.get_size(node), gui.get_scale(node))
	return vmath.vector4(
		-size.x*(0.5 + pivot_offset.x),
		size.y*(0.5 - pivot_offset.y),
		size.x*(0.5 - pivot_offset.x),
		-size.y*(0.5 + pivot_offset.y)
	)
end


--- Show deprecated message. Once time per message
-- @function helper.deprecated
-- @tparam string message The deprecated message
local _deprecated_messages = {}
function M.deprecated(message)
	if _deprecated_messages[message] then
		return
	end

	print("[Druid]: " .. message)
	_deprecated_messages[message] = true
end


-- Show message to require extended component
function M.extended_component(component_name)
	print(string.format("[Druid]: The component %s is extended component. You have to register it via druid.register to use it", component_name))
	print("[Druid]: Use next code:")
	print(string.format('local %s = require("druid.extended.%s")', component_name, component_name))
	print(string.format('druid.register("%s", %s)', component_name, component_name))
end


return M
