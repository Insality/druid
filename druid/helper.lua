--- Druid Helper module

local const = require("druid.const")

local gui_get_node = gui.get_node
local gui_get = gui.get
local gui_pick_node = gui.pick_node

---@class druid.system.helper
local M = {}

local POSITION_X = hash("position.x")
local SCALE_X = hash("scale.x")
local SIZE_X = hash("size.x")


local function get_text_width(text_node)
	if text_node then
		local text_metrics = M.get_text_metrics_from_node(text_node)
		local text_scale = gui_get(text_node, SCALE_X)
		return text_metrics.width * text_scale
	end

	return 0
end


local function get_icon_width(icon_node)
	if icon_node then
		return gui_get(icon_node, SIZE_X) * gui_get(icon_node, SCALE_X) -- icon width
	end

	return 0
end


local function is_text_node(node)
	return gui.get_text(node) ~= nil
end


--- Text node or icon node can be nil
local function get_width(node)
	return is_text_node(node) and get_text_width(node) or get_icon_width(node)
end


---Center two nodes.
--Nodes will be center around 0 x position
--text_node will be first (at left side)
---@param text_node node|nil Gui text node
---@param icon_node node|nil Gui box node
---@param margin number Offset between nodes
---@local
function M.centrate_text_with_icon(text_node, icon_node, margin)
	return M.centrate_nodes(margin, text_node, icon_node)
end


---Center two nodes.
--Nodes will be center around 0 x position
--icon_node will be first (at left side)
---@param icon_node node|nil Gui box node
---@param text_node node|nil Gui text node
---@param margin number|nil Offset between nodes
---@local
function M.centrate_icon_with_text(icon_node, text_node, margin)
	return M.centrate_nodes(margin, icon_node, text_node)
end


---Centerate nodes by x position with margin.
---
---This functions calculate total width of nodes and set position for each node.
---The centrate will be around 0 x position.
---@param margin number|nil Offset between nodes
---@param ... node Nodes to centrate
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

		pos_x = pos_x + node_width/2 -- made offset for single item

		local pivot_offset = M.get_pivot_offset(gui.get_pivot(node))
		local new_pos_x = pos_x - width/2 + pivot_offset.x * node_width -- centrate node
		gui.set(node, POSITION_X, new_pos_x)

		pos_x = pos_x + node_widths[i]/2 + margin -- add second part of offset
	end

	return width
end


---@param node_id string|node
---@param template string|nil @Full Path to the template
---@param nodes table<hash, node>|nil @Nodes what created with gui.clone_tree
---@return node
function M.get_node(node_id, template, nodes)
	if type(node_id) ~= "string" then
		-- Assume it's already node from gui.get_node
		return node_id
	end

	-- If template is set, then add it to the node_id
	if template and #template > 0 then
		node_id = template .. "/" .. node_id
	end

	-- If nodes is set, then try to find node in it
	if nodes then
		return nodes[node_id]
	end

	return gui_get_node(node_id)
end


---Get current screen stretch multiplier for each side
---@return number stretch_x
---@return number stretch_y
function M.get_screen_aspect_koef()
	local window_x, window_y = window.get_size()
	local stretch_x = window_x / gui.get_width()
	local stretch_y = window_y / gui.get_height()
	return stretch_x / math.min(stretch_x, stretch_y),
			stretch_y / math.min(stretch_x, stretch_y)
end


---Get current GUI scale for each side
---@return number scale_x
function M.get_gui_scale()
	local window_x, window_y = window.get_size()
	return math.min(window_x / gui.get_width(),
		window_y / gui.get_height())
end


---Move value from current to target value with step amount
---@param current number Current value
---@param target number Target value
---@param step number Step amount
---@return number New value
function M.step(current, target, step)
	if current < target then
		return math.min(current + step, target)
	else
		return math.max(target, current - step)
	end
end


---Clamp value between min and max
---@param a number Value
---@param min number Min value
---@param max number Max value
---@return number value Clamped value
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


---Calculate distance between two points
---@param x1 number First point x
---@param y1 number First point y
---@param x2 number Second point x
---@param y2 number Second point y
---@return number Distance
function M.distance(x1, y1, x2, y2)
	return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end


---Return sign of value
---@param val number Value
---@return number sign Sign of value, -1, 0 or 1
function M.sign(val)
	if val == 0 then
		return 0
	end

	return (val < 0) and -1 or 1
end


---Round number to specified decimal places
---@param num number Number
---@param num_decimal_places number|nil Decimal places
---@return number value Rounded number
function M.round(num, num_decimal_places)
	local mult = 10^(num_decimal_places or 0)
	return math.floor(num * mult + 0.5) / mult
end


---Lerp between two values
---@param a number First value
---@param b number Second value
---@param t number Lerp amount
---@return number value Lerped value
function M.lerp(a, b, t)
	return a + (b - a) * t
end


