local M = {}

local text_field = require "druid.components.text_field"

local FRAMES = 60

--- Bounce text field
M.bounce = text_field.bounce

--- Set text to text field
-- @param set_to - set value to text field
M.set_to = text_field.set_to

--- Set color
-- @param color
M.set_color = text_field.set_color

--- Set scale
-- @param scale
M.set_scale = text_field.set_scale

--- Called when layout updated (rotate for example)
function M.on_layout_updated(instance)
  text_field.on_layout_updated(instance)
  if instance.last_value then
    text_field.set_to(instance, instance.last_value)
  end
end

--- Animate counter
-- @param set_to - set value to text field
function M.animate_to(instance, set_to, frames)
  if set_to == instance.last_value then
    text_field.set_to(instance, set_to)
  elseif not instance.is_animate then
    frames = frames or FRAMES
    instance.end_anim_value = set_to
    local diff = set_to - instance.last_value
    instance.anim_step = math.floor((set_to - instance.last_value) / frames)
    if diff ~= 0 and instance.anim_step == 0 then
      instance.anim_step = diff > 0 and 1 or - 1
    end
    instance.is_animate = true
  else
    instance.end_anim_value = set_to
  end
end

--- Called when update
-- @param dt - delta time
function M.on_updated(instance, dt)
  if instance.is_animate then
    instance.last_value = instance.last_value + instance.anim_step
    text_field.set_to(instance, instance.last_value)
    if not instance.is_in_bounce then
      instance.is_in_bounce = true
      text_field.bounce(instance, function() instance.is_in_bounce = false end)
    end
    if instance.anim_step > 0 and instance.last_value >= instance.end_anim_value or
    instance.anim_step < 0 and instance.last_value <= instance.end_anim_value then
      instance.is_animate = false
      text_field.set_to(instance, instance.end_anim_value)
    end
  end
end

return M
