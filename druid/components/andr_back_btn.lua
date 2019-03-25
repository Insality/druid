local M = {}

--- input handler
-- @param action_id - input action id
-- @param action - input action
function M.on_input(instance, action_id, action)
  instance.callback(instance.parent.parent)
  return true
end

return M
