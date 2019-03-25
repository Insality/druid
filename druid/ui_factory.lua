local M = {}

local lang = require "modules.localize.lang"
local input = require "modules.input.input"
M.input = input

local pie_progress_bar = require "modules.ui.components.pie_progress_bar"
local progress_bar = require "modules.ui.components.progress_bar"
local flying_particles = require "modules.ui.components.flying_particles"
local text_field = require "modules.ui.components.text_field"
local counter = require "modules.ui.components.counter"
local image = require "modules.ui.components.image"
local button = require "modules.ui.components.button"
local timer = require "modules.ui.components.timer"
local tab_page = require "modules.ui.components.tab_page"
local tabs_container = require "modules.ui.components.tabs_container"
local spine_anim = require "modules.ui.components.spine_anim"
local scrolling_box = require "modules.ui.components.scrolling_box"

local andr_back_btn = require "modules.ui.components.andr_back_btn"

local LAYOUT_CHANGED = hash("layout_changed")
local ON_MESSAGE = hash("on_message")
local ON_INPUT = hash("on_input")
local ON_SWIPE = hash("on_swipe")
local ON_UPDATE = hash("on_update")
M.TRANSLATABLE = hash("TRANSLATABLE")

local STRING = "string"

--- Call this method when you need to update translations.
function M.translate(factory)
  if factory[M.TRANSLATABLE] then
    local key, result
    for i, v in ipairs(factory[M.TRANSLATABLE]) do
      key = v.lang_key or v.name
      if key then
        if v.lang_params then
          result = lang.txp(key, v.lang_params)
        else
          result = lang.txt(key)
        end
        if result then
          lang.set_node_properties(v.node, key)
        end
        result = result or v.last_value
        v:set_to(result)
      end
    end
  end
end

--- Called on_message
function M.on_message(factory, message_id, message, sender)
  if message_id == LAYOUT_CHANGED then
    if factory[LAYOUT_CHANGED] then
      M.translate(factory)
      for i, v in ipairs(factory[LAYOUT_CHANGED]) do
        v:on_layout_updated(message)
      end
    end
  elseif message_id == M.TRANSLATABLE then
    M.translate(factory)
  else
    if factory[ON_MESSAGE] then
      for i, v in ipairs(factory[ON_MESSAGE]) do
        v:on_message(message_id, message, sender)
      end
    end
  end
end

--- Called ON_INPUT
function M.on_input(factory, action_id, action)
  if factory[ON_SWIPE] then
    local v, result
    local len = #factory[ON_SWIPE]
    for i = 1, len do
      v = factory[ON_SWIPE][i]
      result = result or v:on_input(action_id, action)
    end
    if result then
      return true
    end
  end
  if factory[ON_INPUT] then
    local v
    local len = #factory[ON_INPUT]
    for i = 1, len do
      v = factory[ON_INPUT][i]
      if action_id == v.event and action[v.action] and v:on_input(action_id, action) then
        return true
      end
    end
    return false
  end
  return false
end

--- Called on_update
function M.on_update(factory, dt)
  if factory[ON_UPDATE] then
    for i, v in ipairs(factory[ON_UPDATE]) do
      v:on_updated(dt)
    end
  end
end

--- Create UI instance for ui elements
-- @return instance with all ui components
function M.new(self)
  local factory = setmetatable({}, {__index = M})
  factory.parent = self
  return factory
end

local function input_init(factory)
  if not factory.input_inited then
    factory.input_inited = true
    input.focus()
  end
end

--------------------------------------------------------------------------------

