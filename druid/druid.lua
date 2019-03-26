local M = {}

local druid_input = require "druid.help_modules.druid_input"
M.input = druid_input



local LAYOUT_CHANGED = hash("layout_changed")
local ON_MESSAGE = hash("on_message")
local ON_INPUT = hash("on_input")
local ON_SWIPE = hash("on_swipe")
local ON_UPDATE = hash("on_update")
M.TRANSLATABLE = hash("TRANSLATABLE")

local STRING = "string"

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
    druid_input.focus()
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
  end
  return instance
end


  end
end

return M
