# druid.progress API

> at /druid/extended/progress.lua

Basic Druid progress bar component. Changes the size or scale of a node to represent progress.

### Setup
Create progress bar component with druid: `progress = druid:new_progress(node_name, key, init_value)`

### Notes
- Node should have maximum node size in GUI scene, it represents the progress bar's maximum size
- Key is value from druid const: "x" or "y"
- Progress works correctly with 9slice nodes, it tries to set size by _set_size_ first until minimum size is reached, then it continues sizing via _set_scale_
- Progress bar can fill only by vertical or horizontal size. For diagonal progress bar, just rotate the node in GUI scene
- If you have glitchy or dark texture bugs with progress bar, try to disable mipmaps in your texture profiles

## Functions

- [init](#init)
- [update](#update)
- [fill](#fill)
- [empty](#empty)
- [set_to](#set_to)
- [get](#get)
- [set_steps](#set_steps)
- [to](#to)
- [set_max_size](#set_max_size)

## Fields

- [node](#node)
- [on_change](#on_change)
- [style](#style)
- [key](#key)
- [prop](#prop)
- [scale](#scale)
- [size](#size)
- [max_size](#max_size)
- [slice](#slice)
- [last_value](#last_value)
- [slice_size](#slice_size)
- [target](#target)
- [steps](#steps)
- [step_callback](#step_callback)
- [target_callback](#target_callback)



### init

---
```lua
progress:init(node, key, [init_value])
```

- **Parameters:**
	- `node` *(string|node)*: Node name or GUI Node itself.
	- `key` *(string)*: Progress bar direction: "x" or "y"
	- `[init_value]` *(number|nil)*: Initial value of progress bar (0 to 1). Default: 1

### update

---
```lua
progress:update(dt)
```

- **Parameters:**
	- `dt` *(number)*: Delta time

### fill

---
```lua
progress:fill()
```

Fill the progress bar

- **Returns:**
	- `self` *(druid.progress)*: Current progress instance

### empty

---
```lua
progress:empty()
```

Empty the progress bar

- **Returns:**
	- `self` *(druid.progress)*: Current progress instance

### set_to

---
```lua
progress:set_to(to)
```

Instant fill progress bar to value

- **Parameters:**
	- `to` *(number)*: Progress bar value, from 0 to 1

- **Returns:**
	- `self` *(druid.progress)*: Current progress instance

### get

---
```lua
progress:get()
```

Return the current value of the progress bar

- **Returns:**
	- `value` *(number)*: The current value of the progress bar

### set_steps

---
```lua
progress:set_steps(steps, callback)
```

Set points on progress bar to fire the callback

- **Parameters:**
	- `steps` *(number[])*: Array of progress bar values
	- `callback` *(function)*: Callback on intersect step value

- **Returns:**
	- `self` *(druid.progress)*: Current progress instance

### to

---
```lua
progress:to(to, [callback])
```

Start animation of a progress bar

- **Parameters:**
	- `to` *(number)*: value between 0..1
	- `[callback]` *(function|nil)*: Callback on animation ends

- **Returns:**
	- `self` *(druid.progress)*: Current progress instance

### set_max_size

---
```lua
progress:set_max_size(max_size)
```

Set progress bar max node size

- **Parameters:**
	- `max_size` *(vector3)*: The new node maximum (full) size

- **Returns:**
	- `self` *(druid.progress)*: Current progress instance


## Fields
<a name="node"></a>
- **node** (_node_): The progress bar node

<a name="on_change"></a>
- **on_change** (_event_): fun(self: druid.progress, value: number) Event triggered when progress value changes

<a name="style"></a>
- **style** (_druid.progress.style_): Component style parameters

<a name="key"></a>
- **key** (_string_): Progress bar direction: "x" or "y"

<a name="prop"></a>
- **prop** (_hash_): Property for scaling the progress bar

<a name="scale"></a>
- **scale** (_unknown_)

<a name="size"></a>
- **size** (_unknown_)

<a name="max_size"></a>
- **max_size** (_unknown_)

<a name="slice"></a>
- **slice** (_unknown_)

<a name="last_value"></a>
- **last_value** (_number_)

<a name="slice_size"></a>
- **slice_size** (_unknown_)

<a name="target"></a>
- **target** (_nil_)

<a name="steps"></a>
- **steps** (_number[]_)

<a name="step_callback"></a>
- **step_callback** (_function_)

<a name="target_callback"></a>
- **target_callback** (_function|nil_)

