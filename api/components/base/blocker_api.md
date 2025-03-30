# druid.blocker API

> at /druid/base/blocker.lua


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
- **node** (_node_)

