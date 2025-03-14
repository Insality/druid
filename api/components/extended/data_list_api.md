# druid.data_list API

> at /druid/extended/data_list.lua


## Functions
- [init](#init)
- [on_remove](#on_remove)
- [set_use_cache](#set_use_cache)
- [set_data](#set_data)
- [get_data](#get_data)
- [add](#add)
- [remove](#remove)
- [remove_by_data](#remove_by_data)
- [clear](#clear)
- [get_index](#get_index)
- [get_created_nodes](#get_created_nodes)
- [get_created_components](#get_created_components)
- [scroll_to_index](#scroll_to_index)


## Fields
- [scroll](#scroll)
- [grid](#grid)
- [on_scroll_progress_change](#on_scroll_progress_change)
- [on_element_add](#on_element_add)
- [on_element_remove](#on_element_remove)
- [top_index](#top_index)
- [last_index](#last_index)
- [scroll_progress](#scroll_progress)



### init

---
```lua
data_list:init(scroll, grid, create_function)
```

- **Parameters:**
	- `scroll` *(druid.scroll)*: The Scroll instance for Data List component
	- `grid` *(druid.grid)*: The StaticGrid} or @{DynamicGrid instance for Data List component
	- `create_function` *(function)*: The create function callback(self, data, index, data_list). Function should return (node, [component])

### on_remove

---
```lua
data_list:on_remove()
```

Druid System on_remove function

### set_use_cache

---
```lua
data_list:set_use_cache(is_use_cache)
```

Set refresh function for DataList component

- **Parameters:**
	- `is_use_cache` *(boolean)*: Use cache version of DataList. Requires make setup of components in on_element_add callback and clean in on_element_remove

- **Returns:**
	- `Current` *(druid.data_list)*: DataList instance

### set_data

---
```lua
data_list:set_data(data)
```

Set new data set for DataList component

- **Parameters:**
	- `data` *(table)*: The new data array

- **Returns:**
	- `Current` *(druid.data_list)*: DataList instance

### get_data

---
```lua
data_list:get_data()
```

Return current data from DataList component

- **Returns:**
	- `The` *(table)*: current data array

### add

---
```lua
data_list:add(data, [index], [shift_policy])
```

Add element to DataList. Currenly untested

- **Parameters:**
	- `data` *(table)*:
	- `[index]` *(number|nil)*:
	- `[shift_policy]` *(number|nil)*: The constant from const.SHIFT.*

### remove

---
```lua
data_list:remove([index], [shift_policy])
```

Remove element from DataList. Currenly untested

- **Parameters:**
	- `[index]` *(number|nil)*:
	- `[shift_policy]` *(number|nil)*: The constant from const.SHIFT.*

### remove_by_data

---
```lua
data_list:remove_by_data(data, [shift_policy])
```

Remove element from DataList by data value. Currenly untested

- **Parameters:**
	- `data` *(table)*:
	- `[shift_policy]` *(number|nil)*: The constant from const.SHIFT.*

### clear

---
```lua
data_list:clear()
```

Clear the DataList and refresh visuals

### get_index

---
```lua
data_list:get_index(data)
```

Return index for data value

- **Parameters:**
	- `data` *(table)*:

- **Returns:**
	- `` *(unknown|nil)*:

### get_created_nodes

---
```lua
data_list:get_created_nodes()
```

Return all currenly created nodes in DataList

- **Returns:**
	- `List` *(node[])*: of created nodes

### get_created_components

---
```lua
data_list:get_created_components()
```

Return all currenly created components in DataList

- **Returns:**
	- `List` *(druid.component[])*: of created nodes

### scroll_to_index

---
```lua
data_list:scroll_to_index(index)
```

Instant scroll to element with passed index

- **Parameters:**
	- `index` *(number)*:


## Fields
<a name="scroll"></a>
- **scroll** (_druid.scroll_)

<a name="grid"></a>
- **grid** (_druid.grid_)

<a name="on_scroll_progress_change"></a>
- **on_scroll_progress_change** (_event_)

<a name="on_element_add"></a>
- **on_element_add** (_event_)

<a name="on_element_remove"></a>
- **on_element_remove** (_event_)

<a name="top_index"></a>
- **top_index** (_number_)

<a name="last_index"></a>
- **last_index** (_number_)

<a name="scroll_progress"></a>
- **scroll_progress** (_number_)

