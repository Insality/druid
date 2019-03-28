local M = {}

function M.centrate_text_with_icon(text_node, icon_node, offset_x)
	offset_x = offset_x or 0
	local metr = gui.get_text_metrics_from_node(text_node)
	local scl = gui.get_scale(text_node).x
	local pos = gui.get_position(text_node)
	local scl_i = gui.get_scale(icon_node).x
	local pos_i = gui.get_position(icon_node)
	local w = metr.width * scl -- text width
	local icon_w = gui.get_size(icon_node).x * scl_i -- icon width
	local width = w + icon_w

	pos.x = -width/2 + w + offset_x
	gui.set_position(text_node, pos)
	pos_i.x = width/2 - icon_w + offset_x
	gui.set_position(icon_node, pos_i)
end


local STRING = "string"
function M.get_node(node_or_name)
	if type(node_or_name) == STRING then
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


return M