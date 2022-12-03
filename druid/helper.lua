-- Copyright (c) 2021 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Druid helper module for gui layouts
-- @module Helper
-- @alias druid.helper

local const = require("druid.const")

local M = {}


--- Text node or icon node can be nil
local function get_text_width(text_node)
	if text_node then
		local text_metrics = M.get_text_metrics_from_node(text_node)
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


local function get_width(node)
	return gui.get_text(node) and get_text_width(node) or get_icon_width(node)
end


--- Center two nodes.
-- Nodes will be center around 0 x position
-- text_node will be first (at left side)
-- @function helper.centrate_text_with_icon
-- @tparam[opt] text text_node Gui text node
-- @tparam[opt] box icon_node Gui box node
-- @tparam number margin Offset between nodes
function M.centrate_text_with_icon(text_node, icon_node, margin)
	M.centrate_nodes(margin, text_node, icon_node)
end


--- Center two nodes.
-- Nodes will be center around 0 x position
-- icon_node will be first (at left side)
-- @function helper.centrate_icon_with_text
-- @tparam[opt] box icon_node Gui box node
-- @tparam[opt] text text_node Gui text node
-- @tparam[opt=0] number margin Offset between nodes
function M.centrate_icon_with_text(icon_node, text_node, margin)
	M.centrate_nodes(margin, icon_node, text_node)
end


--- Center several nodes nodes.
-- Nodes will be center around 0 x position
-- @function helper.centrate_nodes
-- @tparam[opt=0] number margin Offset between nodes
-- @tparam[opt] Node ... Any count of gui Node
function M.centrate_nodes(margin, ...)
	margin = margin or 0

	local width = 0
	local count = select("#", ...)
	local node_widths = {}

	-- We need to get total width
	for i = 1, count do
		local node = select(i, ...)
		node_widths[i] = get_width(node)
		width = width + node_widths[i]
	end
	width = width + margin * (count - 1)

	-- Posing all elements
	local pos_x = 0
	for i = 1, count do
		local node = select(i, ...)
		local node_width = node_widths[i]
		local pos = gui.get_position(node)

		pos_x = pos_x + node_width/2 -- made offset for single item

		local pivot_offset = M.get_pivot_offset(gui.get_pivot(node))
		pos.x = pos_x - width/2 + pivot_offset.x * node_width -- centrate node
		gui.set_position(node, pos)

		pos_x = pos_x + node_widths[i]/2 + margin -- add second part of offset
	end
end


function M.get_screen_aspect_koef()
	local window_x, window_y = window.get_size()
	local stretch_x = window_x / gui.get_width()
	local stretch_y = window_y / gui.get_height()
	return stretch_x / math.min(stretch_x, stretch_y),
			stretch_y / math.min(stretch_x, stretch_y)
end


function M.get_gui_scale()
	local window_x, window_y = window.get_size()
	return math.min(window_x / gui.get_width(),
		window_y / gui.get_height())
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


--- Return current node scene scale
-- @function helper.is_enabled
-- @tparam node node Gui node
-- @tparam bool include_passed_node_scale True if add current node scale to result
-- @treturn vector3 The scene node scale
function M.get_scene_scale(node, include_passed_node_scale)
	local scale = include_passed_node_scale and gui.get_scale(node) or vmath.vector3(1)
	local parent = gui.get_parent(node)
	while parent do
		scale = vmath.mul_per_elem(scale, gui.get_scale(parent))
		parent = gui.get_parent(parent)
	end

	return scale
end


--- Return closest non inverted clipping parent node for node
-- @function helper.get_closest_stencil_node
-- @tparam node node Gui node
-- @treturn node|nil The clipping node
function M.get_closest_stencil_node(node)
	if not node then
		return nil
	end

	local parent = gui.get_parent(node)
	while parent do
		local clipping_mode = gui.get_clipping_mode(parent)
		local is_clipping_normal = not gui.get_clipping_inverted(parent)

		if is_clipping_normal and clipping_mode == gui.CLIPPING_MODE_STENCIL then
			return parent
		end

		parent = gui.get_parent(parent)
	end

	return nil
end


--- Get node offset for given gui pivot
-- @function helper.get_pivot_offset
-- @tparam gui.pivot pivot The node pivot
-- @treturn vector3 Vector offset with [-1..1] values
function M.get_pivot_offset(pivot)
	return const.PIVOTS[pivot]
end


--- Check if device is mobile (Android or iOS)
-- @function helper.is_mobile
function M.is_mobile()
	return const.CURRENT_SYSTEM_NAME == const.OS.IOS or
			 const.CURRENT_SYSTEM_NAME == const.OS.ANDROID
end


--- Check if device is HTML5
-- @function helper.is_web
function M.is_web()
	return const.CURRENT_SYSTEM_NAME == const.OS.BROWSER
end


--- Transform table to oneline string
-- @tparam table t
-- @treturn string
function M.table_to_string(t)
	if not t then
		return const.EMPTY_STRING
	end

	local result = "{"

	for key, value in pairs(t) do
		if #result > 1 then
			result = result .. ","
		end
		result = result .. key .. ": " .. value
	end

	return result .. "}"
end


--- Distance from node position to his borders
-- @function helper.get_border
-- @tparam node node The gui node to check
-- @tparam vector3 offset The offset to add to result
-- @return vector4 Vector with distance to node border: (left, top, right, down)
function M.get_border(node, offset)
	local pivot = gui.get_pivot(node)
	local pivot_offset = M.get_pivot_offset(pivot)
	local size = vmath.mul_per_elem(gui.get_size(node), gui.get_scale(node))
	local border = vmath.vector4(
		-size.x*(0.5 + pivot_offset.x),
		size.y*(0.5 - pivot_offset.y),
		size.x*(0.5 - pivot_offset.x),
		-size.y*(0.5 + pivot_offset.y)
	)

	if offset then
		border.x = border.x + offset.x
		border.y = border.y + offset.y
		border.z = border.z + offset.x
		border.w = border.w + offset.y
	end

	return border
end


--- Get text metric from gui node. Replacement of previous gui.get_text_metrics_from_node function
-- @tparam Node text_node
-- @treturn table {width, height, max_ascent, max_descent}
function M.get_text_metrics_from_node(text_node)
	local font_resource = gui.get_font_resource(gui.get_font(text_node))
	local options = {
		tracking = gui.get_tracking(text_node),
		line_break = gui.get_line_break(text_node),
	}

	-- Gather other options only if it used in node
	if options.line_break then
		options.width = gui.get_size(text_node).x
		options.leading = gui.get_leading(text_node)
	end

	return resource.get_text_metrics(font_resource, gui.get_text(text_node), options)
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
