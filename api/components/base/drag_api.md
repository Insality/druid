# druid.drag API

> at /druid/base/drag.lua


## Functions
- [init](#init)
- [on_style_change](#on_style_change)
- [set_drag_cursors](#set_drag_cursors)
- [on_late_init](#on_late_init)
- [on_window_resized](#on_window_resized)
- [on_input_interrupt](#on_input_interrupt)
- [on_input](#on_input)
- [set_click_zone](#set_click_zone)
- [set_enabled](#set_enabled)
- [is_enabled](#is_enabled)


## Fields
- [node](#node)
- [on_touch_start](#on_touch_start)
- [on_touch_end](#on_touch_end)
- [on_drag_start](#on_drag_start)
- [on_drag](#on_drag)
- [on_drag_end](#on_drag_end)
- [style](#style)
- [click_zone](#click_zone)
- [is_touch](#is_touch)
- [is_drag](#is_drag)
- [can_x](#can_x)
- [can_y](#can_y)
- [dx](#dx)
- [dy](#dy)
- [touch_id](#touch_id)
- [x](#x)
- [y](#y)
- [screen_x](#screen_x)
- [screen_y](#screen_y)
- [touch_start_pos](#touch_start_pos)
- [druid](#druid)
- [hover](#hover)



### init

---
```lua
drag:init(node_or_node_id, on_drag_callback)
```

- **Parameters:**
	- `node_or_node_id` *(string|node)*:
	- `on_drag_callback` *(function)*:

### on_style_change

---
```lua
drag:on_style_change(style)
```

- **Parameters:**
	- `style` *(druid.drag.style)*:

### set_drag_cursors

---
```lua
drag:set_drag_cursors(is_enabled)
```

Set Drag component enabled state.

- **Parameters:**
	- `is_enabled` *(boolean)*:

### on_late_init

---
```lua
drag:on_late_init()
```

### on_window_resized

---
```lua
drag:on_window_resized()
```

### on_input_interrupt

---
```lua
drag:on_input_interrupt()
```

### on_input

---
```lua
drag:on_input(action_id, action)
```

- **Parameters:**
	- `action_id` *(hash)*:
	- `action` *(table)*:

- **Returns:**
	- `` *(boolean)*:

### set_click_zone

---
```lua
drag:set_click_zone([node])
```

Set Drag click zone

- **Parameters:**
	- `[node]` *(string|node|nil)*:

- **Returns:**
	- `self` *(druid.drag)*: Current instance

### set_enabled

---
```lua
drag:set_enabled(is_enabled)
```

Set Drag component enabled state.

- **Parameters:**
	- `is_enabled` *(boolean)*:

- **Returns:**
	- `self` *(druid.drag)*: Current instance

### is_enabled

---
```lua
drag:is_enabled()
```

Check if Drag component is capture input

- **Returns:**
	- `` *(boolean)*:


## Fields
<a name="node"></a>
- **node** (_node_)

<a name="on_touch_start"></a>
- **on_touch_start** (_event_)

<a name="on_touch_end"></a>
- **on_touch_end** (_event_)

<a name="on_drag_start"></a>
- **on_drag_start** (_event_)

<a name="on_drag"></a>
- **on_drag** (_event_)

<a name="on_drag_end"></a>
- **on_drag_end** (_event_)

<a name="style"></a>
- **style** (_druid.drag.style_)

<a name="click_zone"></a>
- **click_zone** (_node_)

<a name="is_touch"></a>
- **is_touch** (_boolean_)

<a name="is_drag"></a>
- **is_drag** (_boolean_)

<a name="can_x"></a>
- **can_x** (_boolean_)

<a name="can_y"></a>
- **can_y** (_boolean_)

<a name="dx"></a>
- **dx** (_number_)

<a name="dy"></a>
- **dy** (_number_)

<a name="touch_id"></a>
- **touch_id** (_number_)

<a name="x"></a>
- **x** (_number_)

<a name="y"></a>
- **y** (_number_)

<a name="screen_x"></a>
- **screen_x** (_number_)

<a name="screen_y"></a>
- **screen_y** (_number_)

<a name="touch_start_pos"></a>
- **touch_start_pos** (_vector3_)

<a name="druid"></a>
- **druid** (_druid.instance_)

<a name="hover"></a>
- **hover** (_druid.hover_)

