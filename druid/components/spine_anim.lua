local M = {}

--- Set animation scene
-- @param scene - animations scene
function M.set_scene(instance, scene)
  instance.last_scene = scene
  gui.set_spine_scene(instance.node, scene)
end


--- Set idle animation
-- @param anim - idle animation name or index in idle table
-- @param properties - properties of the animation
function M.play_idle(instance, anim, properties)
  if not anim then
    return
  end
  anim = (instance.idle_table and instance.idle_table[anim]) and instance.idle_table[anim] or anim
  instance.last_value = anim
  properties = properties or {}
  gui.play_spine_anim(instance.node, anim, gui.PLAYBACK_LOOP_FORWARD, properties)
end

--- Set active animation
-- @param anim - active animation name or index in active table
-- @param callback - call when animation done
-- @param idle_after - set idle after active anim
function M.play_active(instance, anim, callback, idle_after)
  instance.is_play_now = true
  anim = instance.active_table and instance.active_table[anim] or anim
  instance.last_value = anim
  instance.callback = callback
  M.play_idle(instance, idle_after)
  gui.play_spine_anim(instance.node, anim, gui.PLAYBACK_ONCE_FORWARD, {},
    function()
      M.play_idle(instance, idle_after)
      instance.is_play_now = false
      if callback then
        callback(instance.parent.parent)
      end
    end
  )
end

--- Called when layout updated (rotate for example)
function M.on_layout_updated(instance)
  if instance.last_scene then
    M.set_scene(instance, instance.last_scene)
  end
  if instance.last_value then
    M.play_idle(instance, instance.last_value)
  end
  if instance.is_play_now then
    instance.is_play_now = false
    if instance.callback then
      instance.callback(instance.parent.parent)
    end
  end
end


return M
