# druid.drag API

> at /druid/base/drag.lua

A component that allows you to subscribe to drag events over a node

## Functions

- [init](#init)
- [set_drag_cursors](#set_drag_cursors)
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
drag:init(node_or_node_id, [on_drag_callback])
```

The constructor for Drag component

- **Parameters:**
	- `node_or_node_id` *(string|node)*: The node to subscribe to drag events over
	- `[on_drag_callback]` *(fun(self: any, touch: any))*: The callback to call when a drag occurs

### set_drag_cursors

---
```lua
drag:set_drag_cursors(is_enabled)
```

Set Drag component enabled state.

- **Parameters:**
	- `is_enabled` *(boolean)*: True if Drag component is enabled

### set_click_zone

---
```lua
drag:set_click_zone([node])
```

Set Drag click zone

- **Parameters:**
	- `[node]` *(string|node|nil)*: Node or node id

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
	- `is_enabled` *(boolean)*: True if Drag component is enabled


## Fields
<a name="node"></a>
- **node** (_node_): The node to subscribe to drag events over

<a name="on_touch_start"></a>
- **on_touch_start** (_event_): fun(self, touch) The event triggered when a touch starts

<a name="on_touch_end"></a>
- **on_touch_end** (_event_): fun(self, touch) The event triggered when a touch ends

<a name="on_drag_start"></a>
- **on_drag_start** (_event_): fun(self, touch) The event triggered when a drag starts

<a name="on_drag"></a>
- **on_drag** (_event_): fun(self, touch) The event triggered when a drag occurs

<a name="on_drag_end"></a>
- **on_drag_end** (_event_): fun(self, touch) The event triggered when a drag ends

<a name="style"></a>
- **style** (_druid.drag.style_): The style of Drag component

<a name="click_zone"></a>
- **click_zone** (_node_): The click zone of Drag component

<a name="is_touch"></a>
- **is_touch** (_boolean_): True if a touch is active

<a name="is_drag"></a>
- **is_drag** (_boolean_): True if a drag is active

<a name="can_x"></a>
- **can_x** (_boolean_): True if Drag can move horizontally

<a name="can_y"></a>
- **can_y** (_boolean_): True if Drag can move vertically

<a name="dx"></a>
- **dx** (_number_): The horizontal drag distance

<a name="dy"></a>
- **dy** (_number_): The vertical drag distance

<a name="touch_id"></a>
- **touch_id** (_number_): The touch id

<a name="x"></a>
- **x** (_number_): The current x position

<a name="y"></a>
- **y** (_number_): The current y position

<a name="screen_x"></a>
- **screen_x** (_number_): The current screen x position

<a name="screen_y"></a>
- **screen_y** (_number_): The current screen y position

<a name="touch_start_pos"></a>
- **touch_start_pos** (_vector3_): The touch start position

<a name="druid"></a>
- **druid** (_druid.instance_): The Druid Factory used to create components

<a name="hover"></a>
- **hover** (_druid.hover_): The component for handling hover events on a node

