# Slider Quick API reference

```lua
slider:init(node, end_pos, [callback])
slider:is_enabled()
slider:on_input([action_id], [action])
slider:on_layout_change()
slider:on_remove()
slider:on_window_resized()
slider:set(value, [is_silent])
slider:set_enabled(is_enabled)
slider:set_input_node([input_node])
slider:set_steps(steps)
