# druid.progress API

> at /druid/extended/progress.lua

The component used to manage a node as a progress bar, changing the size and scale of the node


## Functions
- [init](#init)
- [on_style_change](#on_style_change)
- [on_layout_change](#on_layout_change)
- [on_remove](#on_remove)
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
	- `[init_value]` *(number|nil)*: Initial value of progress bar. Default: 1

### on_style_change

---
```lua
progress:on_style_change(style)
```

- **Parameters:**
	- `style` *(druid.progress.style)*:

### on_layout_change

---
```lua
progress:on_layout_change()
```

### on_remove

---
```lua
progress:on_remove()
```

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
- **node** (_node_)

<a name="on_change"></a>
- **on_change** (_event_)

<a name="style"></a>
- **style** (_druid.progress.style_)

<a name="key"></a>
- **key** (_string_)

<a name="prop"></a>
- **prop** (_hash_)

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

