# druid.grid API

> at /druid/base/static_grid.lua

The component for manage the nodes position in the grid with various options

## Functions

- [init](#init)
- [get_pos](#get_pos)
- [get_index](#get_index)
- [get_index_by_node](#get_index_by_node)
- [set_anchor](#set_anchor)
- [refresh](#refresh)
- [set_pivot](#set_pivot)
- [add](#add)
- [set_items](#set_items)
- [remove](#remove)
- [get_items_count](#get_items_count)
- [get_size](#get_size)
- [get_size_for](#get_size_for)
- [get_borders](#get_borders)
- [get_all_pos](#get_all_pos)
- [set_position_function](#set_position_function)
- [clear](#clear)
- [get_offset](#get_offset)
- [set_in_row](#set_in_row)
- [set_item_size](#set_item_size)
- [sort_nodes](#sort_nodes)
## Fields

- [on_add_item](#on_add_item)
- [on_remove_item](#on_remove_item)
- [on_change_items](#on_change_items)
- [on_clear](#on_clear)
- [on_update_positions](#on_update_positions)
- [parent](#parent)
- [nodes](#nodes)
- [first_index](#first_index)
- [last_index](#last_index)
- [anchor](#anchor)
- [pivot](#pivot)
- [node_size](#node_size)
- [border](#border)
- [in_row](#in_row)
- [style](#style)
- [node_pivot](#node_pivot)



### init

---
```lua
grid:init(parent, element, [in_row])
```

The constructor for the grid component

- **Parameters:**
	- `parent` *(string|node)*: The GUI Node container, where grid's items will be placed
	- `element` *(node)*: Element prefab. Need to get it size
	- `[in_row]` *(number|nil)*: How many nodes in row can be placed. By default 1

### get_pos

---
```lua
grid:get_pos(index)
```

Return pos for grid node index

- **Parameters:**
	- `index` *(number)*: The grid element index

- **Returns:**
	- `position` *(vector3)*: Node position

### get_index

---
```lua
grid:get_index(pos)
```

Return grid index by position

- **Parameters:**
	- `pos` *(vector3)*: The node position in the grid

- **Returns:**
	- `index` *(number)*: The node index

### get_index_by_node

---
```lua
grid:get_index_by_node(node)
```

Return grid index by node

- **Parameters:**
	- `node` *(node)*: The gui node in the grid

- **Returns:**
	- `index` *(number|nil)*: The node index

### set_anchor

---
```lua
grid:set_anchor(anchor)
```

Set grid anchor. Default anchor is equal to anchor of grid parent node

- **Parameters:**
	- `anchor` *(vector3)*: Anchor

### refresh

---
```lua
grid:refresh()
```

Instantly update the grid content

- **Returns:**
	- `self` *(druid.grid)*: Current grid instance

### set_pivot

---
```lua
grid:set_pivot(pivot)
```

Set grid pivot

- **Parameters:**
	- `pivot` *(constant)*: The new pivot

- **Returns:**
	- `self` *(druid.grid)*: Current grid instance

### add

---
```lua
grid:add(item, [index], [shift_policy], [is_instant])
```

Add new item to the grid

- **Parameters:**
	- `item` *(node)*: GUI node
	- `[index]` *(number|nil)*: The item position. By default add as last item
	- `[shift_policy]` *(number|nil)*: How shift nodes, if required. Default: const.SHIFT.RIGHT
	- `[is_instant]` *(boolean|nil)*: If true, update node positions instantly

- **Returns:**
	- `self` *(druid.grid)*: Current grid instance

### set_items

---
```lua
grid:set_items(nodes, [is_instant])
```

Set new items to the grid. All previous items will be removed

- **Parameters:**
	- `nodes` *(node[])*: The new grid nodes
	- `[is_instant]` *(boolean|nil)*: If true, update node positions instantly

- **Returns:**
	- `self` *(druid.grid)*: Current grid instance

### remove

---
```lua
grid:remove(index, [shift_policy], [is_instant])
```

Remove the item from the grid. Note that gui node will be not deleted

- **Parameters:**
	- `index` *(number)*: The grid node index to remove
	- `[shift_policy]` *(number|nil)*: How shift nodes, if required. Default: const.SHIFT.RIGHT
	- `[is_instant]` *(boolean|nil)*: If true, update node positions instantly

- **Returns:**
	- `node` *(node)*: The deleted gui node from grid

### get_items_count

---
```lua
grid:get_items_count()
```

Return items count in grid

- **Returns:**
	- `count` *(number)*: The items count in grid

### get_size

---
```lua
grid:get_size()
```

Return grid content size

- **Returns:**
	- `size` *(vector3)*: The grid content size

### get_size_for

---
```lua
grid:get_size_for(count)
```

Return grid content size for given count of nodes

- **Parameters:**
	- `count` *(number)*: The count of nodes

- **Returns:**
	- `size` *(vector3)*: The grid content size

### get_borders

---
```lua
grid:get_borders()
```

Return grid content borders

- **Returns:**
	- `borders` *(vector4)*: The grid content borders

### get_all_pos

---
```lua
grid:get_all_pos()
```

Return array of all node positions

- **Returns:**
	- `positions` *(vector3[])*: All grid node positions

### set_position_function

---
```lua
grid:set_position_function(callback)
```

Change set position function for grid nodes. It will call on
 update poses on grid elements. Default: gui.set_position

- **Parameters:**
	- `callback` *(function)*: Function on node set position

- **Returns:**
	- `self` *(druid.grid)*: Current grid instance

### clear

---
```lua
grid:clear()
```

Clear grid nodes array. GUI nodes will be not deleted!
 If you want to delete GUI nodes, use static_grid.nodes array before grid:clear

- **Returns:**
	- `self` *(druid.grid)*: Current grid instance

### get_offset

---
```lua
grid:get_offset()
```

Return StaticGrid offset, where StaticGrid content starts.

- **Returns:**
	- `offset` *(vector3)*: The StaticGrid offset

### set_in_row

---
```lua
grid:set_in_row(in_row)
```

Set new in_row elements for grid

- **Parameters:**
	- `in_row` *(number)*: The new in_row value

- **Returns:**
	- `self` *(druid.grid)*: Current grid instance

### set_item_size

---
```lua
grid:set_item_size([width], [height])
```

Set new node size for grid

- **Parameters:**
	- `[width]` *(number|nil)*: The new node width
	- `[height]` *(number|nil)*: The new node height

- **Returns:**
	- `self` *(druid.grid)*: Current grid instance

### sort_nodes

---
```lua
grid:sort_nodes(comparator)
```

Sort grid nodes by custom comparator function

- **Parameters:**
	- `comparator` *(function)*: The comparator function. (a, b) -> boolean

- **Returns:**
	- `self` *(druid.grid)*: Current grid instance


## Fields
<a name="on_add_item"></a>
- **on_add_item** (_event_): fun(self: druid.grid, item: node, index: number) Trigger on add item event

<a name="on_remove_item"></a>
- **on_remove_item** (_event_): fun(self: druid.grid, index: number) Trigger on remove item event

<a name="on_change_items"></a>
- **on_change_items** (_event_): fun(self: druid.grid, index: number) Trigger on change items event

<a name="on_clear"></a>
- **on_clear** (_event_): fun(self: druid.grid) Trigger on clear event

<a name="on_update_positions"></a>
- **on_update_positions** (_event_): fun(self: druid.grid) Trigger on update positions event

<a name="parent"></a>
- **parent** (_node_): Parent node

<a name="nodes"></a>
- **nodes** (_node[]_): Nodes array

<a name="first_index"></a>
- **first_index** (_number_): First index

<a name="last_index"></a>
- **last_index** (_number_): Last index

<a name="anchor"></a>
- **anchor** (_vector3_): Anchor

<a name="pivot"></a>
- **pivot** (_vector3_): Pivot

<a name="node_size"></a>
- **node_size** (_vector3_): Node size

<a name="border"></a>
- **border** (_vector4_): Border

<a name="in_row"></a>
- **in_row** (_number_): In row

<a name="style"></a>
- **style** (_druid.grid.style_): Style

<a name="node_pivot"></a>
- **node_pivot** (_unknown_)

