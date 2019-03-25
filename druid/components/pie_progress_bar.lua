local M = {}

local FULL_FILL = 360

local function set_bar_to(instance, set_to)
  instance.last_value = set_to
  gui.cancel_animation(instance.node, gui.PROP_FILL_ANGLE)
  gui.set_fill_angle(instance.node, FULL_FILL * set_to)
end

--- Fill a pie progress bar and stop progress animation
function M.fill_bar(instance)
  set_bar_to(instance, 1)
end

--- To empty a pie progress bar
function M.empty_bar(instance)
  set_bar_to(instance, 0)
end

--- Set fill a pie progress bar to value
-- @param to - value between 0..1
function M.set_to(instance, to)
  set_bar_to(instance, to)
end

--- Start animation of a pie progress bar
-- @param to - value between 0..1
-- @param duration - time of animation
-- @param callback - callback when progress ended if need
function M.start_progress_to(instance, to, duration, callback)
  instance.is_anim = true
  instance.last_value = to
  gui.animate(instance.node, gui.PROP_FILL_ANGLE, FULL_FILL * to, gui.EASING_LINEAR, duration, 0,
    function()
      instance.is_anim = false
      if callback then
        callback(instance.parent.parent)
      end
    end
  )
end

--- Called when layout updated (rotate for example)
function M.on_layout_updated(instance)
  if not instance.is_anim then
    set_bar_to(instance, instance.last_value)
  end
end

return M
