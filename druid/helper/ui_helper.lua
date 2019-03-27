local M = {}

function M.centrate_text_with_icon(text_node, icon_node)
  local metr = gui.get_text_metrics_from_node(text_node)
  local scl = gui.get_scale(text_node).x
  local scl_i = gui.get_scale(icon_node).x
  local pos_i = gui.get_position(icon_node)
  local pos = gui.get_position(text_node)
  local w = metr.width * scl * scl_i
  local icon_w = gui.get_size(icon_node).x * scl_i
  local width = w + icon_w + (math.abs(pos.x) - icon_w / 2) * scl_i
  pos_i.x = width / 2 - (icon_w / 2)
  gui.set_position(icon_node, pos_i)
end

function M.step(current, target, step)
  if current < target then
    return math.min(current + step, target)
  else
    return math.max(target, current - step)
  end
end

return M
