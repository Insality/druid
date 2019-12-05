--- Druid helper module
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


--- Text node or icon node can be nil
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


--- Icon node or text node can be nil
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


-- call callback after count calls
function M.after(count, callback)
	local closure = function()
		count = count - 1
		if count <= 0 then
			callback()
		end
	end
	return closure
end


function M.node(node_or_name)
	if type(node_or_name) == const.STRING then
		return gui.get_node(node_or_name)
	end
	return node_or_name
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


function M.is_enabled(node)
	local is_enabled = gui.is_enabled(node)
	local parent = gui.get_parent(node)
	while parent and is_enabled do
		is_enabled = is_enabled and gui.is_enabled(parent)
		parent = gui.get_parent(parent)
	end
	return is_enabled
end


function M.get_pivot_offset(pivot)
	return const.PIVOTS[pivot]
end


function M.get_druid(self)
	local context = { _context = self }
	return setmetatable(context, { __index = self.context.druid })
end


return M
