# druid.container API

> at /druid/extended/container.lua


## Functions
- [init](#init)
- [on_late_init](#on_late_init)
- [on_remove](#on_remove)
- [refresh_origins](#refresh_origins)
- [set_pivot](#set_pivot)
- [on_style_change](#on_style_change)
- [set_size](#set_size)
- [get_position](#get_position)
- [set_position](#set_position)
- [get_size](#get_size)
- [get_scale](#get_scale)
- [fit_into_size](#fit_into_size)
- [fit_into_window](#fit_into_window)
- [on_window_resized](#on_window_resized)
- [add_container](#add_container)
- [remove_container_by_node](#remove_container_by_node)
- [set_parent_container](#set_parent_container)
- [refresh](#refresh)
- [refresh_scale](#refresh_scale)
- [update_child_containers](#update_child_containers)
- [create_draggable_corners](#create_draggable_corners)
- [clear_draggable_corners](#clear_draggable_corners)
- [fit_into_node](#fit_into_node)
- [set_min_size](#set_min_size)


## Fields
- [node](#node)
- [druid](#druid)
- [node_offset](#node_offset)
- [origin_size](#origin_size)
- [size](#size)
- [origin_position](#origin_position)
- [position](#position)
- [pivot_offset](#pivot_offset)
- [center_offset](#center_offset)
- [mode](#mode)
- [fit_size](#fit_size)
- [min_size_x](#min_size_x)
- [min_size_y](#min_size_y)
- [on_size_changed](#on_size_changed)
- [node_fill_x](#node_fill_x)
- [node_fill_y](#node_fill_y)
- [x_koef](#x_koef)
- [y_koef](#y_koef)
- [x_anchor](#x_anchor)
- [y_anchor](#y_anchor)
- [style](#style)



### init

---
```lua
container:init(node, mode, [callback])
```

- **Parameters:**
	- `node` *(node)*: Gui node
	- `mode` *(string)*: Layout mode
	- `[callback]` *(fun(self: druid.container, size: vector3)|nil)*: Callback on size changed

### on_late_init

---
```lua
container:on_late_init()
```

### on_remove

---
```lua
container:on_remove()
```

### refresh_origins

---
```lua
container:refresh_origins()
```

### set_pivot

---
```lua
container:set_pivot(pivot)
```

- **Parameters:**
	- `pivot` *(constant)*:

### on_style_change

---
```lua
container:on_style_change(style)
```

- **Parameters:**
	- `style` *(druid.container.style)*:

### set_size

---
```lua
container:set_size([width], [height], [anchor_pivot])
```

Set new size of layout node

- **Parameters:**
	- `[width]` *(number|nil)*:
	- `[height]` *(number|nil)*:
	- `[anchor_pivot]` *(constant|nil)*: If set will keep the corner possition relative to the new size

- **Returns:**
	- `Container` *(druid.container)*:

### get_position

---
```lua
container:get_position()
```

- **Returns:**
	- `` *(unknown)*:

### set_position

---
```lua
container:set_position(pos_x, pos_y)
```

- **Parameters:**
	- `pos_x` *(number)*:
	- `pos_y` *(number)*:

### get_size

---
```lua
container:get_size()
```

Get current size of layout node

- **Returns:**
	- `size` *(vector3)*:

### get_scale

---
```lua
container:get_scale()
```

Get current scale of layout node

- **Returns:**
	- `scale` *(vector3)*:

### fit_into_size

---
```lua
container:fit_into_size(target_size)
```

Set size for layout node to fit inside it

- **Parameters:**
	- `target_size` *(vector3)*:

- **Returns:**
	- `Container` *(druid.container)*:

### fit_into_window

---
```lua
container:fit_into_window()
```

Set current size for layout node to fit inside it

- **Returns:**
	- `Container` *(druid.container)*:

### on_window_resized

---
```lua
container:on_window_resized()
```

### add_container

---
```lua
container:add_container(node_or_container, [mode], [on_resize_callback])
```

- **Parameters:**
	- `node_or_container` *(string|table|druid.container|node)*:
	- `[mode]` *(string|nil)*: stretch, fit, stretch_x, stretch_y. Default: Pick from node, "fit" or "stretch"
	- `[on_resize_callback]` *(fun(self: userdata, size: vector3)|nil)*:

- **Returns:**
	- `Container` *(druid.container)*: New created layout instance

### remove_container_by_node

---
```lua
container:remove_container_by_node([node])
```

- **Parameters:**
	- `[node]` *(any)*:

- **Returns:**
	- `` *(druid.container|nil)*:

### set_parent_container

---
```lua
container:set_parent_container([parent_container])
```

- **Parameters:**
	- `[parent_container]` *(druid.container|nil)*:

### refresh

---
```lua
container:refresh()
```

 Glossary
 Center Offset - vector from node position to visual center of node

### refresh_scale

---
```lua
container:refresh_scale()
```

### update_child_containers

---
```lua
container:update_child_containers()
```

### create_draggable_corners

---
```lua
container:create_draggable_corners()
```

- **Returns:**
	- `Container` *(druid.container)*:

### clear_draggable_corners

---
```lua
container:clear_draggable_corners()
```

- **Returns:**
	- `Container` *(druid.container)*:

### fit_into_node

---
```lua
container:fit_into_node(node)
```

Set node for layout node to fit inside it. Pass nil to reset

- **Parameters:**
	- `node` *(string|node)*: The node_id or gui.get_node(node_id)

- **Returns:**
	- `Layout` *(druid.container)*:

### set_min_size

---
```lua
container:set_min_size([min_size_x], [min_size_y])
```

- **Parameters:**
	- `[min_size_x]` *(number|nil)*:
	- `[min_size_y]` *(number|nil)*:

- **Returns:**
	- `` *(druid.container)*:


## Fields
<a name="node"></a>
- **node** (_node_)

<a name="druid"></a>
- **druid** (_druid.instance_)

<a name="node_offset"></a>
- **node_offset** (_vector4_)

<a name="origin_size"></a>
- **origin_size** (_vector3_)

<a name="size"></a>
- **size** (_vector3_)

<a name="origin_position"></a>
- **origin_position** (_vector3_)

<a name="position"></a>
- **position** (_vector3_)

<a name="pivot_offset"></a>
- **pivot_offset** (_vector3_)

<a name="center_offset"></a>
- **center_offset** (_vector3_)

<a name="mode"></a>
- **mode** (_string_)

<a name="fit_size"></a>
- **fit_size** (_vector3_)

<a name="min_size_x"></a>
- **min_size_x** (_number_)

<a name="min_size_y"></a>
- **min_size_y** (_number_)

<a name="on_size_changed"></a>
- **on_size_changed** (_event_): fun(self: druid.container, size: vector3)

<a name="node_fill_x"></a>
- **node_fill_x** (_nil_)

<a name="node_fill_y"></a>
- **node_fill_y** (_nil_)

<a name="x_koef"></a>
- **x_koef** (_number_)

<a name="y_koef"></a>
- **y_koef** (_number_)

<a name="x_anchor"></a>
- **x_anchor** (_unknown_)

<a name="y_anchor"></a>
- **y_anchor** (_unknown_)

<a name="style"></a>
- **style** (_table_)

