# druid.helper API

> at /druid/helper.lua

The helper module contains various functions that are used in the Druid library.
You can use these functions in your projects as well.

## Functions

- [centrate_text_with_icon](#centrate_text_with_icon)
- [centrate_icon_with_text](#centrate_icon_with_text)
- [centrate_nodes](#centrate_nodes)
- [get_node](#get_node)
- [get_screen_aspect_koef](#get_screen_aspect_koef)
- [get_gui_scale](#get_gui_scale)
- [step](#step)
- [clamp](#clamp)
- [distance](#distance)
- [sign](#sign)
- [round](#round)
- [lerp](#lerp)
- [contains](#contains)
- [deepcopy](#deepcopy)
- [add_array](#add_array)
- [pick_node](#pick_node)
- [get_scaled_size](#get_scaled_size)
- [get_scene_scale](#get_scene_scale)
- [get_closest_stencil_node](#get_closest_stencil_node)
- [get_pivot_offset](#get_pivot_offset)
- [is_desktop](#is_desktop)
- [is_mobile](#is_mobile)
- [is_web](#is_web)
- [is_web_mobile](#is_web_mobile)
- [is_multitouch_supported](#is_multitouch_supported)
- [table_to_string](#table_to_string)
- [get_border](#get_border)
- [get_text_metrics_from_node](#get_text_metrics_from_node)
- [insert_with_shift](#insert_with_shift)
- [remove_with_shift](#remove_with_shift)
- [get_full_position](#get_full_position)
- [get_animation_data_from_node](#get_animation_data_from_node)


### centrate_text_with_icon

---
```lua
helper.centrate_text_with_icon([text_node], [icon_node], margin)
```

Center two nodes.
Nodes will be center around 0 x position
text_node will be first (at left side)

- **Parameters:**
	- `[text_node]` *(node|nil)*: Gui text node
	- `[icon_node]` *(node|nil)*: Gui box node
	- `margin` *(number)*: Offset between nodes

- **Returns:**
	- `width` *(number)*: Total width of the centrated elements

### centrate_icon_with_text

---
```lua
helper.centrate_icon_with_text([icon_node], [text_node], [margin])
```

Center two nodes.
Nodes will be center around 0 x position
icon_node will be first (at left side)

- **Parameters:**
	- `[icon_node]` *(node|nil)*: Gui box node
	- `[text_node]` *(node|nil)*: Gui text node
	- `[margin]` *(number|nil)*: Offset between nodes

- **Returns:**
	- `width` *(number)*: Total width of the centrated elements

### centrate_nodes

---
```lua
helper.centrate_nodes([margin], ...)
```

Centerate nodes by x position with margin.
This functions calculate total width of nodes and set position for each node.
The centrate will be around 0 x position.

- **Parameters:**
	- `[margin]` *(number|nil)*: Offset between nodes
	- `...` *(...)*: vararg

- **Returns:**
	- `width` *(number)*: Total width of the centrated elements

### get_node

---
```lua
helper.get_node(node_id, [template], [nodes])
```

Get GUI node from string name, node itself, or template/nodes structure

- **Parameters:**
	- `node_id` *(string|node)*: The node name or node itself
	- `[template]` *(string|nil)*: Full path to the template
	- `[nodes]` *(table<hash, node>|nil)*: Nodes created with gui.clone_tree

- **Returns:**
	- `The` *(node)*: requested node

### get_screen_aspect_koef

---
```lua
helper.get_screen_aspect_koef()
```

Get current screen stretch multiplier for each side

- **Returns:**
	- `stretch_x` *(number)*:
	- `stretch_y` *(number)*:

### get_gui_scale

---
```lua
helper.get_gui_scale()
```

Get current GUI scale

- **Returns:**
	- `scale` *(number)*:

### step

---
```lua
helper.step(current, target, step)
```

Move value from current to target value with step amount

- **Parameters:**
	- `current` *(number)*: Current value
	- `target` *(number)*: Target value
	- `step` *(number)*: Step amount

- **Returns:**
	- `New` *(number)*: value

### clamp

---
```lua
helper.clamp(value, [v1], [v2])
```

Clamp value between min and max. Works with nil values and swap min and max if needed.

- **Parameters:**
	- `value` *(number)*: Value
	- `[v1]` *(number|nil)*: Min value. If nil, value will be clamped to positive infinity
	- `[v2]` *(number|nil)*: Max value If nil, value will be clamped to negative infinity

- **Returns:**
	- `value` *(number)*: Clamped value

### distance

---
```lua
helper.distance(x1, y1, x2, y2)
```

Calculate distance between two points

- **Parameters:**
	- `x1` *(number)*: First point x
	- `y1` *(number)*: First point y
	- `x2` *(number)*: Second point x
	- `y2` *(number)*: Second point y

- **Returns:**
	- `distance` *(number)*:

### sign

---
```lua
helper.sign(val)
```

Return sign of value

- **Parameters:**
	- `val` *(number)*: Value

- **Returns:**
	- `sign` *(number)*: Sign of value, -1, 0 or 1

### round

---
```lua
helper.round(num, [num_decimal_places])
```

Round number to specified decimal places

- **Parameters:**
	- `num` *(number)*: Number
	- `[num_decimal_places]` *(number|nil)*: Decimal places

- **Returns:**
	- `value` *(number)*: Rounded number

### lerp

---
```lua
helper.lerp(a, b, t)
```

Lerp between two values

- **Parameters:**
	- `a` *(number)*: First value
	- `b` *(number)*: Second value
	- `t` *(number)*: Lerp amount

- **Returns:**
	- `value` *(number)*: Lerped value

### contains

---
```lua
helper.contains([array], [value])
```

Check if value contains in array

- **Parameters:**
	- `[array]` *(any[])*: Array to check
	- `[value]` *(any)*: Value

- **Returns:**
	- `index` *(number|nil)*: Index of value in array or nil if value not found

### deepcopy

---
```lua
helper.deepcopy(orig_table)
```

Make a copy table with all nested tables

- **Parameters:**
	- `orig_table` *(table)*: Original table

- **Returns:**
	- `Copy` *(table)*: of original table

### add_array

---
```lua
helper.add_array([target], [source])
```

Add all elements from source array to the target array

- **Parameters:**
	- `[target]` *(any[])*: Array to put elements from source
	- `[source]` *(any[]|nil)*: The source array to get elements from

- **Returns:**
	- `The` *(any[])*: target array

### pick_node

---
```lua
helper.pick_node(node, x, y, [node_click_area])
```

Make a check with gui.pick_node, but with additional node_click_area check.

- **Parameters:**
	- `node` *(node)*:
	- `x` *(number)*:
	- `y` *(number)*:
	- `[node_click_area]` *(node|nil)*: Additional node to check for click area. If nil, only node will be checked

- **Returns:**
	- `` *(unknown)*:

### get_scaled_size

---
```lua
helper.get_scaled_size(node)
```

Get size of node with scale multiplier

- **Parameters:**
	- `node` *(node)*: GUI node

- **Returns:**
	- `scaled_size` *(vector3)*:

### get_scene_scale

---
```lua
helper.get_scene_scale(node, [include_passed_node_scale])
```

Get cumulative parent's node scale

- **Parameters:**
	- `node` *(node)*: Gui node
	- `[include_passed_node_scale]` *(boolean|nil)*: True if add current node scale to result

- **Returns:**
	- `The` *(vector3)*: scene node scale

### get_closest_stencil_node

---
```lua
helper.get_closest_stencil_node(node)
```

Return closest non inverted clipping parent node for given node

- **Parameters:**
	- `node` *(node)*: GUI node

- **Returns:**
	- `stencil_node` *(node|nil)*: The closest stencil node or nil

### get_pivot_offset

---
```lua
helper.get_pivot_offset(pivot_or_node)
```

Get pivot offset for given pivot or node
Offset shown in [-0.5 .. 0.5] range, where -0.5 is left or bottom, 0.5 is right or top.

- **Parameters:**
	- `pivot_or_node` *(number|node)*: GUI pivot or node

- **Returns:**
	- `offset` *(vector3)*: The pivot offset

### is_desktop

---
```lua
helper.is_desktop()
```

Check if device is desktop

- **Returns:**
	- `` *(boolean)*:

### is_mobile

---
```lua
helper.is_mobile()
```

Check if device is native mobile (Android or iOS)

- **Returns:**
	- `Is` *(boolean)*: mobile

### is_web

---
```lua
helper.is_web()
```

Check if device is HTML5

- **Returns:**
	- `` *(boolean)*:

### is_web_mobile

---
```lua
helper.is_web_mobile()
```

Check if device is HTML5 mobile

- **Returns:**
	- `` *(boolean)*:

### is_multitouch_supported

---
```lua
helper.is_multitouch_supported()
```

Check if device is mobile and can support multitouch

- **Returns:**
	- `is_multitouch` *(boolean)*: Is multitouch supported

### table_to_string

---
```lua
helper.table_to_string(t, [depth], [result])
```

Converts table to one-line string

- **Parameters:**
	- `t` *(table)*:
	- `[depth]` *(number?)*:
	- `[result]` *(string|nil)*: Internal parameter

- **Returns:**
	- `` *(string)*: String representation of table, Is max string length reached
	- `result` *(boolean)*: String representation of table, Is max string length reached

### get_border

---
```lua
helper.get_border(node, [offset])
```

Distance from node position to his borders

- **Parameters:**
	- `node` *(node)*: GUI node
	- `[offset]` *(vector3|nil)*: Offset from node position. Pass current node position to get non relative border values

- **Returns:**
	- `border` *(vector4)*: Vector4 with border values (left, top, right, down)

### get_text_metrics_from_node

---
```lua
helper.get_text_metrics_from_node(text_node)
```

Get text metric from GUI node.

- **Parameters:**
	- `text_node` *(node)*:

- **Returns:**
	- `` *(GUITextMetrics)*:

### insert_with_shift

---
```lua
helper.insert_with_shift(array, [item], [index], [shift_policy])
```

Add value to array with shift policy
Shift policy can be: left, right, no_shift

- **Parameters:**
	- `array` *(table)*: Array
	- `[item]` *(any)*: Item to insert
	- `[index]` *(number|nil)*: Index to insert. If nil, item will be inserted at the end of array
	- `[shift_policy]` *(number|nil)*: The druid_const.SHIFT.* constant

- **Returns:**
	- `Inserted` *(any)*: item

### remove_with_shift

---
```lua
helper.remove_with_shift([array], [index], [shift_policy])
```

Remove value from array with shift policy
 Shift policy can be: left, right, no_shift

- **Parameters:**
	- `[array]` *(any[])*: Array
	- `[index]` *(number|nil)*: Index to remove. If nil, item will be removed from the end of array
	- `[shift_policy]` *(number|nil)*: The druid_const.SHIFT.* constant

- **Returns:**
	- `Removed` *(any)*: item

### get_full_position

---
```lua
helper.get_full_position(node, [root])
```

Get full position of node in the GUI tree

- **Parameters:**
	- `node` *(node)*: GUI node
	- `[root]` *(node|nil)*: GUI root node to stop search

- **Returns:**
	- `` *(unknown)*:

### get_animation_data_from_node

---
```lua
helper.get_animation_data_from_node(node, atlas_path)
```

Source: https://github.com/Dragosha/defold-sprite-repeat/blob/main/node_repeat/node_repeat.lua
Thanks to Dragosha! ( ・ω・ ) <  Hey friend!

- **Parameters:**
	- `node` *(node)*:
	- `atlas_path` *(string)*: Path to the atlas

- **Returns:**
	- `` *(druid.system.animation_data)*:

