local M = {}

local formats = require "druid.helper.formats"

--- Set text to text field
-- @param set_to - set value in seconds
function M.set_to(instance, set_to)
  instance.last_value = set_to
  gui.set_text(instance.node, formats.second_string_min(set_to))
end

--- Called when layout updated (rotate for example)
function M.on_layout_updated(instance)
  M.set_to(instance, instance.last_value)
end

--- Called when update
-- @param is_on - boolean is timer on
function M.set_work_mode(instance, is_on)
  instance.is_on = is_on
end

--- Set time interval
-- @param from - "from" time in seconds
-- @param to - "to" time in seconds
function M.set_interval(instance, from, to)
  instance.second_from = from
  instance.seconds_counter = from
  instance.seconds_temp = 0
  instance.seconds_to = to
  instance.second_step = from < to and 1 or - 1
  M.set_work_mode(instance, true)
  M.set_to(instance, from)
end

--- Called when update
-- @param dt - delta time
function M.on_updated(instance, dt)
  if instance.is_on then
    instance.seconds_temp = instance.seconds_temp + dt
    if instance.seconds_temp > 1 then
      instance.seconds_temp = instance.seconds_temp - 1
      instance.seconds_counter = instance.seconds_counter + instance.second_step
      M.set_to(instance, instance.seconds_counter)
      if instance.seconds_counter == instance.seconds_to then
        instance.is_on = false
        instance.callback(instance)
      end
    end
  end
end

return M
