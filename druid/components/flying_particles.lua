local M = {}

local ui_animate = require "modules.ui.ui_animate"

local function fly_to(instance, pos_from, speed, callback)
  local pos_to = instance.get_pos_func()
  instance.last_speed = speed
  instance.last_callback = callback

  instance.last_particle = instance.last_particle + 1
  if instance.last_particle > #instance.fly_particles then
    instance.last_particle = 1
  end
  local fly_particle = instance.fly_particles[instance.last_particle]
  if pos_from then
    gui.set_position(fly_particle, pos_from)
  end
  gui.play_particlefx(fly_particle)
  instance.is_anim = true
  ui_animate.fly_to(nil, fly_particle, pos_to, speed,
    function()
      instance.is_anim = false
      gui.stop_particlefx(fly_particle)
      if callback then
        callback(instance.parent.parent)
        instance.last_callback = nil
      end
    end,
  0, gui.EASING_INSINE)
end

--- Start animation of a flying particles
-- @param pos_from - fly from this position
-- @param speed - speed of flying
-- @param callback - callback when progress ended if need
function M.fly_to(instance, pos_from, speed, callback)
  fly_to(instance, pos_from, speed, callback)
end

--- Called when layout updated (rotate for example)
function M.on_layout_updated(instance)
  if instance.is_anim then
    instance.last_particle = instance.last_particle - 1
    if instance.last_particle < 1 then
      instance.last_particle = #instance.fly_particles
    end
    fly_to(instance, nil, instance.last_speed, instance.last_callback)
  end
end


return M
