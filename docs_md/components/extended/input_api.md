# Input Quick API reference

```lua
input:get_text()
input:get_text_selected()
input:get_text_selected_replaced(text)
input:init(click_node, text_node, [keyboard_type])
input:is_empty()
input:is_full()
input:is_selected()
input:on_focus_lost()
input:on_input([action_id], [action])
input:on_input_interrupt()
input:on_style_change(style)
input:select()
input:select_cursor([index])
input:set_allowed_characters([pattern])
input:set_keyboard_type([keyboard_type])
input:set_marked_text([text])
input:set_max_length([length])
input:set_text([text])
input:unselect()
```
