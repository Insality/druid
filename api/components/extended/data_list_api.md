# druid.data_list API

> at /druid/extended/data_list.lua

Druid component to manage a list of data with a scrollable view, used to manage huge list data and render only visible elements.

### Setup
Create data list component with druid: `data_list = druid:new_data_list(scroll, grid, create_function)`

### Notes
- Data List uses a scroll component for scrolling and a grid component for layout
- Data List only renders visible elements for better performance
- Data List supports caching of elements for better performance
- Data List supports adding, removing and updating elements
- Data List supports scrolling to specific elements
- Data List supports custom element creation and cleanup

## Functions

- [init](#init)
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

The DataList constructor

- **Parameters:**
	- `scroll` *(druid.scroll)*: The Scroll instance for Data List component
	- `grid` *(druid.grid)*: The StaticGrid instance for Data List component
	- `create_function` *(function)*: The create function callback(self, data, index, data_list). Function should return (node, [component])

### set_use_cache

---
```lua
data_list:set_use_cache(is_use_cache)
```

Set use cache version of DataList. Requires make setup of components in on_element_add callback and clean in on_element_remove

- **Parameters:**
	- `is_use_cache` *(boolean)*: Use cache version of DataList

- **Returns:**
	- `self` *(druid.data_list)*: Current DataList instance

### set_data

---
```lua
data_list:set_data(data)
```

Set new data set for DataList component

- **Parameters:**
	- `data` *(table)*: The new data array

- **Returns:**
	- `self` *(druid.data_list)*: Current DataList instance

### get_data

---
```lua
data_list:get_data()
```

Return current data from DataList component

- **Returns:**
	- `data` *(table)*: The current data array

### add

---
```lua
data_list:add(data, [index], [shift_policy])
```

Add element to DataList

- **Parameters:**
	- `data` *(table)*: The data to add
	- `[index]` *(number|nil)*: The index to add the data at
	- `[shift_policy]` *(number|nil)*: The constant from const.SHIFT.*

- **Returns:**
	- `self` *(druid.data_list)*: Current DataList instance

### remove

---
```lua
data_list:remove([index], [shift_policy])
```

Remove element from DataList

- **Parameters:**
	- `[index]` *(number|nil)*: The index to remove the data at
	- `[shift_policy]` *(number|nil)*: The constant from const.SHIFT.*

- **Returns:**
	- `self` *(druid.data_list)*: Current DataList instance

### remove_by_data

---
```lua
data_list:remove_by_data(data, [shift_policy])
```

Remove element from DataList by data value

- **Parameters:**
	- `data` *(table)*: The data to remove
	- `[shift_policy]` *(number|nil)*: The constant from const.SHIFT.*

- **Returns:**
	- `self` *(druid.data_list)*: Current DataList instance

### clear

---
```lua
data_list:clear()
```

Clear the DataList and refresh visuals

- **Returns:**
	- `self` *(druid.data_list)*: Current DataList instance

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

Return all currently created nodes in DataList

- **Returns:**
	- `List` *(node[])*: of created nodes

### get_created_components

---
```lua
data_list:get_created_components()
```

Return all currently created components in DataList

- **Returns:**
	- `components` *(druid.component[])*: List of created components

### scroll_to_index

---
```lua
data_list:scroll_to_index(index)
```

Instant scroll to element with passed index

- **Parameters:**
	- `index` *(number)*: The index to scroll to


## Fields
<a name="scroll"></a>
- **scroll** (_druid.scroll_): The scroll instance for Data List component

<a name="grid"></a>
- **grid** (_druid.grid_): The StaticGrid or DynamicGrid instance for Data List component

<a name="on_scroll_progress_change"></a>
- **on_scroll_progress_change** (_event_): fun(self: druid.data_list, progress: number) The event triggered when the scroll progress changes

<a name="on_element_add"></a>
- **on_element_add** (_event_): fun(self: druid.data_list, index: number, node: node, instance: druid.component, data: table) The event triggered when a new element is added

<a name="on_element_remove"></a>
- **on_element_remove** (_event_): fun(self: druid.data_list, index: number, node: node, instance: druid.component, data: table) The event triggered when an element is removed

<a name="top_index"></a>
- **top_index** (_number_): The top index of the visible elements

<a name="last_index"></a>
- **last_index** (_number_): The last index of the visible elements

<a name="scroll_progress"></a>
- **scroll_progress** (_number_): The scroll progress

