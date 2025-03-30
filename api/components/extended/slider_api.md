# druid.slider API

> at /druid/extended/slider.lua

The component to make a draggable node over a line with a progress report


## Functions
- [init](#init)
- [on_layout_change](#on_layout_change)
- [on_remove](#on_remove)
- [on_window_resized](#on_window_resized)
- [on_input](#on_input)
- [set](#set)
- [set_steps](#set_steps)
- [set_input_node](#set_input_node)
- [set_enabled](#set_enabled)
- [is_enabled](#is_enabled)


## Fields
- [node](#node)
- [on_change_value](#on_change_value)
- [style](#style)



### init

---
```lua
slider:init(node, end_pos, [callback])
```

The Slider constructor

- **Parameters:**
	- `node` *(node)*: GUI node to drag as a slider
	- `end_pos` *(vector3)*: The end position of slider, should be on the same axis as the node
	- `[callback]` *(function|nil)*: On slider change callback

### on_layout_change

---
```lua
slider:on_layout_change()
```

### on_remove

---
```lua
slider:on_remove()
```

### on_window_resized

---
```lua
slider:on_window_resized()
```

### on_input

---
```lua
slider:on_input(action_id, action)
```

- **Parameters:**
	- `action_id` *(number)*: The action id
	- `action` *(action)*: The action table

- **Returns:**
	- `is_consumed` *(boolean)*: True if the input was consumed

### set

---
```lua
slider:set(value, [is_silent])
```

Set value for slider

- **Parameters:**
	- `value` *(number)*: Value from 0 to 1
	- `[is_silent]` *(boolean|nil)*: Don't trigger event if true

- **Returns:**
	- `self` *(druid.slider)*: Current slider instance

### set_steps

---
```lua
slider:set_steps(steps)
```

Set slider steps. Pin node will
apply closest step position

- **Parameters:**
	- `steps` *(number[])*: Array of steps

- **Returns:**
	- `self` *(druid.slider)*: Current slider instance

### set_input_node

---
```lua
slider:set_input_node([input_node])
```

Set input zone for slider.
User can touch any place of node, pin instantly will
move at this position and node drag will start.
This function require the Defold version 1.3.0+

- **Parameters:**
	- `[input_node]` *(string|node|nil)*:

- **Returns:**
	- `self` *(druid.slider)*: Current slider instance

### set_enabled

---
```lua
slider:set_enabled(is_enabled)
```

Set Slider input enabled or disabled

- **Parameters:**
	- `is_enabled` *(boolean)*: True if slider is enabled

- **Returns:**
	- `self` *(druid.slider)*: Current slider instance

### is_enabled

---
```lua
slider:is_enabled()
```

Check if Slider component is enabled

- **Returns:**
	- `is_enabled` *(boolean)*: True if slider is enabled


## Fields
<a name="node"></a>
- **node** (_node_): The node to manage the slider

<a name="on_change_value"></a>
- **on_change_value** (_event_): The event triggered when the slider value changes

<a name="style"></a>
- **style** (_table_): The style of the slider

