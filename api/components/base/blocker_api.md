# druid.blocker API

> at /druid/base/blocker.lua

Druid component for block input. Use it to block input in special zone.

### Setup
Create blocker component with druid: `druid:new_blocker(node_name)`

### Notes
- Blocker can be used to create safe zones, where you have big buttons
- Blocker will capture all input events that hit the node, preventing them from reaching other components
- Blocker works placed as usual component in stack, so any other component can be placed on top of it and will work as usual

## Functions

- [init](#init)
- [set_enabled](#set_enabled)
- [is_enabled](#is_enabled)

## Fields

- [node](#node)



### init

---
```lua
blocker:init(node)
```

The Blocker constructor

- **Parameters:**
	- `node` *(string|node)*: The node to use as a blocker

### set_enabled

---
```lua
blocker:set_enabled(state)
```

Set blocker enabled state

- **Parameters:**
	- `state` *(boolean)*: The new enabled state

- **Returns:**
	- `self` *(druid.blocker)*: The blocker instance

### is_enabled

---
```lua
blocker:is_enabled()
```

Get blocker enabled state

- **Returns:**
	- `is_enabled` *(boolean)*: True if the blocker is enabled


## Fields
<a name="node"></a>
- **node** (_node_): The node that will block input

