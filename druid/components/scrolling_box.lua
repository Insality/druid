local M = {}

local druid_input = require "druid.helper.druid_input"
local ui_animate = require "druid.helper.druid_animate"

M.START = hash("START")
M.FINISH = hash("FINISH")

M.SCROLLING = hash("SCROLLING")
M.INTEREST_MOVE = hash("INTEREST_MOVE")
M.OUT_OF_ZONE_MOVE = hash("OUT_OF_ZONE_MOVE")

M.BACK_TIME = 0.2
M.ANIM_TIME = 0.4

local function callback(instance, event, type, param)
  if instance.callback then
    instance.callback(instance.parent.parent, event, type, param)
  end
end

local function checkSwipeDirection(swipe, action)
  swipe.xDistance = math.abs(swipe.endX - swipe.beginX)
  swipe.yDistance = math.abs(swipe.endY - swipe.beginY)
  if swipe.is_x and swipe.xDistance > swipe.yDistance then
    if swipe.beginX > swipe.endX then
      swipe.totalSwipeDistanceLeft = swipe.beginX - swipe.endX
      if swipe.totalSwipeDistanceLeft > swipe.minSwipeDistance then
        swipe.speed.x = action.dx * swipe.speed_up_coef.x * swipe.end_move_coef_x
        return true
      else
        return false
      end
    else
      swipe.totalSwipeDistanceRight = swipe.endX - swipe.beginX
      if swipe.totalSwipeDistanceRight > swipe.minSwipeDistance then
        swipe.speed.x = action.dx * swipe.speed_up_coef.x * swipe.end_move_coef_x
        return true
      else
        return false
      end
    end
  elseif swipe.is_y and swipe.xDistance < swipe.yDistance then
    if swipe.beginY > swipe.endY then
      swipe.totalSwipeDistanceUp = swipe.beginY - swipe.endY
      if swipe.totalSwipeDistanceUp > swipe.minSwipeDistance then
        swipe.speed.y = action.dy * swipe.speed_up_coef.y * swipe.end_move_coef_y
        return true
      else
        return false
      end
    else
      swipe.totalSwipeDistanceDown = swipe.endY - swipe.beginY
      if swipe.totalSwipeDistanceDown > swipe.minSwipeDistance then
        swipe.speed.y = action.dy * swipe.speed_up_coef.y * swipe.end_move_coef_y
        return true
      else
        return false
      end
    end
  end
end

function lenght(x1, y1, x2, y2)
  local a, b = x1 - x2, y1 - y2
  return math.sqrt(a * a + b * b)
end

local function back_move(instance)
  if not instance.swipe.end_position_x and not instance.swipe.end_position_y then
    if instance.points_of_interest then
      local min_index, min_lenght = 0, math.huge
      local len
      for k, v in pairs(instance.points_of_interest) do
        len = lenght(instance.pos.x, instance.pos.y, v.x, v.y)
        if len < min_lenght then
          min_lenght = len
          min_index = k
        end
      end
      instance.swipe.speed.x = 0
      instance.swipe.speed.y = 0
      gui.cancel_animation(instance.node, gui.PROP_POSITION)
      instance.swipe.special_move = true
      callback(instance, M.START, M.INTEREST_MOVE, instance.points_of_interest[min_index])
      gui.animate(instance.node, gui.PROP_POSITION, instance.points_of_interest[min_index],
        gui.EASING_LINEAR, M.ANIM_TIME, 0,
        function()
          instance.swipe.special_move = false
          instance.pos.x = instance.points_of_interest[min_index].x
          instance.pos.y = instance.points_of_interest[min_index].y
          callback(instance, M.FINISH, M.SCROLLING, instance.pos)
          callback(instance, M.FINISH, M.INTEREST_MOVE, instance.pos)
        end
      )
    else
      callback(instance, M.FINISH, M.SCROLLING, instance.pos)
    end
  end

  if instance.swipe.end_position_x then
    local swipe = instance.swipe
    swipe.speed.x = 0
    instance.pos.x = swipe.end_position_x
    swipe.special_move = true
    callback(instance, M.START, M.OUT_OF_ZONE_MOVE, instance.pos)
    gui.animate(instance.node, ui_animate.PROP_POS_X, swipe.end_position_x, gui.EASING_INSINE, M.BACK_TIME, 0,
      function()
        swipe.special_move = false
        callback(instance, M.FINISH, M.SCROLLING, instance.pos)
        callback(instance, M.FINISH, M.OUT_OF_ZONE_MOVE, instance.pos)
      end
    )
    swipe.end_position_x = nil
  end
  if instance.swipe.end_position_y then
    local swipe = instance.swipe
    swipe.speed.y = 0
    instance.pos.y = swipe.end_position_y
    swipe.special_move = true
    callback(instance, M.START, M.OUT_OF_ZONE_MOVE, instance.pos)
    gui.animate(instance.node, ui_animate.PROP_POS_Y, swipe.end_position_y, gui.EASING_INSINE, M.BACK_TIME, 0,
      function()
        swipe.special_move = false
        callback(instance, M.FINISH, M.SCROLLING, instance.pos)
        callback(instance, M.FINISH, M.OUT_OF_ZONE_MOVE, instance.pos)
      end
    )
    swipe.end_position_y = nil
  end
