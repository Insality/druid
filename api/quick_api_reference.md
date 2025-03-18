# Quick API Reference

# Table of Contents
1. [Druid](#druid)
2. [Druid Instance](#druid-instance)
3. [Components](#components)
    1. [Base Component](#base-component)
    2. [Blocker](#blocker)
    3. [Button](#button)
    4. [Container](#container)
    5. [Data List](#data-list)
    6. [Drag](#drag)
    7. [Grid](#grid)
    8. [Hotkey](#hotkey)
    9. [Hover](#hover)
    10. [Input](#input)
    11. [Lang Text](#lang-text)
    12. [Layout](#layout)
    13. [Progress](#progress)
    14. [Rich Input](#rich-input)
    15. [Rich Text](#rich-text)
    16. [Scroll](#scroll)
    17. [Slider](#slider)
    18. [Swipe](#swipe)
    19. [Text](#text)
    20. [Timer](#timer)
4. [Helper](#helper)

# API Reference

## [Druid](druid_api.md)

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

## [Druid Instance](druid_instance_api.md)
```lua
-- Lifecycle
self.druid:final()
self.druid:update(dt)
self.druid:on_input(action_id, action)
self.druid:on_message(message_id, message, sender)
self.druid:on_window_event([window_event])

-- Component creation
self.druid:new(component, ...)
self.druid:new_widget(widget, [template], [nodes], ...)
self.druid:new_button(node, [callback], [params], [anim_node])
self.druid:new_text(node, [value], [no_adjust])
self.druid:new_grid(parent_node, item, [in_row])
self.druid:new_scroll(view_node, content_node)
self.druid:new_data_list(druid_scroll, druid_grid, create_function)
self.druid:new_progress(node, key, [init_value])
self.druid:new_lang_text(node, [locale_id], [adjust_type])
self.druid:new_rich_text(text_node, [value])
self.druid:new_back_handler([callback], [params])
self.druid:new_blocker(node)
self.druid:new_hover(node, [on_hover_callback], [on_mouse_hover_callback])
self.druid:new_drag(node, [on_drag_callback])
self.druid:new_swipe(node, [on_swipe_callback])
self.druid:new_input(click_node, text_node, [keyboard_type])
self.druid:new_rich_input(template, [nodes])
self.druid:new_layout(node, [mode])
self.druid:new_container(node, [mode], [callback])
self.druid:new_hotkey(keys_array, [callback], [callback_argument])
self.druid:new_slider(pin_node, end_pos, [callback])
self.druid:new_timer(node, [seconds_from], [seconds_to], [callback])

self.druid:remove(component)
self.druid:set_blacklist(blacklist_components)
self.druid:set_whitelist(whitelist_components)
```

## Components

### [Base Component](components/base/component_api.md)

Basic methods for all components.

```lua
component:get_childrens()
component:get_context()
component:get_druid([template], [nodes])
component:get_input_priority()
component:get_node(node_id)
component:get_nodes()
component:get_parent_component()
component:get_template()
component:reset_input_priority()
component:set_input_enabled(state)
component:set_input_priority(value, [is_temporary])
component:set_nodes(nodes)
component:set_style([druid_style])
component:set_template([template])
```

### [Blocker](components/base/blocker_api.md)

```lua
local blocker = self.druid:new_blocker(node)

blocker:is_enabled()
blocker:set_enabled(state)
```

### [Button](components/base/button_api.md)

```lua
local button = self.druid:new_button(node, [callback], [params], [anim_node])

button:get_key_trigger()
button:is_enabled()
button:set_check_function([check_function], [failure_callback])
button:set_click_zone([zone])
button:set_enabled([state])
button:set_key_trigger(key)
button:set_web_user_interaction([is_web_mode])
```

### [Container](components/extended/container_api.md)

```lua
local container = self.druid:new_container(node, [mode], [callback])

container:add_container(node_or_container, [mode], [on_resize_callback])
container:clear_draggable_corners()
container:create_draggable_corners()
container:fit_into_node(node)
container:fit_into_size(target_size)
container:fit_into_window()
container:get_position()
container:get_scale()
container:get_size()
container:on_window_resized()
container:refresh()
container:refresh_origins()
container:refresh_scale()
container:remove_container_by_node([node])
container:set_min_size([min_size_x], [min_size_y])
container:set_parent_container([parent_container])
container:set_pivot(pivot)
container:set_position(pos_x, pos_y)
container:set_size([width], [height], [anchor_pivot])
container:update_child_containers()
```

### [Data List](components/extended/data_list_api.md)

```lua
local data_list = self.druid:new_data_list(druid_scroll, druid_grid, create_function)

data_list:add(data, [index], [shift_policy])
data_list:clear()
data_list:get_created_components()
data_list:get_created_nodes()
data_list:get_data()
data_list:get_index(data)
data_list:remove([index], [shift_policy])
data_list:remove_by_data(data, [shift_policy])
data_list:scroll_to_index(index)
data_list:set_data(data)
data_list:set_use_cache(is_use_cache)
```

### [Drag](components/base/drag_api.md)

```lua
local drag = self.druid:new_drag(node, [on_drag_callback])

drag:is_enabled()
drag:on_window_resized()
drag:set_click_zone([node])
drag:set_drag_cursors(is_enabled)
drag:set_enabled(is_enabled)
```

### [Grid](components/base/static_grid_api.md)

```lua
local grid = self.druid:new_grid(parent_node, item, [in_row])

grid:add(item, [index], [shift_policy], [is_instant])
grid:clear()
grid:get_all_pos()
grid:get_borders()
grid:get_index(pos)
grid:get_index_by_node(node)
grid:get_offset()
grid:get_pos(index)
grid:get_size()
grid:get_size_for([count])
grid:refresh()
grid:remove(index, [shift_policy], [is_instant])
grid:set_anchor(anchor)
grid:set_in_row(in_row)
grid:set_item_size([width], [height])
grid:set_items(nodes, [is_instant])
grid:set_pivot([pivot])
grid:set_position_function(callback)
grid:sort_nodes(comparator)
```

### [Hotkey](components/extended/hotkey_api.md)

```lua
local hotkey = self.druid:new_hotkey(keys_array, [callback], [callback_argument])

hotkey:add_hotkey(keys, [callback_argument])
hotkey:is_processing()
hotkey:on_focus_gained()
hotkey:set_repeat(is_enabled_repeated)
```

### [Hover](components/base/hover_api.md)

```lua
local hover = self.druid:new_hover(node, [on_hover_callback], [on_mouse_hover_callback])

hover:is_enabled()
hover:is_hovered()
hover:is_mouse_hovered()
hover:set_click_zone([zone])
hover:set_enabled([state])
hover:set_hover([state])
hover:set_mouse_hover([state])
```

### [Input](components/extended/input_api.md)

```lua
local input = self.druid:new_input(click_node, text_node, [keyboard_type])

input:get_text()
input:get_text_selected()
input:get_text_selected_replaced(text)
input:move_selection(delta, is_add_to_selection, is_move_to_end)
input:on_focus_lost()
input:reset_changes()
input:select()
input:select_cursor([cursor_index], [start_index], [end_index])
input:set_allowed_characters(characters)
input:set_max_length(max_length)
input:set_text(input_text)
input:unselect()
```

### [Lang Text](components/extended/lang_text_api.md)

```lua
local lang_text = self.druid:new_lang_text(node, [locale_id], [adjust_type])

lang_text:format([a], [b], [c], [d], [e], [f], [g])
lang_text:on_language_change()
lang_text:set_text(text)
lang_text:set_to(text)
lang_text:translate(locale_id, [a], [b], [c], [d], [e], [f], [g])
```

### [Layout](components/extended/layout_api.md)

```lua
local layout = self.druid:new_layout(node, [mode])

layout:add(node_or_node_id)
layout:calculate_rows_data()
layout:clear_layout()
layout:get_content_size()
layout:get_entities()
layout:get_node_size(node)
layout:get_size()
layout:refresh_layout()
layout:remove(node_or_node_id)
layout:set_dirty()
layout:set_hug_content(is_hug_width, is_hug_height)
layout:set_justify(is_justify)
layout:set_margin([margin_x], [margin_y])
layout:set_node_index([node], [index])
layout:set_node_position(node, x, y)
layout:set_padding([padding_x], [padding_y], [padding_z], [padding_w])
layout:set_type(type)
layout:update()
```

### [Progress](components/extended/progress_api.md)

```lua
local progress = self.druid:new_progress(node, key, [init_value])

progress:empty()
progress:fill()
progress:get()
progress:set_max_size(max_size)
progress:set_steps(steps, callback)
progress:set_to(to)
progress:to(to, [callback])
progress:update([dt])
```

### [Rich Input](components/custom/rich_input_api.md)

```lua
local rich_input = self.druid:new_rich_input(template, [nodes])

rich_input:get_text()
rich_input:select()
rich_input:set_allowed_characters(characters)
rich_input:set_font(font)
rich_input:set_placeholder(placeholder_text)
rich_input:set_text(text)
```

### [Rich Text](components/custom/rich_text_api.md)

```lua
local rich_text = self.druid:new_rich_text(text_node, [value])

rich_text:characters(word)
rich_text:clear()
rich_text:get_line_metric()
rich_text:get_text()
rich_text:get_words()
rich_text:set_text([text])
rich_text:tagged(tag)
```

### [Scroll](components/base/scroll_api.md)

```lua
local scroll = self.druid:new_scroll(view_node, content_node)

scroll:bind_grid([grid])
scroll:get_percent()
scroll:get_scroll_size()
scroll:is_inert()
scroll:is_node_in_view(node)
scroll:scroll_to(point, [is_instant])
scroll:scroll_to_index(index, [skip_cb])
scroll:scroll_to_percent(percent, [is_instant])
scroll:set_click_zone(node)
scroll:set_extra_stretch_size([stretch_size])
scroll:set_horizontal_scroll(state)
scroll:set_inert(state)
scroll:set_points(points)
scroll:set_size(size, [offset])
scroll:set_vertical_scroll(state)
scroll:set_view_size(size)
scroll:update([dt])
scroll:update_view_size()
```

### [Slider](components/extended/slider_api.md)

```lua
local slider = self.druid:new_slider(pin_node, end_pos, [callback])

slider:is_enabled()
slider:set(value, [is_silent])
slider:set_enabled(is_enabled)
slider:set_input_node([input_node])
slider:set_steps(steps)
```

### [Swipe](components/extended/swipe_api.md)

```lua
local swipe = self.druid:new_swipe(node, [on_swipe_callback])

swipe:set_click_zone([zone])
```

### [Text](components/base/text_api.md)

```lua
local text = self.druid:new_text(node, [value], [no_adjust])

text:get_text()
text:get_text_adjust()
text:get_text_index_by_width(width)
text:get_text_size([text])
text:is_multiline()
text:set_alpha(alpha)
text:set_color(color)
text:set_minimal_scale(minimal_scale)
text:set_pivot(pivot)
text:set_scale(scale)
text:set_size(size)
text:set_text([new_text])
text:set_text_adjust([adjust_type], [minimal_scale])
text:set_to(set_to)
```

### [Timer](components/extended/timer_api.md)

```lua
local timer = self.druid:new_timer(node, [seconds_from], [seconds_to], [callback])

timer:set_interval(from, to)
timer:set_state([is_on])
timer:set_to(set_to)
timer:update([dt])
```

## [Helper](druid_helper_api.md)

```lua
local helper = require("druid.helper")

helper.add_array([target], [source])
helper.centrate_icon_with_text([icon_node], [text_node], [margin])
helper.centrate_nodes([margin], ...)
helper.centrate_text_with_icon([text_node], [icon_node], margin)
helper.clamp(value, [v1], [v2])
helper.contains([array], [value])
helper.deepcopy(orig_table)
helper.distance(x1, y1, x2, y2)
helper.get_animation_data_from_node(node, atlas_path)
helper.get_border(node, [offset])
helper.get_closest_stencil_node(node)
helper.get_full_position(node, [root])
helper.get_gui_scale()
helper.get_node(node_id, [template], [nodes])
helper.get_pivot_offset(pivot_or_node)
helper.get_scaled_size(node)
helper.get_scene_scale(node, [include_passed_node_scale])
helper.get_screen_aspect_koef()
helper.get_text_metrics_from_node(text_node)
helper.insert_with_shift(array, [item], [index], [shift_policy])
helper.is_mobile()
helper.is_multitouch_supported()
helper.is_web()
helper.is_web_mobile()
helper.lerp(a, b, t)
helper.pick_node(node, x, y, [node_click_area])
helper.remove_with_shift([array], [index], [shift_policy])
helper.round(num, [num_decimal_places])
helper.sign(val)
helper.step(current, target, step)
helper.table_to_string(t)
```