---Check if value contains in array
---@param array any[] Array to check
---@param value any Value
function M.contains(array, value)
	for index = 1, #array do
		if array[index] == value then
			return index
		end
	end
	return nil
end


---Make a copy table with all nested tables
---@param orig_table table Original table
---@return table Copy of original table
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


---Add all elements from source array to the target array
---@param target any[] Array to put elements from source
---@param source any[]|nil The source array to get elements from
---@return any[] The target array
function M.add_array(target, source)
	assert(target)

	if not source then
		return target
	end

	for index = 1, #source do
		table.insert(target, source[index])
	end

	return target
end


---Make a check with gui.pick_node, but with additional node_click_area check.
---@param node node
---@param x number
---@param y number
---@param node_click_area node|nil
---@local
function M.pick_node(node, x, y, node_click_area)
	local is_pick = gui_pick_node(node, x, y)

	if node_click_area then
		is_pick = is_pick and gui_pick_node(node_click_area, x, y)
	end

	return is_pick
end


---Get size of node with scale multiplier
---@param node node GUI node
---@treturn vector3 Scaled size
function M.get_scaled_size(node)
	return vmath.mul_per_elem(gui.get_size(node), gui.get_scale(node))
end


---Get cumulative parent's node scale
---@param node node Gui node
---@param include_passed_node_scale boolean|nil True if add current node scale to result
---@return vector3 The scene node scale
function M.get_scene_scale(node, include_passed_node_scale)
	local scale = include_passed_node_scale and gui.get_scale(node) or vmath.vector3(1)
	local parent = gui.get_parent(node)
	while parent do
		scale = vmath.mul_per_elem(scale, gui.get_scale(parent))
		parent = gui.get_parent(parent)
	end

	return scale
end


---Return closest non inverted clipping parent node for given node
---@param node node GUI node
---@return node|nil stencil_node The closest stencil node or nil
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


---Get pivot offset for given pivot or node
---Offset shown in [-0.5 .. 0.5] range, where -0.5 is left or bottom, 0.5 is right or top.
---@param pivot_or_node number|node GUI pivot or node
---@return vector3 offset The pivot offset
function M.get_pivot_offset(pivot_or_node)
	if type(pivot_or_node) == "number" then
		return const.PIVOTS[pivot_or_node]
	end
	return const.PIVOTS[gui.get_pivot(pivot_or_node)]
end


---Check if device is native mobile (Android or iOS)
---@return boolean Is mobile
function M.is_mobile()
	local sys_name = const.CURRENT_SYSTEM_NAME
	return sys_name == const.OS.IOS or sys_name == const.OS.ANDROID
end


---Check if device is HTML5
---@return boolean
function M.is_web()
	return const.CURRENT_SYSTEM_NAME == const.OS.BROWSER
end


---Check if device is HTML5 mobile
---@return boolean
function M.is_web_mobile()
	if html5 then
		return html5.run("(typeof window.orientation !== 'undefined') || (navigator.userAgent.indexOf('IEMobile') !== -1);") == "true"
	end
	return false
end


---Check if device is mobile and can support multitouch
---@return boolean is_multitouch Is multitouch supported
function M.is_multitouch_supported()
	return M.is_mobile() or M.is_web_mobile()
end


---Simple table to one-line string converter
---@param t table
---@return string
function M.table_to_string(t)
	if not t then
		return ""
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


---Distance from node position to his borders
---@param node node GUI node
---@param offset vector3|nil Offset from node position. Pass current node position to get non relative border values
---@return vector4 border Vector4 with border values (left, top, right, down)
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


---Get text metric from GUI node.
---@param text_node node
---@return GUITextMetrics
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


---Add value to array with shift policy
-- Shift policy can be: left, right, no_shift
---@param array table Array
---@param item any Item to insert
---@param index number|nil Index to insert. If nil, item will be inserted at the end of array
---@param shift_policy number|nil The druid_const.SHIFT.* constant
---@return any Inserted item
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


---Remove value from array with shift policy
--
-- Shift policy can be: left, right, no_shift
---@param array any[] Array
---@param index number|nil Index to remove. If nil, item will be removed from the end of array
---@param shift_policy number|nil  The druid_const.SHIFT.* constant
---@return any Removed item
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


local _deprecated_messages = {}

---Show deprecated message. Once time per message
---@param message string The deprecated message
function M.deprecated(message)
	if _deprecated_messages[message] then
		return
	end

	print("[Druid]: " .. message)
	_deprecated_messages[message] = true
end


---Show message to require component
---@param component_name string
---@param component_type string
function M.require_component_message(component_name, component_type)
	component_type = component_type or "extended"

	print(string.format("[Druid]: The component %s is %s component. You have to register it via druid.register to use it", component_name, component_type))
	print("[Druid]: Use next code:")
	print(string.format('local %s = require("druid.%s.%s")', component_name, component_type, component_name))
	print(string.format('druid.register("%s", %s)', component_name, component_name))
end


return M