end

--- Set text to text field
-- @param action_id - input action id
-- @param action - input action
function M.on_input(instance, action_id, action)
  if action_id == druid_input.A_CLICK then
    if gui.pick_node(instance.scrolling_zone, action.x, action.y) then
      local swipe = instance.swipe
      if action.pressed then
        swipe.pressed = true
        swipe.beginX = action.x
        swipe.beginY = action.y
        druid_input.is_swipe = false
        swipe.end_move_coef_x = 1
      elseif not action.released and not action.pressed and not swipe.special_move then
        swipe.endX = action.x
        swipe.endY = action.y
        local before = swipe.is_swipe
        swipe.is_swipe = checkSwipeDirection(swipe, action)
        if not before and swipe.is_swipe and not swipe.special_move and not swipe.waiting_for_back_move then
          callback(instance, M.START, M.SCROLLING, instance.pos)
        end
        return swipe.is_swipe or swipe.special_move
      elseif action.released then
        swipe.beginX = 0
        swipe.beginY = 0
        swipe.endX = 0
        swipe.endY = 0
        swipe.pressed = false
        if swipe.waiting_for_back_move then
          back_move(instance)
          swipe.waiting_for_back_move = false
        end
        return swipe.is_swipe or swipe.special_move
      end
    elseif action.released then
      instance.swipe.pressed = false
      if instance.swipe.waiting_for_back_move then
        back_move(instance)
        instance.swipe.waiting_for_back_move = false
      end
    end
  end
end

--- Called when update
-- @param dt - delta time
function M.on_updated(instance, dt)
  if instance.swipe.speed.x ~= 0 or instance.swipe.speed.y ~= 0 then
    local swipe = instance.swipe
    instance.pos.x = instance.pos.x + swipe.speed.x
    instance.pos.y = instance.pos.y + swipe.speed.y
    if instance.pos.x < instance.start_pos.x then
      swipe.end_move_coef_x = swipe.back_slow_coef
      swipe.end_position_x = instance.start_pos.x
    elseif instance.pos.x > instance.maximum.x then
      swipe.end_move_coef_x = swipe.back_slow_coef
      swipe.end_position_x = instance.maximum.x
    else
      swipe.end_move_coef_x = 1
      swipe.end_position_x = nil
    end
    if instance.pos.y < instance.start_pos.y then
      swipe.end_move_coef_y = swipe.back_slow_coef
      swipe.end_position_y = instance.start_pos.y
    elseif instance.pos.y > instance.maximum.y then
      swipe.end_move_coef_y = swipe.back_slow_coef
      swipe.end_position_y = instance.maximum.y
    else
      swipe.end_move_coef_y = 1
      swipe.end_position_y = nil
    end
    gui.set_position(instance.node, instance.pos)
    swipe.speed.x = swipe.speed.x / swipe.speed_down_coef * swipe.end_move_coef_x
    swipe.speed.y = swipe.speed.y / swipe.speed_down_coef * swipe.end_move_coef_y
    if swipe.speed.x < swipe.min_speed and swipe.speed.x > - swipe.min_speed then
      swipe.speed.x = 0
      if not swipe.pressed then
        back_move(instance)
      else
        swipe.waiting_for_back_move = true
      end
      if swipe.speed.y < swipe.min_speed and swipe.speed.y > - swipe.min_speed then
        swipe.speed.y = 0
      end
      if swipe.speed.y == 0 and swipe.speed.x == 0 then
        swipe.is_swipe = false
      end
    end
  end
end

--- Scroll position to
-- @param pos - positon for set
-- @param is_animate - is animated set
function M.scroll_to(instance, pos, is_animate, cb, time_scrolling)
  local time = is_animate and M.ANIM_TIME or 0
  time = time_scrolling or time
  instance.pos.x = pos.x
  instance.pos.y = pos.y
  gui.animate(instance.node, gui.PROP_POSITION, instance.pos, gui.EASING_INSINE, time, 0,
    function()
      if cb then
        cb(instance.parent.parent)
      end
    end
  )
end

return M
