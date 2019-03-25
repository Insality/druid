--[[ Single tab screen module. Assumed to be used with Tab Bar module.

-- Create tab screen with parental gui node:
self.tab = tab.create "tab_bkg"

-- Show and hide tab manually:
self.tab.slide_in(self, vmath.vector3(0, -540, 0))
self.tab.slide_out(self, vmath.vector3(0, -540, 0))

-- Or receive show and hide messages:
function on_message(self, message_id, message, sender)
  self.tab.on_message(self, message_id, message)
end

]]

local M = {}
M.T_SLIDE_IN = hash("t_slide_in")
M.T_SLIDE_OUT = hash("t_slide_out")

M.STATE_START = hash("state_start")
M.STATE_FINISH = hash("state_finish")

local ENABLE = hash("enable")
local DISABLE = hash("disable")
local PATH_COMP = "#"

M.DEFAULT_EASING = gui.EASING_INOUTQUAD
M.DEFAULT_DURATION = 0.3

function M.slide_in(instance, out_pos, is_force)
  msg.post(PATH_COMP, ENABLE)
  if instance.callback then
    instance.callback(instance.parent.parent, instance, M.T_SLIDE_IN, M.STATE_START)
  end
  if is_force then
    gui.set_position(instance.node, instance.in_pos)
    if instance.callback then
      instance.callback(instance.parent.parent, instance, M.T_SLIDE_IN, M.STATE_FINISH)
    end
  else
    instance.in_action = true
    out_pos = out_pos or instance.put_pos
    gui.set_position(instance.node, out_pos or instance.out_pos)
    gui.animate(instance.node, gui.PROP_POSITION, instance.in_pos, instance.easing, instance.duration, 0,
      function()
        instance.in_action = false
        if instance.callback then
          instance.callback(instance.parent.parent, instance, M.T_SLIDE_IN, M.STATE_FINISH)
        end
      end
    )
  end
end

function M.slide_out(instance, out_pos, is_force)
  out_pos = out_pos or instance.put_pos
  if instance.callback then
    instance.callback(instance.parent.parent, instance, M.T_SLIDE_OUT, M.STATE_START)
  end
  if is_force then
    gui.set_position(instance.node, out_pos)
    if instance.callback then
      instance.callback(instance.parent.parent, instance, M.T_SLIDE_OUT, M.STATE_FINISH)
    end
    msg.post(PATH_COMP, DISABLE)
  else
    instance.in_action = true
    gui.set_position(instance.node, instance.in_pos)
    gui.animate(instance.node, gui.PROP_POSITION, out_pos, instance.easing, instance.duration, 0,
      function()
        instance.in_action = false
        if instance.callback then
          instance.callback(instance.parent.parent, instance, M.T_SLIDE_OUT, M.STATE_FINISH)
        end
        msg.post(PATH_COMP, DISABLE)
      end
    )
  end
end

function M.on_message(instance, message_id, message, sender)
  if message_id == M.T_SLIDE_IN then
    M.slide_in(instance, message.out_pos, message.is_force)
    return true
  elseif message_id == M.T_SLIDE_OUT then
    M.slide_out(instance, message.out_pos, message.is_force)
    return true
  end
end

return M
