# druid.layout API

> at /druid/extended/layout.lua

Druid component to manage the layout of nodes, placing them inside the node size with respect to the size and pivot of each node.

### Setup
Create layout component with druid: `layout = druid:new_layout(node, layout_type)`

### Notes
- Layout can be horizontal, vertical or horizontal with wrapping
- Layout can resize parent node to fit content
- Layout can justify content
- Layout supports margins and padding
- Layout automatically updates when nodes are added or removed
- Layout can be manually updated by calling set_dirty()

## Functions

- [init](#init)
- [update](#update)
- [get_entities](#get_entities)
- [set_node_index](#set_node_index)
- [set_margin](#set_margin)
- [set_padding](#set_padding)
- [set_dirty](#set_dirty)
- [set_justify](#set_justify)
- [set_type](#set_type)
- [set_hug_content](#set_hug_content)
- [add](#add)
- [remove](#remove)
- [get_size](#get_size)
- [get_content_size](#get_content_size)
- [refresh_layout](#refresh_layout)
- [clear_layout](#clear_layout)
- [get_node_size](#get_node_size)
- [calculate_rows_data](#calculate_rows_data)
- [set_node_position](#set_node_position)

## Fields

- [node](#node)
- [rows_data](#rows_data)
- [is_dirty](#is_dirty)
- [entities](#entities)
- [margin](#margin)
- [padding](#padding)
- [type](#type)
- [is_resize_width](#is_resize_width)
- [is_resize_height](#is_resize_height)
- [is_justify](#is_justify)
- [on_size_changed](#on_size_changed)
- [size](#size)



### init

---
```lua
layout:init(node_or_node_id, layout_type)
```

```lua
layout_type:
    | "horizontal"
    | "vertical"
    | "horizontal_wrap"
```

- **Parameters:**
	- `node_or_node_id` *(string|node)*: The node to manage the layout of
	- `layout_type` *("horizontal"|"horizontal_wrap"|"vertical")*: The type of layout (horizontal, vertical, horizontal_wrap)

### update

---
```lua
layout:update()
```

### get_entities

---
```lua
layout:get_entities()
```

- **Returns:**
	- `entities` *(node[])*: The entities to manage the layout of

### set_node_index

---
```lua
layout:set_node_index(node, index)
```

- **Parameters:**
	- `node` *(node)*: The node to set the index of
	- `index` *(number)*: The index to set the node to

- **Returns:**
	- `self` *(druid.layout)*: for chaining

### set_margin

---
```lua
layout:set_margin([margin_x], [margin_y])
```

Set the margin of the layout

- **Parameters:**
	- `[margin_x]` *(number|nil)*: The margin x
	- `[margin_y]` *(number|nil)*: The margin y

- **Returns:**
	- `self` *(druid.layout)*: Current layout instance

### set_padding

---
```lua
layout:set_padding([padding_x], [padding_y], [padding_z], [padding_w])
```

- **Parameters:**
	- `[padding_x]` *(number|nil)*: The padding x
	- `[padding_y]` *(number|nil)*: The padding y
	- `[padding_z]` *(number|nil)*: The padding z
	- `[padding_w]` *(number|nil)*: The padding w

- **Returns:**
	- `self` *(druid.layout)*: Current layout instance

### set_dirty

---
```lua
layout:set_dirty()
```

- **Returns:**
	- `self` *(druid.layout)*: Current layout instance

### set_justify

---
```lua
layout:set_justify(is_justify)
```

- **Parameters:**
	- `is_justify` *(boolean)*:

- **Returns:**
	- `self` *(druid.layout)*: Current layout instance

### set_type

---
```lua
layout:set_type(layout_type)
```

```lua
layout_type:
    | "horizontal"
    | "vertical"
    | "horizontal_wrap"
```

- **Parameters:**
	- `layout_type` *("horizontal"|"horizontal_wrap"|"vertical")*:

- **Returns:**
	- `self` *(druid.layout)*: Current layout instance

### set_hug_content

---
```lua
layout:set_hug_content(is_hug_width, is_hug_height)
```

- **Parameters:**
	- `is_hug_width` *(boolean)*:
	- `is_hug_height` *(boolean)*:

- **Returns:**
	- `self` *(druid.layout)*: Current layout instance

### add

---
```lua
layout:add(node_or_node_id)
```

Add node to layout

- **Parameters:**
	- `node_or_node_id` *(string|node)*: node_or_node_id

- **Returns:**
	- `self` *(druid.layout)*: Current layout instance

### remove

---
```lua
layout:remove(node_or_node_id)
```

Remove node from layout

- **Parameters:**
	- `node_or_node_id` *(string|node)*: node_or_node_id

- **Returns:**
	- `self` *(druid.layout)*: for chaining

### get_size

---
```lua
layout:get_size()
```

- **Returns:**
	- `` *(vector3)*:

### get_content_size

---
```lua
layout:get_content_size()
```

- **Returns:**
	- `` *(number)*:
	- `` *(number)*:

### refresh_layout

---
```lua
layout:refresh_layout()
```

- **Returns:**
	- `self` *(druid.layout)*: Current layout instance

### clear_layout

---
```lua
layout:clear_layout()
```

- **Returns:**
	- `self` *(druid.layout)*: Current layout instance

### get_node_size

---
```lua
layout:get_node_size(node)
```

- **Parameters:**
	- `node` *(node)*:

- **Returns:**
	- `width` *(number)*: The width of the node
	- `height` *(number)*: The height of the node

### calculate_rows_data

---
```lua
layout:calculate_rows_data()
```

Calculate rows data for layout. Contains total width, height and rows info (width, height, count of elements in row)

- **Returns:**
	- `` *(druid.layout.rows_data)*:

### set_node_position

---
```lua
layout:set_node_position(node, x, y)
```

- **Parameters:**
	- `node` *(node)*:
	- `x` *(number)*:
	- `y` *(number)*:

- **Returns:**
	- `` *(node)*:


## Fields
<a name="node"></a>
- **node** (_node_): The node to manage the layout of

<a name="rows_data"></a>
- **rows_data** (_druid.layout.rows_data_): Last calculated rows data

<a name="is_dirty"></a>
- **is_dirty** (_boolean_): True if layout needs to be updated

<a name="entities"></a>
- **entities** (_node[]_): The entities to manage the layout of

<a name="margin"></a>
- **margin** (_{ x: number, y: number }_): The margin of the layout

<a name="padding"></a>
- **padding** (_vector4_): The padding of the layout

<a name="type"></a>
- **type** (_string_): The type of the layout

<a name="is_resize_width"></a>
- **is_resize_width** (_boolean_): True if the layout should resize the width of the node

<a name="is_resize_height"></a>
- **is_resize_height** (_boolean_): True if the layout should resize the height of the node

<a name="is_justify"></a>
- **is_justify** (_boolean_): True if the layout should justify the nodes

<a name="on_size_changed"></a>
- **on_size_changed** (_event.on_size_changed_): The event triggered when the size of the layout is changed

<a name="size"></a>
- **size** (_unknown_)

