local M = {}

--local helper = require "modules.render.helper"
local tab_page = require "druid.components.tab_page"

local DISABLE = hash("disable")

function M.update_sizes(instance, width)
 -- width = width or helper.config_x
  instance.left = vmath.vector3(width * - 1, 0, 0)
  instance.right = vmath.vector3(width * 1, 0, 0)
end

--- Called when layout updated (rotate for example)
function M.on_layout_updated(instance, message)
 -- local width = helper.settings_x
  M.update_sizes(instance, width)
end

function M.switch_tab(instance, params, force)
  if instance.current == params then
    return
  end
  if instance.current then
    instance.btns[instance.current.index]:manual_back()
  end
  local out_pos
  if instance.current and instance.current.url then
    out_pos = (instance.current and instance.current.index < params.index) and instance.left or instance.right
    msg.post(instance.current.url, tab_page.T_SLIDE_OUT, { out_pos = out_pos, is_force = force })
  end
  if params and params.url then
    out_pos = (instance.current and instance.current.index > params.index) and instance.left or instance.right
    msg.post(params.url, tab_page.T_SLIDE_IN, { out_pos = out_pos, is_force = force })
    instance.current = params
  end
end

--- Select current tab manually
function M.select(instance, node_name)
  for k, v in pairs(instance.btns) do
    if k == instance[node_name].index then
      v:tap_anim(true)
    else
      msg.post(instance[v.name].url, DISABLE)
    end
  end
end

return M
