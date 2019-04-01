local data = require("druid.data")

local M = {}

M.interest = {
	data.LAYOUT_CHANGED
}

function M.init(instance, name, key, init_value)
	instance.prop = hash("scale."..key)
	instance.key = key
	instance.node = gui.get_node(name)
	instance.scale = gui.get_scale(instance.node)
	instance:set_to(init_value or 1)
end

local function set_bar_to(instance, set_to)
  instance.last_value = set_to
  gui.cancel_animation(instance.node, instance.prop)
  instance.scale[instance.key] = set_to
  gui.set_scale(instance.node, instance.scale)
end

local function circle_anim(instance, full, steps, num, full_duration, callback)
  local duration = (math.abs(steps[num - 1] - steps[num]) / full) * full_duration
  local to = steps[num]
  gui.animate(instance.node, instance.prop, to, gui.EASING_LINEAR, duration, 0,
    function()
      callback(num, callback)
    end
  )
end

--- Fill a progress bar and stop progress animation
function M.fill_bar(instance)
  set_bar_to(instance, 1)
end

--- To empty a progress bar
function M.empty_bar(instance)
  set_bar_to(instance, 0)
end

--- Set fill a progress bar to value
-- @param to - value between 0..1
function M.set_to(instance, to)
  set_bar_to(instance, to)
end

--- Start animation of a progress bar
-- @param to - value between 0..1
-- @param duration - time of animation
-- @param callback - callback when progress ended if need
-- @param callback_values - whitch values should callback
function M.start_progress_to(instance, to, duration, callback, callback_values)
  instance.is_anim = true
  local steps
  if callback_values then
    steps = {instance.last_value}
    if instance.last_value > to then
      table.sort(callback_values, function(a, b) return a > b end)
    else
      table.sort(callback_values, function(a, b) return a < b end)
    end
    for i, v in ipairs(callback_values) do
      if (instance.last_value > v and to < v) or (instance.last_value < v and to > v) then
        steps[#steps + 1] = v
      end
    end
    steps[#steps + 1] = to
  end
  if not steps then
    gui.animate(instance.node, instance.prop, to, gui.EASING_LINEAR, duration, 0,
      function()
        set_bar_to(instance, to)
        instance.is_anim = false
        if callback then
          callback(instance.parent.parent, to)
        end
      end
    )
  else
    local full = math.abs(steps[1] - steps[#steps])
    local _callback = function (num, _callback)
      if num == #steps then
        set_bar_to(instance, steps[num])
        instance.is_anim = false
        callback(instance.parent.parent, steps[num])
      else
        callback(instance.parent.parent, steps[num])
        num = num + 1
        circle_anim(instance, full, steps, num, duration, _callback)
      end
    end
    circle_anim(instance, full, steps, 2, duration, _callback)
  end
end

--- Called when layout updated (rotate for example)
function M.on_layout_updated(instance)
  if not instance.is_anim then
    set_bar_to(instance, instance.last_value)
  end
end

return M