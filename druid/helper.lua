-- Copyright (c) 2021 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Helper module with various usefull GUI functions.
-- @module Helper
-- @alias druid.helper

local const = require("druid.const")

local M = {}


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


--- Text node or icon node can be nil
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
-- @local
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
-- @local
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


--- Get current screen stretch multiplier for each side
-- @function helper.get_screen_aspect_koef
-- @treturn number stretch_x
-- @treturn number stretch_y
function M.get_screen_aspect_koef()
	local window_x, window_y = window.get_size()
	local stretch_x = window_x / gui.get_width()
	local stretch_y = window_y / gui.get_height()
	return stretch_x / math.min(stretch_x, stretch_y),
			stretch_y / math.min(stretch_x, stretch_y)
end


--- Get current GUI scale for each side
-- @function helper.get_gui_scale
-- @treturn number scale_x
-- @treturn number scale_y
function M.get_gui_scale()
	local window_x, window_y = window.get_size()
	return math.min(window_x / gui.get_width(),
		window_y / gui.get_height())
end


--- Move value from current to target value with step amount
-- @function helper.step
-- @tparam number current Current value
-- @tparam number target Target value
-- @tparam number step Step amount
-- @treturn number New value
function M.step(current, target, step)
	if current < target then
		return math.min(current + step, target)
	else
		return math.max(target, current - step)
	end
end


--- Clamp value between min and max
-- @function helper.clamp
-- @tparam number a Value
-- @tparam number min Min value
-- @tparam number max Max value
-- @treturn number Clamped value
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


--- Calculate distance between two points
-- @function helper.distance
-- @tparam number x1 First point x
-- @tparam number y1 First point y
-- @tparam number x2 Second point x
-- @tparam number y2 Second point y
-- @treturn number Distance
function M.distance(x1, y1, x2, y2)
	return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end


--- Return sign of value (-1, 0, 1)
-- @function helper.sign
-- @tparam number val Value
-- @treturn number Sign
function M.sign(val)
	if val == 0 then
		return 0
	end

	return (val < 0) and -1 or 1
end


--- Round number to specified decimal places
-- @function helper.round
-- @tparam number num Number
-- @tparam[opt=0] number num_decimal_places Decimal places
-- @treturn number Rounded number
function M.round(num, num_decimal_places)
	local mult = 10^(num_decimal_places or 0)
	return math.floor(num * mult + 0.5) / mult
end


--- Lerp between two values
-- @function helper.lerp
-- @tparam number a First value
-- @tparam number b Second value
-- @tparam number t Lerp amount
-- @treturn number Lerped value
function M.lerp(a, b, t)
	return a + (b - a) * t
end


--- Check if value is in array and return index of it
-- @function helper.contains
-- @tparam table t Array
-- @param value Value
-- @treturn number|nil Index of value or nil
function M.contains(t, value)
	for i = 1, #t do
		if t[i] == value then
			return i
		end
	end
	return nil
end


--- Make a copy table with all nested tables
-- @function helper.deepcopy
-- @tparam table orig_table Original table
-- @treturn table Copy of original table
function M.deepcopy(orig_table)
	local orig_type = type(orig_table)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, orig_table, nil do
			copy[M.deepcopy(orig_key)] = M.deepcopy(orig_value)
		end
	else -- number, string, boolean, etc
		copy = orig_table
	end
	return copy
end


--- Get node size adjusted by scale
-- @function helper.get_scaled_size
-- @tparam node node GUI node
-- @treturn vector3 Scaled size
function M.get_scaled_size(node)
	return vmath.mul_per_elem(gui.get_size(node), gui.get_scale(node))
end


--- Check if node is enabled in GUI hierarchy.
--
-- Return false, if node or any his parent is disabled
-- @function helper.is_enabled
-- @tparam node node GUI node
-- @treturn bool Is enabled in hierarchy
function M.is_enabled(node)
	return gui.is_enabled(node, true)
end


--- Get cumulative parent's node scale
-- @function helper.get_scene_scale
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


--- Return closest non inverted clipping parent node for given node
-- @function helper.get_closest_stencil_node
-- @tparam node node GUI node
-- @treturn node|nil The closest stencil node or nil
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


