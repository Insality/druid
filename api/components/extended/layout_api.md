# druid.layout API

> at /druid/extended/layout.lua


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
	- `node_or_node_id` *(string|node)*:
	- `layout_type` *(druid.layout.mode)*:

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
	- `` *(node[])*:

### set_node_index

---
```lua
layout:set_node_index([node], [index])
```

- **Parameters:**
	- `[node]` *(any)*:
	- `[index]` *(any)*:

### set_margin

---
```lua
layout:set_margin([margin_x], [margin_y])
```

- **Parameters:**
	- `[margin_x]` *(number|nil)*:
	- `[margin_y]` *(number|nil)*:

- **Returns:**
	- `` *(druid.layout)*:

### set_padding

---
```lua
layout:set_padding([padding_x], [padding_y], [padding_z], [padding_w])
```

- **Parameters:**
	- `[padding_x]` *(number|nil)*:
	- `[padding_y]` *(number|nil)*:
	- `[padding_z]` *(number|nil)*:
	- `[padding_w]` *(number|nil)*:

- **Returns:**
	- `` *(druid.layout)*:

### set_dirty

---
```lua
layout:set_dirty()
```

- **Returns:**
	- `` *(druid.layout)*:

### set_justify

---
```lua
layout:set_justify(is_justify)
```

- **Parameters:**
	- `is_justify` *(boolean)*:

- **Returns:**
	- `` *(druid.layout)*:

### set_type

---
```lua
layout:set_type(type)
```

- **Parameters:**
	- `type` *(string)*: The layout type: "horizontal", "vertical", "horizontal_wrap"

- **Returns:**
	- `` *(druid.layout)*:

### set_hug_content

---
```lua
layout:set_hug_content(is_hug_width, is_hug_height)
```

- **Parameters:**
	- `is_hug_width` *(boolean)*:
	- `is_hug_height` *(boolean)*:

- **Returns:**
	- `` *(druid.layout)*:

### add

---
```lua
layout:add(node_or_node_id)
```

Add node to layout

- **Parameters:**
	- `node_or_node_id` *(string|node)*: node_or_node_id

- **Returns:**
	- `` *(druid.layout)*:

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
	- `` *(druid.layout)*:

### clear_layout

---
```lua
layout:clear_layout()
```

- **Returns:**
	- `` *(druid.layout)*:

### get_node_size

---
```lua
layout:get_node_size(node)
```

- **Parameters:**
	- `node` *(node)*:

- **Returns:**
	- `` *(number)*:
	- `` *(number)*:

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
- **node** (_node_)

<a name="rows_data"></a>
- **rows_data** (_druid.layout.rows_data_): Last calculated rows data

<a name="is_dirty"></a>
- **is_dirty** (_boolean_)

<a name="entities"></a>
- **entities** (_node[]_)

<a name="margin"></a>
- **margin** (_{ x: number, y: number }_)

<a name="padding"></a>
- **padding** (_vector4_)

<a name="type"></a>
- **type** (_string_)

<a name="is_resize_width"></a>
- **is_resize_width** (_boolean_)

<a name="is_resize_height"></a>
- **is_resize_height** (_boolean_)

<a name="is_justify"></a>
- **is_justify** (_boolean_)

<a name="on_size_changed"></a>
- **on_size_changed** (_event.on_size_changed_)

<a name="size"></a>
- **size** (_unknown_)

