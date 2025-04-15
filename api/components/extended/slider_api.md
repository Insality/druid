# druid.slider API

> at /druid/extended/slider.lua

Basic Druid slider component. Creates a draggable node over a line with progress reporting.

### Setup
Create slider component with druid: `slider = druid:new_slider(node_name, end_pos, callback)`

### Notes
- Pin node should be placed in initial position at zero progress
- It will be available to move Pin node between start pos and end pos
- You can setup points of interests on slider via `slider:set_steps`. If steps exist, slider values will be only from these steps (notched slider)
- Start pos and end pos should be on vertical or horizontal line (their x or y value should be equal)
- To catch input across all slider, you can setup input node via `slider:set_input_node`

## Functions

- [init](#init)
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