--- Get node offset for given GUI pivot.
--
-- Offset shown in [-0.5 .. 0.5] range, where -0.5 is left or bottom, 0.5 is right or top.
-- @function helper.get_pivot_offset
-- @tparam gui.pivot pivot The node pivot
-- @treturn vector3 Vector offset with [-0.5..0.5] values
function M.get_pivot_offset(pivot)
	return const.PIVOTS[pivot]
end


--- Check if device is native mobile (Android or iOS)
-- @function helper.is_mobile
-- @treturn bool Is mobile
function M.is_mobile()
	return const.CURRENT_SYSTEM_NAME == const.OS.IOS or
			 const.CURRENT_SYSTEM_NAME == const.OS.ANDROID
end


--- Check if device is HTML5
-- @function helper.is_web
-- @treturn bool Is web
function M.is_web()
	return const.CURRENT_SYSTEM_NAME == const.OS.BROWSER
end


--- Simple table to one-line string converter
-- @function helper.table_to_string
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
-- @tparam node node GUI node
-- @tparam[opt] vector3 offset Offset from node position. Pass current node position to get non relative border values
-- @treturn vector4 Vector4 with border values (left, top, right, down)
function M.get_border(node, offset)
	local pivot = gui.get_pivot(node)
	local pivot_offset = M.get_pivot_offset(pivot)
	local size = M.get_scaled_size(node)
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


--- Get text metric from GUI node.
-- @function helper.get_text_metrics_from_node
-- @tparam Node text_node
-- @treturn GUITextMetrics Fields: width, height, max_ascent, max_descent
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


--- Add value to array with shift policy
--
-- Shift policy can be: left, right, no_shift
-- @function helper.insert_with_shift
-- @tparam table array Array
-- @param item Item to insert
-- @tparam[opt] number index Index to insert. If nil, item will be inserted at the end of array
-- @tparam[opt] const.SHIFT shift_policy Shift policy
-- @treturn item Inserted item
function M.insert_with_shift(array, item, index, shift_policy)
	shift_policy = shift_policy or const.SHIFT.RIGHT

	local len = #array
	index = index or len + 1

	if array[index] and shift_policy ~= const.SHIFT.NO_SHIFT then
		local check_index = index
		local next_element = array[check_index]
		while next_element or (check_index >= 1 and check_index <= len) do
			check_index = check_index + shift_policy
			local check_element = array[check_index]
			array[check_index] = next_element
			next_element = check_element
		end
	end

	array[index] = item

	return item
end


--- Remove value from array with shift policy
--
-- Shift policy can be: left, right, no_shift
-- @function helper.remove_with_shift
-- @tparam table array Array
-- @tparam[opt] number index Index to remove. If nil, item will be removed from the end of array
-- @tparam[opt] const.SHIFT shift_policy Shift policy
-- @treturn item Removed item
function M.remove_with_shift(array, index, shift_policy)
	shift_policy = shift_policy or const.SHIFT.RIGHT

	local len = #array
	index = index or len

	local item = array[index]
	array[index] = nil

	if shift_policy ~= const.SHIFT.NO_SHIFT then
		local check_index = index + shift_policy
		local next_element = array[check_index]
		while next_element or (check_index >= 0 and check_index <= len + 1) do
			array[check_index - shift_policy] = next_element
			array[check_index] = nil
			check_index = check_index + shift_policy
			next_element = array[check_index]
		end
	end

	return item
end


--- Show deprecated message. Once time per message
-- @function helper.deprecated
-- @tparam string message The deprecated message
-- @local
local _deprecated_messages = {}
function M.deprecated(message)
	if _deprecated_messages[message] then
		return
	end

	print("[Druid]: " .. message)
	_deprecated_messages[message] = true
end


--- Show message to require extended component
-- @local
function M.extended_component(component_name)
	print(string.format("[Druid]: The component %s is extended component. You have to register it via druid.register to use it", component_name))
	print("[Druid]: Use next code:")
	print(string.format('local %s = require("druid.extended.%s")', component_name, component_name))
	print(string.format('druid.register("%s", %s)', component_name, component_name))
end


return M
