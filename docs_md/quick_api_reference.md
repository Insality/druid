# Quick API Reference

## Druid
```lua
local druid = require("druid.druid")

druid.init_window_listener()
druid.on_language_change()
druid.on_window_callback(window_event)
druid.set_default_style(style)
druid.set_sound_function(callback)
druid.set_text_function(callback)

self.druid = druid.new(context, [style])
```

## Druid Instance
```lua
self.druid:final()
self.druid:update(dt)
self.druid:on_input(action_id, action)
self.druid:on_message(message_id, message, sender)

self.druid:new(component, ...)
self.druid:new_back_handler([callback], [params])
self.druid:new_blocker(node)
self.druid:new_button(node, [callback], [params], [anim_node])
self.druid:new_container(node, [mode], [callback])
self.druid:new_data_list(druid_scroll, druid_grid, create_function)
self.druid:new_drag(node, [on_drag_callback])
self.druid:new_grid(parent_node, item, [in_row])
self.druid:new_hotkey(keys_array, [callback], [callback_argument])
self.druid:new_hover(node, [on_hover_callback], [on_mouse_hover_callback])
self.druid:new_input(click_node, text_node, [keyboard_type])
self.druid:new_lang_text(node, [locale_id], [adjust_type])
self.druid:new_layout(node, [mode])
self.druid:new_progress(node, key, [init_value])
self.druid:new_rich_input(template, [nodes])
self.druid:new_rich_text(text_node, [value])
self.druid:new_scroll(view_node, content_node)
self.druid:new_slider(pin_node, end_pos, [callback])
self.druid:new_swipe(node, [on_swipe_callback])
self.druid:new_text(node, [value], [no_adjust])
self.druid:new_timer(node, [seconds_from], [seconds_to], [callback])
self.druid:new_widget(widget, [template], [nodes], ...)
self.druid:on_window_event([window_event])
self.druid:remove(component)
self.druid:set_blacklist(blacklist_components)
self.druid:set_whitelist(whitelist_components)
```

## Components
### Base Component
### Blocker
### Button
### Container
### Data List
### Drag
### Grid
### Hotkey
### Hover
### Input
### Lang Text
### Layout
### Progress
### Rich Input
### Rich Text
### Scroll
### Slider
### Swipe
### Text
### Timer

## Helper
