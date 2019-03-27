local M = {}

local ui_animate = require "druid.helper.druid_animate"

--- Bounce image
function M.bounce(instance)
  gui.set_scale(instance.node, instance.scale_from)
  ui_animate.bounce(nil, instance.node, instance.scale_to)
end

--- Set image anim
-- @param set_to - index of animation or animation name
function M.set_to(instance, set_to)
  instance.last_value = set_to
  gui.play_flipbook(instance.node, instance.anim_table and instance.anim_table[set_to] or set_to)
end

--- Set position to the image
-- @param pos - set position of the image
function M.set_pos(instance, pos)
  instance.last_pos = pos
  gui.set_position(instance.node, pos)
end

--- Set tint to the image
-- @param color - set color of the image
function M.set_color(instance, color)
  instance.last_color = color
  gui.set_color(instance.node, color)
end

--- Called when layout updated (rotate for example)
function M.on_layout_updated(instance)
  if instance.last_value then
    M.set_to(instance, instance.last_value)
  end
  if instance.last_pos then
    M.set_pos(instance, instance.last_pos)
  end
  if instance.last_color then
    M.set_color(instance, instance.last_color)
  end
end


return M
