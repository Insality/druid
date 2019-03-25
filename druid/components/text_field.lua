local M = {}

local ui_animate = require "druid.help_modules.druid_animate"

--- Bounce text field
function M.bounce(instance, callback)
  gui.set_scale(instance.node, instance.scale_from)
  ui_animate.bounce(nil, instance.node, instance.scale_to, callback)
end

--- Set text to text field
-- @param set_to - set value to text field
function M.set_to(instance, set_to)
  instance.last_value = set_to
  gui.set_text(instance.node, set_to)
end

--- Set color
-- @param color
function M.set_color(instance, color)
  instance.last_color = color
  gui.set_color(instance.node, color)
end

--- Set scale
-- @param scale
function M.set_scale(instance, scale)
  instance.last_scale = scale
  gui.set_scale(instance.node, scale)
end

--- Called when layout updated (rotate for example)
function M.on_layout_updated(instance)
  if instance.last_color then
    M.set_color(instance, instance.last_color)
  end
  if instance.last_scale then
    M.set_scale(instance, instance.last_scale)
  end
end

return M
