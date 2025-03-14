# druid.timer API

> at /druid/extended/timer.lua


## Functions
- [init](#init)
- [update](#update)
- [on_layout_change](#on_layout_change)
- [set_to](#set_to)
- [set_state](#set_state)
- [set_interval](#set_interval)


## Fields
- [on_tick](#on_tick)
- [on_set_enabled](#on_set_enabled)
- [on_timer_end](#on_timer_end)
- [node](#node)
- [from](#from)
- [target](#target)
- [value](#value)
- [is_on](#is_on)
- [temp](#temp)
- [last_value](#last_value)



### init

---
```lua
timer:init(node, [seconds_from], [seconds_to], [callback])
```

- **Parameters:**
	- `node` *(node)*: Gui text node
	- `[seconds_from]` *(number|nil)*: Start timer value in seconds
	- `[seconds_to]` *(number|nil)*: End timer value in seconds
	- `[callback]` *(function|nil)*: Function on timer end

- **Returns:**
	- `` *(druid.timer)*:

### update

---
```lua
timer:update([dt])
```

- **Parameters:**
	- `[dt]` *(any)*:

### on_layout_change

---
```lua
timer:on_layout_change()
```

### set_to

---
```lua
timer:set_to(set_to)
```

- **Parameters:**
	- `set_to` *(number)*: Value in seconds

- **Returns:**
	- `self` *(druid.timer)*:

### set_state

---
```lua
timer:set_state([is_on])
```

- **Parameters:**
	- `[is_on]` *(boolean|nil)*: Timer enable state

- **Returns:**
	- `self` *(druid.timer)*:

### set_interval

---
```lua
timer:set_interval(from, to)
```

- **Parameters:**
	- `from` *(number)*: Start time in seconds
	- `to` *(number)*: Target time in seconds

- **Returns:**
	- `self` *(druid.timer)*:


## Fields
<a name="on_tick"></a>
- **on_tick** (_event_)

<a name="on_set_enabled"></a>
- **on_set_enabled** (_event_)

<a name="on_timer_end"></a>
- **on_timer_end** (_event_)

<a name="node"></a>
- **node** (_node_)

<a name="from"></a>
- **from** (_number_)

<a name="target"></a>
- **target** (_number_)

<a name="value"></a>
- **value** (_number_)

<a name="is_on"></a>
- **is_on** (_boolean_)

<a name="temp"></a>
- **temp** (_unknown_)

<a name="last_value"></a>
- **last_value** (_number_)

