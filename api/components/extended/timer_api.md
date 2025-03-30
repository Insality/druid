# druid.timer API

> at /druid/extended/timer.lua

The component that handles a text to display a seconds timer


## Functions
- [init](#init)
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

### set_to

---
```lua
timer:set_to(set_to)
```

Set the timer to a specific value

- **Parameters:**
	- `set_to` *(number)*: Value in seconds

- **Returns:**
	- `self` *(druid.timer)*: Current timer instance

### set_state

---
```lua
timer:set_state([is_on])
```

Set the timer to a specific value

- **Parameters:**
	- `[is_on]` *(boolean|nil)*: Timer enable state

- **Returns:**
	- `self` *(druid.timer)*: Current timer instance

### set_interval

---
```lua
timer:set_interval(from, to)
```

Set the timer interval

- **Parameters:**
	- `from` *(number)*: Start time in seconds
	- `to` *(number)*: Target time in seconds

- **Returns:**
	- `self` *(druid.timer)*: Current timer instance


## Fields
<a name="on_tick"></a>
- **on_tick** (_event_): fun(context, value) The event triggered when the timer ticks

<a name="on_set_enabled"></a>
- **on_set_enabled** (_event_): fun(context, is_on) The event triggered when the timer is enabled

<a name="on_timer_end"></a>
- **on_timer_end** (_event_): fun(context) The event triggered when the timer ends

<a name="node"></a>
- **node** (_node_): The node to display the timer

<a name="from"></a>
- **from** (_number_): The start time of the timer

<a name="target"></a>
- **target** (_number_): The target time of the timer

<a name="value"></a>
- **value** (_number_): The current value of the timer

<a name="is_on"></a>
- **is_on** (_boolean_): True if the timer is on

<a name="temp"></a>
- **temp** (_unknown_)

<a name="last_value"></a>
- **last_value** (_number_)