local function create(meta, factory, name, ...)
  local instance = setmetatable({}, {__index = meta})
  instance.parent = factory
  if name then
    if type(name) == STRING then
      instance.name = name
      instance.node = gui.get_node(name)
    else
      --name already is node
      instance.name = nil
      instance.node = name
    end
  end
  factory[#factory + 1] = instance
  local register_to = {...}
  for i, v in ipairs(register_to) do
    if not factory[v] then
      factory[v] = {}
    end
    factory[v][#factory[v] + 1] = instance
  end
  return instance
end

--- Create new instance of a text_field
-- @param factory - parent factory
-- @param name - name of text node
-- @param init_value - init ui object with this value
-- @return instance of a text_field
function M.new_text_field(factory, name, init_value, bounce_in)
  local instance = create(text_field, factory, name, M.TRANSLATABLE, LAYOUT_CHANGED)
  instance.scale_from = gui.get_scale(instance.node)
  instance.scale_to = bounce_in and vmath.mul_per_elem(instance.scale_from, bounce_in) or instance.scale_from
  instance:set_to(init_value or 0)
  return instance
end

--- Create new instance of a counter
-- @param factory - parent factory
-- @param name - name of text node
-- @param init_value - init ui object with this value
-- @return instance of a text_field
function M.new_counter(factory, name, init_value)
  local instance = create(counter, factory, name, LAYOUT_CHANGED, ON_UPDATE)
  instance.scale_from = gui.get_scale(instance.node)
  instance.scale_to = instance.scale_from * 1.2
  instance:set_to(init_value or 0)
  return instance
end

--- Create new instance of an image
-- @param factory - parent factory
-- @param name - name of image node
-- @param anim_table - table with animations or frames
-- @param init_frame - init with this frame
-- @return instance of an image
function M.new_image(factory, name, anim_table, init_frame, bounce_in)
  local instance = create(image, factory, name, LAYOUT_CHANGED)
  instance.scale_from = gui.get_scale(instance.node)
  instance.scale_to = bounce_in and vmath.mul_per_elem(instance.scale_from, bounce_in) or instance.scale_from
  instance.anim_table = anim_table
  if init_frame then
    instance:set_to(init_frame)
  elseif anim_table then
    instance:set_to(1)
  end
  return instance
end

--- Create new instance of a timer
-- @param factory - parent factory
-- @param name - name of image node
-- @param second_from - start time
-- @param seconds_to - end time
-- @param callback - call when timer finished
-- @return instance of a timer
function M.new_timer(factory, name, second_from, seconds_to, callback)
  local instance = create(timer, factory, name, LAYOUT_CHANGED, ON_UPDATE)
  instance:set_to(second_from)
  instance:set_interval(second_from, seconds_to)
  instance.is_on = true
  instance.callback = callback
  return instance
end

--- Add new pie progress component for handling
-- @param factory - parent factory
-- @param name - a node name for a pie progress instance
-- @param init_value - init ui object with this value
-- @return instance with pie_progress
function M.new_pie_progress(factory, name, init_value)
  local instance = create(pie_progress_bar, factory, name, LAYOUT_CHANGED)
  instance:set_to(init_value or 1)
  return instance
end

--- Add new progress bar component for handling
-- @param factory - parent factory
-- @param name - name of the fill node
-- @param key - x or y - key for scale
-- @param init_value - init ui object with this value
-- @return instance with pie_progress
function M.new_progress_bar(factory, name, key, init_value)
  local instance = create(progress_bar, factory, name, LAYOUT_CHANGED)
  instance.prop = hash("scale."..key)
  instance.key = key
  instance.node = gui.get_node(name)
  instance.scale = gui.get_scale(instance.node)
  instance:set_to(init_value or 1)
  return instance
end

--- Create new instance of a flying particles
-- @param factory - parent factory
-- @param name - name of prototype
-- @param count - how many particles need to cache
-- @param get_pos_func - function that returns target pos for flying
-- @return instance of a flying particles
function M.new_flying_particles(factory, name, count, get_pos_func)
  local instance = create(flying_particles, factory, name, LAYOUT_CHANGED)
  instance.get_pos_func = get_pos_func
  local node = instance.node
  instance.node = node
  instance.fly_particles = {}
  instance.fly_particles[1] = node
  for i = 2, count do
    instance.fly_particles[i] = gui.clone(node)
  end
  instance.scale = gui.get_scale(node)
  instance.last_particle = 0
  return instance
end

M.BTN_SOUND_FUNC = function() end
M.BTN_SOUND_DISABLE_FUNC = function()end

--- Add new button component for handling
-- @param factory - parent factory
-- @param name - a node name for a button instance
-- @param callback - click button callback
-- @param params - callback parameters, will be returned with self callback(self, params)
-- @param animate_node_name - node for animation, if it's not a main node
-- @return instance of button
function M.new_button(factory, name, callback, params, animate_node_name, event, action, sound, sound_disable)
  input_init(factory)
  local instance = create(button, factory, name, ON_INPUT)
  instance.event = event or input.A_CLICK
  instance.action = action or input.RELEASED
  instance.anim_node = animate_node_name and gui.get_node(animate_node_name) or instance.node
  instance.scale_from = gui.get_scale(instance.anim_node)
  instance.scale_to = instance.scale_from + button.DEFAULT_SCALE_CHANGE
  instance.pos = gui.get_position(instance.anim_node)
  instance.callback = callback
  instance.params = params
  instance.tap_anim = button.tap_scale_animation
  instance.back_anim = button.back_scale_animation
  instance.sound = sound or M.BTN_SOUND_FUNC
  instance.sound_disable = sound_disable or M.BTN_SOUND_DISABLE_FUNC
  return instance
end

--- Add reaction for back btn (on Android for example)
-- @param factory - parent factory
-- @param callback - tap button callback
function M.new_back_handler(factory, callback)
  input_init(factory)
  local instance = create(andr_back_btn, factory, nil, ON_INPUT)
  instance.event = input.A_ANDR_BACK
  instance.action = input.RELEASED
  instance.callback = callback
  return instance
end

--- Create new tab page instance
-- @param factory - parent factory
-- @param name - name of parental node that represents tab page content
-- @param easing - easing for tab page
-- @param duration - duration of animation for tab page
-- @param callback - call when change page
-- @return instance that represents the tab page
function M.new_tab_page(factory, name, easing, duration, callback)
  local instance = create(tab_page, factory, name, ON_MESSAGE)
  instance.in_pos = gui.get_position(instance.node)
  instance.out_pos = gui.get_position(instance.node)
  instance.easing = easing or tab_page.DEFAULT_EASING
  instance.duration = duration or tab_page.DEFAULT_DURATION
  instance.callback = callback
  return instance
end

--- Create new tab btns container instance
-- @param factory - parent factory
-- @param name - name of parental node that represents tab btns container
-- @return instance that represents the tab btns container
function M.new_tabs_container(factory, name, callback)
  local instance = create(tabs_container, factory, name, LAYOUT_CHANGED)
  instance:update_sizes()
  instance.url = msg.url()
  --- Create new tab btn  instance
  -- @param name - name of parental node that represents tab btn
  -- @return instance that represents the tab btn
  function instance.new_tab_btn(_instance, _name, url, index)
    local params = {url = url, index = index, name = _name}
    local btn = M.new_button(factory, _name, nil, params)
    btn.back_anim = nil
    btn.manual_back = button.back_tab_animation
    btn.tap_anim = button.tap_tab_animation
    btn.callback = function(_, _, force)
      instance.switch_tab(instance, params, force)
      if callback then
        callback(factory.parent, index, force)
      end
    end
    instance[_name] = params
    if not instance.btns then
      instance.btns = {}
    end
    instance.btns[index] = btn
    return btn
  end

  return instance
end

--- Add new spine animation
-- @param factory - parent factory
-- @param name - a node name for a spine anim
-- @param idle_table - table with idle animations
-- @param active_table - table with active animations
-- @param init_idle - init idle animation name or index in idle table
-- @return instance with spine anim
function M.new_spine_anim(factory, name, idle_table, active_table, init_idle)
  local instance = create(spine_anim, factory, name, LAYOUT_CHANGED)
  instance.idle_table = idle_table
  instance.active_table = active_table
  instance:play_idle(init_idle)
  return instance
end

--- Add new scrolling box
-- @param factory - parent factory
-- @param name - a node name for a spine anim
-- @param zone_name - node name of zone for tap
-- @param speed_coef -  vector3 coef. of speed for scrolling
-- @param maximum - vector3 maximum position for scrolling
-- @param points_of_interest - table with vector3 point of interes
-- @param callback - scrolling events callback
-- @return instance with scrolling box
function M.new_scrolling_box(factory, name, zone_name, speed_coef, maximum, points_of_interest, callback)
  local instance = create(scrolling_box, factory, name, ON_UPDATE, ON_SWIPE)
  instance.pos = gui.get_position(instance.node)
  instance.start_pos = vmath.vector3(instance.pos)
  instance.maximum = maximum
  instance.points_of_interest = points_of_interest
  instance.callback = callback
  if instance.start_pos.x > instance.maximum.x then
    instance.start_pos.x, instance.maximum.x = instance.maximum.x, instance.start_pos.x
  end
  if instance.start_pos.y > instance.maximum.y then
    instance.start_pos.y, instance.maximum.y = instance.maximum.y, instance.start_pos.y
  end
  if type(name) == STRING then
    instance.scrolling_zone = gui.get_node(zone_name)
  else
    instance.scrolling_zone = zone_name
  end
  instance.swipe = {
    minSwipeDistance = 40,
    speed_down_coef = 1.1,
    speed_up_coef = speed_coef or vmath.vector3(1.1, 1.1, 0),
    speed = vmath.vector3(0, 0, 0),
    maximum = vmath.vector3(0, 0, 0),
    min_speed = 2,
    beginX = 0,
    beginY = 0,
    endX = 0,
    endY = 0,
    xDistance = nil,
    yDistance = nil,
    totalSwipeDistanceLeft = nil,
    totalSwipeDistanceRight = nil,
    totalSwipeDistanceUp = nil,
    totalSwipeDistanceDown = nil,
    is_swipe = nil,
    end_move_coef_x = 1,
    end_move_coef_y = 1,
    back_slow_coef = 0.4,
    end_position_x = nil,
    end_position_y = nil,
    is_x = instance.start_pos.x ~= instance.maximum.x,
    is_y = instance.start_pos.y ~= instance.maximum.y
  }
  return instance
end

return M
