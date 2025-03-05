# Scroll Quick API reference

```lua
scroll:init(view_node, content_node)
scroll:bind_grid([grid], [callback])
scroll:get_percent()
scroll:on_input([action_id], [action])
scroll:on_layout_change()
scroll:on_late_init()
scroll:on_remove()
scroll:on_style_change(style)
scroll:scroll_to(point, [is_instant])
scroll:scroll_to_index(index, [skip_cb])
scroll:scroll_to_percent(percent, [is_instant])
scroll:set_click_zone([zone])
scroll:set_horizontal_scroll([is_horizontal])
scroll:set_size(size, [offset])
scroll:set_vertical_scroll([is_vertical])
scroll:update(dt)
```
